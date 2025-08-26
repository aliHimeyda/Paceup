// functions/index.js
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Node 20 kullan (firebase.json’da da ayarlayacağız)
export const uploadToBunny = onRequest(
  { region: "europe-west1", cors: true, maxInstances: 1, timeoutSeconds: 30, memory: "256MiB",secrets: ["BUNNY_ACCESS_KEY", "BUNNY_STORAGE_ZONE", "BUNNY_PULL_ZONE"], },
  async (req, res) => {
    try {
      // Sadece PUT/POST kabul et
      if (req.method !== "PUT" && req.method !== "POST") {
        return res.status(405).send("Method Not Allowed");
      }

      // Basit bir koruma: İstersen client'tan bir X-Api-Key iste
      const clientKey = req.header("x-api-key");
      const expected = process.env.CLIENT_API_KEY || ""; // opsiyonel
      if (expected && clientKey !== expected) {
        return res.status(401).send("Unauthorized");
      }

      // Zorunlu query: file
      const fileName = (req.query.file || "").toString();
      const folder = (req.query.folder || "Goal").toString();
      if (!fileName) return res.status(400).send("Missing ?file=photo1.jpg");

      // Bunny ortam değişkenleri
      const storageZone = process.env.BUNNY_STORAGE_ZONE; 
      const accessKey   = process.env.BUNNY_ACCESS_KEY;   
      const pullZone    = process.env.BUNNY_PULL_ZONE;    

      if (!storageZone || !accessKey || !pullZone) {
        return res.status(500).send("Server misconfigured");
      }

      // İstek gövdesini raw alıyoruz (bytes)
      const body = req.rawBody; // v2 onRequest ile hazır geliyor

      const bunnyUrl = `https://storage.bunnycdn.com/${storageZone}/${folder}/${fileName}`;

      const r = await fetch(bunnyUrl, {
        method: "PUT",
        headers: {
          "AccessKey": accessKey,
          "Content-Type": req.header("content-type") || "application/octet-stream",
        },
        body,
      });

      if (r.status === 201) {
        const publicUrl = `https://${pullZone}/${folder}/${fileName}`;
        logger.info("Uploaded to Bunny", { fileName, folder });
        return res.status(200).json({ success: true, url: publicUrl });
      }

      const text = await r.text();
      return res.status(500).json({ success: false, bunnyStatus: r.status, bunnyBody: text });
    } catch (e) {
      logger.error(e);
      return res.status(500).send("Internal Error");
    }
  }
);
