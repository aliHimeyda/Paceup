import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/data/repositories/userDR.dart';
import 'package:paceup/routing/paths.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () async {
      await getUserdata();
      if (UserDR.isready) {
        context.go(Paths.homepage);
      } else {
        context.go(Paths.promotionpage);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(child: Image.asset('./assets/gifs/logo.gif')),
      ),
    );
  }
}
