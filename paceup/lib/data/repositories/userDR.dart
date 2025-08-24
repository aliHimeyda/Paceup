import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/core/constants/remoteDkeys.dart';
import 'package:paceup/data/datasources/locale_datasource/localestorage.dart';
import 'package:paceup/data/datasources/remote_datasource/firebaseservices.dart';
import 'package:paceup/data/models/User.dart';
import 'package:paceup/main.dart';
import 'package:paceup/routing/paths.dart';
import 'package:paceup/widgets/fluttertoast.dart';
import 'package:paceup/widgets/loader.dart';

class UserDR {
  static User? currentuser;
  static bool isready = false;
}

Future<void> signinwithGoogle(BuildContext context) async {
  final userCredential = await signInWithGoogle();
  if (userCredential != null) {
    await saveUserDataLS(userCredential);
    UserDR.currentuser = User(
      uid: userCredential[uidD],
      fullName: userCredential[ufullnameD],
      adress: userCredential[uadressD],
      mobileNumber: userCredential[uphonenoD],
      language: userCredential[ulanguageD],
      theme: userCredential[uthemeD],
    );
    UserDR.isready = true;
    context.go(Paths.homepage);
  } else {
    fluttertoast(context, 'canceled during processing');
  }
}

Future<bool> signOutuser() async {
  getIt<Loader>().loading = true;
  getIt<Loader>().change();
  final process = await signOutUser();
  await deleteUserDataLS();
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
  if (process) {
    UserDR.currentuser = null;
    UserDR.isready = false;

    return true;
  } else {
    return false;
  }
}

Future<void> getUserdata() async {
  getIt<Loader>().loading = true;
  getIt<Loader>().change();
  //from locale source:
  final localUserdata = await getUserDataLS();
  if (localUserdata != null) {
    UserDR.currentuser = User(
      uid: localUserdata[uidD],
      fullName: localUserdata[ufullnameD],
      adress: localUserdata[uadressD],
      mobileNumber: localUserdata[uphonenoD],
      language: localUserdata[ulanguageD],
      theme: localUserdata[uthemeD],
    );
    UserDR.isready = true;
    debugPrint('localden alindi---------------------------------------------');
  } else {
    //from remote source:
    final remoteUserdata = await getUserData();
    if (remoteUserdata != null) {
      UserDR.currentuser = User(
        uid: remoteUserdata[uidD],
        fullName: remoteUserdata[ufullnameD],
        adress: remoteUserdata[uadressD],
        mobileNumber: remoteUserdata[uphonenoD],
        language: remoteUserdata[ulanguageD],
        theme: remoteUserdata[uthemeD],
      );
      UserDR.isready = true;
    } else {
      UserDR.isready = false;
    }
  }
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
}

Future<bool> updateUserData(
  String fullname,
  String number,
  String adress,
  String? language,
  String? theme,
) async {
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
  final newData = {
    ufullnameD: fullname,
    uadressD: adress,
    uphonenoD: number,
    ulanguageD: language,
    uthemeD: theme,
  };
  final process = await changeUserData(newData);
  await updateUserDataLS(newData);
  getIt<Loader>().loading = false;
  getIt<Loader>().change();
  if (process) {
    return true;
  } else {
    return false;
  }
}
