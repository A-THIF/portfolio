import 'dart:async';
import 'package:flutter/material.dart';

class HillsBackground extends StatefulWidget {
  const HillsBackground({super.key});

  @override
  _HillsBackgroundState createState() => _HillsBackgroundState();
}

class _HillsBackgroundState extends State<HillsBackground> {
  double hill1Offset = 0;
  double hill2Offset = 0;
  bool hill1Up = true;
  bool hill2Up = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (mounted) {
        setState(() {
          hill1Offset += hill1Up ? 0.5 : -0.5;
          hill2Offset += hill2Up ? 0.3 : -0.3;

          if (hill1Offset > 5) hill1Up = false;
          if (hill1Offset < -5) hill1Up = true;

          if (hill2Offset > 4) hill2Up = false;
          if (hill2Offset < -4) hill2Up = true;
        });
      }
    });
  }

  // 3. MANDATORY: Clean up the timer when the widget is destroyed
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          height: isDesktop ? 320 : 180,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (isDesktop) ...[
                Positioned(
                  left: -100,
                  bottom: -30 + hill1Offset, // move hill1
                  child: Image.asset(
                    'assets/images/hill_1.png',
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: -20 + hill2Offset, // move hill2 differently
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 60,
                  bottom: -20 + hill2Offset, // same as center hill2
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: -160,
                  bottom: -30 + hill1Offset, // move right hill like hill1
                  child: Image.asset(
                    'assets/images/hill_2.png',
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ] else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, hill2Offset + 10), // move center hill2
                    child: Image.asset(
                      'assets/images/hill_2.png',
                      height: 170,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
