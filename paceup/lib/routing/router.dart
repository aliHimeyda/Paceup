import 'package:go_router/go_router.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/features/home_page/homepage.dart';
import 'package:paceup/features/login_page/loginpage.dart';
import 'package:paceup/features/logo_page/logopage.dart';
import 'package:paceup/features/promotion_page/promotion_page.dart';
import 'package:paceup/routing/paths.dart';

final GoRouter router = GoRouter(
  initialLocation: Paths.logopage,
  routes: [
    GoRoute(
      path: Paths.promotionpage,
      builder: (context, state) => PromotionPage(),
    ),
    GoRoute(path: Paths.logopage, builder: (context, state) => LoadingPage()),
    GoRoute(path: Paths.loginpage, builder: (context, state) => Loginpage()),
    GoRoute(path: Paths.homepage, builder: (context, state) => HomeScreen()),
  ],
);
