import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../routes/app_routes.dart';
import 'home_screen.dart';
import 'loading_screen_opening.dart';

class AppStartWrapper extends StatefulWidget {
  const AppStartWrapper({super.key});

  @override
  State<AppStartWrapper> createState() => _AppStartWrapperState();
}

class _AppStartWrapperState extends State<AppStartWrapper> {
  bool? _sessionRestored;
  bool _alreadyLoaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Restore login state from sessionStorage
    await AppRoutes.restoreSession();

    // Check if loading screen was already shown this tab session
    final flag =
        kIsWeb ? web.window.sessionStorage.getItem('portfolioLoaded') : null;
    final alreadyLoaded = flag == 'true';

    setState(() {
      _alreadyLoaded = alreadyLoaded;
      _sessionRestored = true;
    });
  }

  void _markAsLoaded() {
    if (kIsWeb) {
      web.window.sessionStorage.setItem('portfolioLoaded', 'true');
    }
    setState(() => _alreadyLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionRestored == null) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
          child: child,
        ),
      ),
      child: _alreadyLoaded
          ? const HomeScreen(key: ValueKey('home'))
          : LoadingScreenOpening(
              key: const ValueKey('loading'),
              onLoadingComplete: _markAsLoaded,
            ),
    );
  }
}
