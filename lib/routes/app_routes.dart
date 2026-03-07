import 'package:flutter/material.dart';
import '../screens/lock_screen.dart';
import '../screens/game_update.dart';
import '../screens/mobile_info_screen.dart';
import '../screens/admin_dashboard.dart';

class AppRoutes {
  static const String lock = '/';
  static const String game = '/game';
  static const String mobileInfo = '/mobile-info';
  static const String admin = '/admin-dashboard';

  // 🔐 Temporary session flag
  static bool isLoggedIn = false;
  static String? adminSecret;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case lock:
        return MaterialPageRoute(builder: (_) => const LockScreen());

      case game:
        if (!isLoggedIn) {
          return MaterialPageRoute(builder: (_) => const LockScreen());
        }
        return MaterialPageRoute(builder: (_) => const GameUpdate());

      case mobileInfo:
        final index = settings.arguments as int? ?? 0;

        return MaterialPageRoute(
          builder: (_) => MobileInfoScreen(selectedIndex: index),
        );

      case admin:
        final secret = settings.arguments as String?;

        if (secret == null || secret.isEmpty) {
          return MaterialPageRoute(builder: (_) => const LockScreen());
        }

        return MaterialPageRoute(
          builder: (_) => AdminDashboardRedirect(adminSecret: secret),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LockScreen(),
        );
    }
  }
}
