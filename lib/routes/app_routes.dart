import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/lock_screen.dart';
import '../screens/game_screen.dart';
import '../screens/mobile_info_screen.dart';
import '../screens/admin_dashboard.dart';

class AppRoutes {
  static const String lock = '/';
  static const String game = '/game';
  static const String mobileInfo = '/mobile-info';
  static const String admin = '/admin-secret'; // Hidden route

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case lock:
        return MaterialPageRoute(builder: (_) => const LockScreen());

      case game:
        return MaterialPageRoute(builder: (_) => const GameScreen());

      case mobileInfo:
        return MaterialPageRoute(builder: (_) => const MobileMessageScreen());

      case admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
