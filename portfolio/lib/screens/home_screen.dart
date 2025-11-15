import 'package:flutter/material.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';
import 'about_screen.dart';
import 'experience_screen.dart';
import 'projects_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double worldX = 0; // world scroll offset
  double carX = 0.5; // 0.0 to 1.0 screen position

  bool movingLeft = false;
  bool movingRight = false;

  final double cloudParallax = 0.3;
  final double floorParallax = 1.0;
  final double objectParallax = 1.0;

  final double leftLimit = 0.25;
  final double rightLimit = 0.75;

  static const double floorHeight = 250;

  void startLeft() {
    movingLeft = true;
    _gameLoop();
  }

  void startRight() {
    movingRight = true;
    _gameLoop();
  }

  void stopLeft() => movingLeft = false;
  void stopRight() => movingRight = false;

  void _gameLoop() async {
    while (movingLeft || movingRight) {
      setState(() {
        if (movingLeft) _moveLeft();
        if (movingRight) _moveRight();
      });
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  void _moveLeft() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double carSpeed = screenWidth * 0.005;
    final double worldSpeed = screenWidth * 0.004;

    if (carX > leftLimit) {
      carX -= carSpeed / screenWidth;
    } else {
      worldX += worldSpeed;
    }
  }

  void _moveRight() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double carSpeed = screenWidth * 0.005;
    final double worldSpeed = screenWidth * 0.004;

    if (carX < rightLimit) {
      carX += carSpeed / screenWidth;
    } else {
      worldX -= worldSpeed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SKY
        Positioned.fill(
          child: Image.asset('assets/sky.png', fit: BoxFit.cover),
        ),

        // CLOUDS
        Positioned.fill(child: CloudsWidget(position: worldX * cloudParallax)),

        // FLOOR
        Align(
          alignment: Alignment.bottomCenter,
          child: FloorWidget(position: worldX * floorParallax),
        ),

        // SIGNPOST - TAPPABLE
        Positioned(
          bottom: floorHeight * 0.28,
          left: worldX * objectParallax + 300,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ); // example
            },
            child: Image.asset('assets/signpost-home.png', width: 140),
          ),
        ),

        // CAR
        CarWidget(screenX: carX),

        // CONTROLS
        ControlsWidget(
          onLeftStart: startLeft,
          onLeftEnd: stopLeft,
          onRightStart: startRight,
          onRightEnd: stopRight,
        ),
      ],
    );
  }
}
