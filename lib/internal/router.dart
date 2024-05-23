import 'package:exchange_rate_app/presentation/screens/auth.dart';
import 'package:exchange_rate_app/presentation/screens/exchange.dart';
import 'package:exchange_rate_app/presentation/screens/home.dart';
import 'package:exchange_rate_app/presentation/screens/tutorial.dart';
import 'package:exchange_rate_app/presentation/screens/user.dart';
import 'package:exchange_rate_app/presentation/widgets/screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage routingAnimation (ValueKey pageKey, Widget child) => CustomTransitionPage(
  key: pageKey,
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity:
      CurveTween(curve: Curves.easeInOutCirc).animate(animation),
      child: child,
    );
  },
);

final GoRouter router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthScreen(),
    ),
    GoRoute(
      path: '/tutorial',
      builder: (context, state) {
        final username = state.extra as String? ?? 'Unknown';
        return TutorialScreen(username: username);
      },
    ),
    ShellRoute(
      builder: (_, state, child) => ScreenLayout(body: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return routingAnimation(state.pageKey, HomeScreen());
          },
        ),
        GoRoute(
          path: '/exchange',
          pageBuilder: (context, state) {
            return routingAnimation(state.pageKey, ConversionScreen());
          },
        ),
        GoRoute(
          path: '/user',
          pageBuilder: (context, state) {
            return routingAnimation(state.pageKey, UserScreen());
          },
        ),
      ],
    ),
  ],
);