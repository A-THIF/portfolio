// Check if user already loaded portfolio
// Decide which screen to show
// Handle crossfade animation
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'home_screen.dart';
import 'loading_screen_opening.dart';

class AppStartWrapper extends StatefulWidget {
  const AppStartWrapper({super.key});

  @override
  State<AppStartWrapper> createState() => _AppStartWrapperState();
}

class _AppStartWrapperState extends State<AppStartWrapper> {
  bool _alreadyLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoaded();
  }

  void _checkIfLoaded() {
    final flag = web.window.localStorage['portfolioLoaded'];

    if (flag == 'true') {
      setState(() {
        _alreadyLoaded = true;
      });
    }
  }

  void _markAsLoaded() {
    web.window.localStorage['portfolioLoaded'] = 'true';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _alreadyLoaded
          ? const HomeScreen(key: ValueKey("home"))
          : LoadingScreenOpening(
              key: const ValueKey("loading"),
              onLoadingComplete: () {
                _markAsLoaded();
                setState(() {
                  _alreadyLoaded = true;
                });
              },
            ),
    );
  }
}
