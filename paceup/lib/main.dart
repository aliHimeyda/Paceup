import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:paceup/core/services/loader.dart';
import 'package:paceup/core/theme/apptheme.dart';
import 'package:paceup/features/home_page/homepageprovider.dart';
import 'package:paceup/features/login_page/loginpageprovider.dart';
import 'package:paceup/features/promotion_page/promotion_page.dart';
import 'package:paceup/features/promotion_page/promotion_provider.dart';
import 'package:paceup/routing/router.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Loader>(() => Loader());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Loader>.value(value: getIt<Loader>()),
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(create: (_) => PromotionPageProvider()),
        ChangeNotifierProvider(create: (_) => Loginpageprovider()),
        ChangeNotifierProvider(create: (_) => HomepageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, viewModel, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: viewModel.theme,
        routerConfig: router,
      ),
    );
  }
}
