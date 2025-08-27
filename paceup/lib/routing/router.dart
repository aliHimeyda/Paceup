import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/bottomnavigation.dart';
import 'package:paceup/data/models/dailyGoal.dart';
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
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.progresspage,
              builder: (context, state) => const Progresspage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.challengespage,
              builder: (context, state) => const ChallengesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.profilepage,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.progressresultpage,
              builder: (context, state) {
                final image = state.extra as Uint8List;
                return ProgressResultPage(resultimage: image);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.promotionpage,
              builder: (context, state) => const PromotionPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.comingsoonpage,
              builder: (context, state) => const Comingsoonpage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.notificationspage,
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.logopage,
              builder: (context, state) => const LoadingPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey:
              GlobalKey<NavigatorState>(), // Alt navigator için yeni key
          routes: [
            GoRoute(
              path: Paths.loginpage,
              builder: (context, state) => const Loginpage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Paths.gopage,
      parentNavigatorKey: routerkey, // shell’in ÜSTÜNDE aç
      builder: (context, state) {
        final goal = state.extra as Dailygoal;
        return GoPage(currentgoal: goal,);
      },
    ),
  ],
);
