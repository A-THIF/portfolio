import 'package:flutter/material.dart';

class HillsBackground extends StatelessWidget {
  const HillsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width >= 800;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: SizedBox(
          height: isDesktop ? 320 : 180, // 👈 bigger overall height
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 💻 DESKTOP MODE
              if (isDesktop) ...[
                // 🌄 LEFT (half visible)
                Positioned(
                  left: -100, // 👈 push outside screen
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/hill_1.png',
                    height: 260, // 👈 bigger size
                    fit: BoxFit.contain,
                  ),
                ),

                // ⛰ CENTER (main big hill)
                Positioned(
                  right: 30,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 200, // 👈 biggest
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 60,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 200, // 👈 biggest
                    fit: BoxFit.contain,
                  ),
                ),

                // 🌄 RIGHT (half visible)
                Positioned(
                  right: -160, // 👈 push outside screen
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ]
              // 📱 MOBILE MODE (unchanged)
              else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 170,
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
