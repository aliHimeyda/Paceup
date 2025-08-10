import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:paceup/core/services/loader.dart';
import 'package:paceup/main.dart';
import 'package:paceup/routing/paths.dart';

class Firebaseservices {
  static User? currentuser;
  static bool isloading = false;
}

Future<void> getcurrentuser() async {
  Firebaseservices.currentuser = FirebaseAuth.instance.currentUser;
  Firebaseservices.isloading = true;
}

Future<void> addveri(Map<String, dynamic> veri) async {
  await FirebaseFirestore.instance.collection('gelirgidertablosu').add(veri);
}

Future<Map<String, dynamic>?> getUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('userdata')
      .doc(uid)
      .get();

  if (querySnapshot.exists) {
    debugPrint(querySnapshot.data().toString());
    return querySnapshot.data();
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> changeUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final querySnapshot = await FirebaseFirestore.instance
      .collection('userdata')
      .doc(uid)
      .get();

  if (querySnapshot.exists) {
    return querySnapshot.data();
  } else {
    return null;
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

Future<UserCredential?> signInWithGoogle() async {
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
      Firebaseservices.currentuser = user;
      Firebaseservices.isloading = true;

      final userDoc = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid)
            .set({
              'ID': user.uid,
              'namesurname': user.displayName ?? '',
              'mail': user.email ?? '',
              'phoneno': '',
              'password': '',
            });
      }
    }

    getIt<Loader>().loading = false;
    getIt<Loader>().change();
    return userCredential;
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

    context.pushReplacement(Paths.homepage);
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

    final uid = userCredential.user!.uid;
    final veri = {
      'ID': uid, // UID kullanmak daha doğru
      'isimsoyisim': namesurname,
      'mail': mail,
      'sifre': password, // DİKKAT: Güvenli değil
      'telefon': "NO",
    };

    // Firestore'a kaydet — UID ile eşleştir
    await FirebaseFirestore.instance
        .collection('kullanicibilgileri')
        .doc(uid)
        .set(veri);
    context.go(Paths.homepage);
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

Future<void> signinwithGoogle(BuildContext context) async {
  final userCredential = await signInWithGoogle();
  if (userCredential != null) {
    print('Giriş Başarılı: ${userCredential.user?.displayName}');
    context.push(Paths.homepage);
  } else {
    print('Giriş iptal edildi veya hata oluştu');
  }
}
