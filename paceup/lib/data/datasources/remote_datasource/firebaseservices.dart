import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:paceup/core/constants/remoteDkeys.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/main.dart';

Future<void> addveri(Map<String, dynamic> veri) async {
  await FirebaseFirestore.instance.collection('gelirgidertablosu').add(veri);
}

Future<bool> signOutUser() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } catch (e) {
    return false;
  }
}

Future<Map<String, dynamic>?> getUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection(userdataCollection)
      .doc(uid)
      .get();

  if (querySnapshot.exists) {
    return querySnapshot.data();
  } else {
    return null;
  }
}

Future<bool> changeUserData(Map<String, dynamic> newData) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  try {
    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .update(newData);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<Map<String, dynamic>?>> getUsermoneyData(
  DateTime baslangictarih,
  DateTime bitistarih,
) async {
  debugPrint(
    "baslangic :${baslangictarih.toString()}   bitis : ${bitistarih.toString()}",
  );
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('gelirgidertablosu')
      .where('ID', isEqualTo: uid)
      .where('tarih', isGreaterThanOrEqualTo: baslangictarih)
      .where('tarih', isLessThan: bitistarih)
      .orderBy('tarih', descending: true)
      .get();
  debugPrint(
    'gelen listenin boyutu :=====  ${querySnapshot.docs.map((doc) => doc.data()).toList().length}',
  );
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
  return [];
}

Future<int> getUsermoneytoplami(
  DateTime baslangictarih,
  DateTime bitistarih,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('gelirgidertablosu')
      .where('ID', isEqualTo: uid)
      .where('tarih', isGreaterThanOrEqualTo: baslangictarih)
      .where('tarih', isLessThan: bitistarih)
      .orderBy('tarih', descending: true)
      .get();
  int toplamgelir = 0;
  List<Map<String, dynamic>> bilgiler = querySnapshot.docs
      .map((doc) => doc.data())
      .toList();
  int verisayisi = bilgiler.length;
  for (int i = 0; i < verisayisi; i++) {
    if (!bilgiler[i]['gidermi']) {
      toplamgelir += bilgiler[i]['deger'] as int;
    }
  }
  return toplamgelir;
}

Future<void> tumkayitlarisil(
  DateTime baslangictarih,
  DateTime bitistarih,
) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('gelirgidertablosu')
      .where('ID', isEqualTo: uid)
      .where('tarih', isGreaterThanOrEqualTo: baslangictarih)
      .where('tarih', isLessThan: bitistarih)
      .orderBy('tarih', descending: true)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
}

// Future<void> kayitsil(HareketModel hareket) async {
//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   final querySnapshot = await FirebaseFirestore.instance
//       .collection('gelirgidertablosu')
//       .where('ID', isEqualTo: uid)
//       .where('aciklama', isEqualTo: hareket.aciklama)
//       .where('baslik', isEqualTo: hareket.baslik)
//       .where('deger', isEqualTo: hareket.deger)
//       .get();

//   for (var doc in querySnapshot.docs) {
//     await doc.reference.delete();
//   }
// }

Future<int> getUserborctoplami(
  DateTime baslangictarih,
  DateTime bitistarih,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('gelirgidertablosu')
      .where('ID', isEqualTo: uid)
      .where('tarih', isGreaterThanOrEqualTo: baslangictarih)
      .where('tarih', isLessThan: bitistarih)
      .orderBy('tarih', descending: true)
      .get();
  int toplamborc = 0;
  List<Map<String, dynamic>> bilgiler = querySnapshot.docs
      .map((doc) => doc.data())
      .toList();
  int verisayisi = bilgiler.length;
  for (int i = 0; i < verisayisi; i++) {
    if (bilgiler[i]['gidermi']) {
      toplamborc += bilgiler[i]['deger'] as int;
    }
  }
  return toplamborc;
}

Future<Map<String, dynamic>?> signInWithGoogle() async {
  getIt<Loader>().loading = true;
  getIt<Loader>().change();
  try {
    debugPrint('basladi');
    // v7: kullanıcı akışını başlat
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();
    if (googleUser == null) {
      getIt<Loader>().loading = false;
      getIt<Loader>().change();
      return null;
    }

    // v7: sadece idToken var; Firebase için yeterli
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    debugPrint('idToken null mu? ${googleAuth.idToken == null}');
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      // accessToken artık authorization akışında; Firebase giriş için şart değil
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    final user = userCredential.user;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection(userdataCollection)
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        final locale = ui.PlatformDispatcher.instance.locale;
        debugPrint('bilgiler alindiiiiiiiiiiiiiiiiii');
        await FirebaseFirestore.instance
            .collection(userdataCollection)
            .doc(user.uid)
            .set({
              uidD: user.uid,
              ufullnameD: user.displayName ?? '',
              umailD: user.email ?? '',
              uadressD: '',
              uphonenoD: '',
              upasswordD: '',
              ulanguageD: locale,
              uthemeD: 'light',
            });
      }
      getIt<Loader>().loading = false;
      getIt<Loader>().change();
      debugPrint(userDoc.data().toString());
      return userDoc.data();
    } else {
      getIt<Loader>().loading = false;
      getIt<Loader>().change();
      return null;
    }
  } catch (e) {
    getIt<Loader>().loading = false;
    getIt<Loader>().change();
    debugPrint('Google Sign-In Hatası: $e');
    return null;
  }
}

Future<String?> resimYukleVeLinkAl() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  getIt<Loader>().loading = true;
  getIt<Loader>().change();
  if (image == null) return null;

  final apiKey = "6c92a28a573e07438d5e0c35cea3da08";

  final bytes = await File(image.path).readAsBytes();
  final base64Image = base64Encode(bytes);

  final response = await http.post(
    Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
    body: {
      "image": base64Image,
      "name": "resim_${DateTime.now().millisecondsSinceEpoch}",
    },
  );
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json["data"]["url"];
  } else {
    print("Hata: ${response.body}");
    return null;
  }
}

Future<String?> cekilenresmiYukleVeLinkAl(String imagepath) async {
  getIt<Loader>().loading = true;
  getIt<Loader>().change();
  final apiKey = "6c92a28a573e07438d5e0c35cea3da08";

  final bytes = await File(imagepath).readAsBytes();
  final base64Image = base64Encode(bytes);

  final response = await http.post(
    Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
    body: {
      "image": base64Image,
      "name": "resim_${DateTime.now().millisecondsSinceEpoch}",
    },
  );
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json["data"]["url"];
  } else {
    print("Hata: ${response.body}");
    return null;
  }
}

Future<void> girisYap(
  BuildContext context,
  String email,
  String password,
) async {
  final mail = email;
  final sifre = password;

  // 1. Klavyeyi kapat
  FocusScope.of(context).unfocus();

  if (mail.isEmpty || sifre.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("E-posta ve şifre boş olamaz")),
    );
    return;
  }

  try {
    // Firebase Auth ile giriş
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mail,
      password: sifre,
    );
  } on FirebaseAuthException catch (e) {
    String mesaj = "Giriş başarısız";

    if (e.code == 'user-not-found') {
      mesaj = "Kullanıcı bulunamadı";
    } else if (e.code == 'wrong-password') {
      mesaj = "Şifre yanlış";
    } else if (e.code == 'invalid-email') {
      mesaj = "Geçersiz e-posta";
    } else if (e.code == 'user-disabled') {
      mesaj = "Kullanıcı devre dışı bırakılmış";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
  }
}

Future<void> kayitEkle(
  BuildContext context,
  String namesurname,
  String mail,
  String password,
) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: mail, password: password);

    final user = userCredential.user;
    if (user != null) {
      // Firestore'a kaydet — UID ile eşleştir
      await FirebaseFirestore.instance
          .collection('kullanicibilgileri')
          .doc(user.uid)
          .set({
            uidD: user.uid,
            ufullnameD: user.displayName ?? '',
            umailD: user.email ?? '',
            uadressD: '',
            uphonenoD: '',
            upasswordD: '',
          });
    }
  } on FirebaseAuthException catch (e) {
    String mesaj = "Bir hata oluştu";

    if (e.code == 'invalid-email') {
      mesaj = "Geçersiz e-posta formatı";
    } else if (e.code == 'email-already-in-use') {
      mesaj = "Bu e-posta zaten kayıtlı";
    } else if (e.code == 'weak-password') {
      mesaj = "Şifre en az 6 karakter olmalı";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Beklenmeyen bir hata oluştu")),
    );
  }
}
// images upload:

Future<String> uploadToBunny(
  Uint8List fileBytes,
  String fileName, {
  String folder = "Goal",
}) async {
  final url = Uri.parse(
    "https://uploadtobunny-gv2tn4psvq-ew.a.run.app"
    "?file=$fileName&folder=$folder",
  );

  final response = await http.put(
    url,
    headers: {"Content-Type": "application/octet-stream"},
    body: fileBytes,
  );

  if (response.statusCode == 200) {
    print("Upload successful: ${response.body}");
    return response.body;
  } else {
    throw Exception("Upload failed: ${response.statusCode} ${response.body}");
  }
}
