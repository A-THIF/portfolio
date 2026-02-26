import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoadingScreenOpening extends StatefulWidget {
  const LoadingScreenOpening({super.key});

  @override
  State<LoadingScreenOpening> createState() => _LoadingScreenOpeningState();
}

class _LoadingScreenOpeningState extends State<LoadingScreenOpening>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;

  int progress = 0;
  bool showHome = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _startLoading();
  }

  Future<void> _startLoading() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (mounted) {
        setState(() {
          progress = i;
        });
      }
    }

    await _fadeController.forward();

    if (mounted) {
      setState(() {
        showHome = true;
      });
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double logoSize = screenWidth * 0.18;
    logoSize = logoSize.clamp(70.0, 160.0);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      child: showHome
          ? const HomeScreen()
          : Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Rotating Logo
                    RotationTransition(
                      turns: _rotationController,
                      child: Image.asset(
                        "assets/images/loading_logo.png",
                        width: logoSize, // ✅ USE IT HERE
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Percentage
                    Text(
                      "$progress%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
