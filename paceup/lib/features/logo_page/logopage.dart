import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/core/utils/remote_data_metods.dart';
import 'package:paceup/data/datasources/remote_datasource/firebaseservices.dart';
import 'package:paceup/routing/paths.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await getcurrentuser();
      }
      if (Firebaseservices.isloading) {
        context.pushReplacement(Paths.homepage);
      } else {
        context.pushReplacement(Paths.promotionpage);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(child: Image.asset('./assets/gifs/logo.gif')),
      ),
    );
  }
}
