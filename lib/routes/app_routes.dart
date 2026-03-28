import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;
import '../screens/lock_screen.dart';
import '../screens/game_update.dart';
import '../screens/mobile_info_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const String lock = '/';
  static const String home = '/home';
  static const String game = '/game';
  static const String mobileInfo = '/mobile-info';
  static const String admin = '/admin-dashboard';

  static bool isLoggedIn = false;

  /// Called once at startup — restores session from sessionStorage (tab-lifetime only)
  static Future<void> restoreSession() async {
    if (kIsWeb) {
      isLoggedIn = web.window.sessionStorage.getItem('is_logged_in') == 'true';
    } else {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    }
  }

  /// Call this right after successful login
  static Future<void> setLoggedIn({String? jwtToken}) async {
    isLoggedIn = true;
    if (kIsWeb) {
      web.window.sessionStorage.setItem('is_logged_in', 'true');
      if (jwtToken != null) {
        web.window.sessionStorage.setItem('jwt_token', jwtToken);
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      if (jwtToken != null) await prefs.setString('jwt_token', jwtToken);
    }
  }

  static Future<void> clearSession() async {
    isLoggedIn = false;
    if (kIsWeb) {
      web.window.sessionStorage.removeItem('is_logged_in');
      web.window.sessionStorage.removeItem('jwt_token');
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_logged_in');
      await prefs.remove('jwt_token');
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case game:
        if (!isLoggedIn)
          return MaterialPageRoute(builder: (_) => const LockScreen());
        return MaterialPageRoute(builder: (_) => const GameUpdate());

      case mobileInfo:
        if (!isLoggedIn)
          return MaterialPageRoute(builder: (_) => const LockScreen());
        final index = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => MobileInfoScreen(selectedIndex: index));

      case admin:
        final secret = settings.arguments as String?;
        if (secret == null || secret.isEmpty) {
          return MaterialPageRoute(builder: (_) => const LockScreen());
        }
        return MaterialPageRoute(
            builder: (_) => AdminDashboardRedirect(adminSecret: secret));

      case lock:
      default:
        return MaterialPageRoute(builder: (_) => const LockScreen());
    }
  }
}
