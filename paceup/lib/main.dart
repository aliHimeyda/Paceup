import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/core/theme/apptheme.dart';
import 'package:paceup/features/Gopage/goprovider.dart';
import 'package:paceup/features/challenges_page/challengespageprovider.dart';
import 'package:paceup/features/home_page/homepageprovider.dart';
import 'package:paceup/features/login_page/loginpageprovider.dart';
import 'package:paceup/features/notifications_page/notificationsprovider.dart';
import 'package:paceup/features/progress_page/progresspageprovider.dart';
import 'package:paceup/features/progress_result_page/progressResultprovider.dart';
import 'package:paceup/features/promotion_page/promotion_provider.dart';
import 'package:paceup/routing/router.dart';
import 'package:paceup/widgets/monthlySteps/monthlyStepsprovider.dart';
import 'package:paceup/widgets/searchW/searchWprovider.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;
Future<void> initGoogle() async {
  await GoogleSignIn.instance.initialize(
    // Android için WEB CLIENT ID zorunlu olabilir:
    serverClientId:
        '919684569202-2mh2gbfj55d74gnit4k62l9v4erff70o.apps.googleusercontent.com',
    // iOS/macOS kullanıyorsan ayrıca:
    // clientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
  );
}

void setupLocator() {
  getIt.registerLazySingleton<Loader>(() => Loader());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initGoogle();
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Loader>.value(value: getIt<Loader>()),
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(create: (_) => PromotionPageProvider()),
        ChangeNotifierProvider(create: (_) => Loginpageprovider()),
        ChangeNotifierProvider(create: (_) => HomepageProvider()),
        ChangeNotifierProvider(create: (_) => Progressresultprovider()),
        ChangeNotifierProvider(create: (_) => Progresspageprovider()),
        ChangeNotifierProvider(create: (_) => Monthlystepsprovider()),
        ChangeNotifierProvider(create: (_) => Challengespageprovider()),
        ChangeNotifierProvider(create: (_) => Searchwprovider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => GoProvider()),
        ChangeNotifierProvider(create: (_) => GoValuesprovider()),
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
