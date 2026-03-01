import 'package:flutter/material.dart';

class CloudsWidget extends StatefulWidget {
  const CloudsWidget({super.key});

  @override
  State<CloudsWidget> createState() => _CloudsWidgetState();
}

class _CloudsWidgetState extends State<CloudsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40), // master speed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Different speeds
        double offsetSlow = _controller.value * screenWidth;
        double offsetFast = _controller.value * screenWidth * 1.5;

        return Stack(
          children: [
            /// ☁️ CLOUD 1 (Top - Slower)
            Positioned(
              left: -offsetSlow,
              top: screenHeight * 0.02,
              child: Image.asset(
                'assets/images/clouds.png',
                width: screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),

            /// ☁️ CLOUD 2 (Lower - Faster)
            Positioned(
              left: screenWidth - offsetFast,
              top: screenHeight * 0.05,
              child: Image.asset(
                'assets/images/clouds.png',
                width: screenWidth,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}
