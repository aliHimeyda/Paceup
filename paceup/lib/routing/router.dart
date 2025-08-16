import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/bottomnavigation.dart';
import 'package:paceup/core/constants/global_values.dart';
import 'package:paceup/features/Gopage/gopage.dart';
import 'package:paceup/features/challenges_page/challengespage.dart';
import 'package:paceup/features/comingsonepage/comingsoonpage.dart';
import 'package:paceup/features/home_page/homepage.dart';
import 'package:paceup/features/login_page/loginpage.dart';
import 'package:paceup/features/logo_page/logopage.dart';
import 'package:paceup/features/notifications_page/notificationspage.dart';
import 'package:paceup/features/profile_page/profilepage.dart';
import 'package:paceup/features/progress_page/progresspage.dart';
import 'package:paceup/features/progress_result_page/progressResult.dart';
import 'package:paceup/features/promotion_page/promotion_page.dart';
import 'package:paceup/routing/paths.dart';

final routerkey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: routerkey,
  initialLocation: Paths.logopage,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          Bottomnavigation(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.homepage,
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.progresspage,
              builder: (context, state) => Progresspage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.challengespage,
              builder: (context, state) => ChallengesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.profilepage,
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(path: Paths.gopage, builder: (context, state) => GoPage()),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.progressresultpage,
              builder: (context, state) => ProgressResultPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.promotionpage,
              builder: (context, state) => PromotionPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.comingsoonpage,
              builder: (context, state) => Comingsoonpage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.notificationspage,
              builder: (context, state) => NotificationsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.logopage,
              builder: (context, state) => LoadingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.loginpage,
              builder: (context, state) => Loginpage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
