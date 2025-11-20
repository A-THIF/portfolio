import 'package:flutter/material.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';
import '../widgets/signpost_widget.dart';
import '../widgets/loading_profile_card.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double worldX = 0;
  double carX = 0.5;

  bool movingLeft = false;
  bool movingRight = false;
  bool _isLoopRunning = false;

  final double cloudParallax = 0.3;
  final double floorParallax = 1.0;
  final double objectParallax = 1.0;
  final double cardVisibleThresholdStart = 0.0;
  final double cardVisibleThresholdEnd =
      1.0; // Adjust as needed for visibility range
  final double signpostPositionX = 5; // X position of the HOME signpost
  final double signpostOffsetX = 70; // Offset to center the card above the
  final double leftLimit = 0.25;
  final double rightLimit = 0.75;

  static const double floorHeight = 63; // perfect height touching the floor

  void startLeft() {
    if (!movingLeft) {
      movingLeft = true;
      movingRight = false;
      _gameLoop();
    }
  }

  void startRight() {
    if (!movingRight) {
      movingRight = true;
      movingLeft = false;
      _gameLoop();
    }
  }

  void stopLeft() => movingLeft = false;
  void stopRight() => movingRight = false;

  void stopAll() {
    movingLeft = false;
    movingRight = false;
  }

  void _gameLoop() async {
    if (_isLoopRunning) return;
    _isLoopRunning = true;

    while (movingLeft || movingRight) {
      setState(() {
        if (movingLeft) _moveLeft();
        if (movingRight) _moveRight();
      });
      await Future.delayed(const Duration(milliseconds: 16));
    }

    _isLoopRunning = false;
  }

  void _moveLeft() {
    final screenWidth = MediaQuery.of(context).size.width;

    // mobile boost
    final bool isMobile = screenWidth < 600;
    final double speedBoost = isMobile ? 1.4 : 1.0;

    final double carSpeed = screenWidth * 0.005 * speedBoost;
    final double worldSpeed = screenWidth * 0.004 * speedBoost;

    if (carX > leftLimit) {
      carX -= carSpeed / screenWidth;
    } else {
      worldX += worldSpeed;
    }
  }

  void _moveRight() {
    final screenWidth = MediaQuery.of(context).size.width;

    // mobile boost
    final bool isMobile = screenWidth < 600;
    final double speedBoost = isMobile ? 1.4 : 1.0;

    final double carSpeed = screenWidth * 0.005 * speedBoost;
    final double worldSpeed = screenWidth * 0.004 * speedBoost;

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
        Positioned.fill(child: CloudsWidget(position: -worldX * cloudParallax)),

        // FLOOR
        Align(
          alignment: Alignment.bottomCenter,
          child: FloorWidget(position: worldX * floorParallax),
        ),

        // -------------------------
        // SIGNPOSTS (6 total)
        // -------------------------

        // HOME SIGNPOST
        SignpostWidget(
          worldX: worldX,
          positionX: 300,
          floorHeight: floorHeight,
          asset: 'assets/signpost-home.png',
          width: 140,
          onTap: () {
            // Already on home → do nothing
          },
        ),

        // ABOUT ME
        SignpostWidget(
          worldX: worldX,
          positionX: 900,
          floorHeight: floorHeight,
          asset: 'assets/signpost-aboutme.png',
          width: 140,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
          },
        ),

        // SKILLS
        SignpostWidget(
          worldX: worldX,
          positionX: 1500,
          floorHeight: floorHeight,
          asset: 'assets/signpost-skills.png',
          width: 140,
        ),

        // LEADERSHIP
        SignpostWidget(
          worldX: worldX,
          positionX: 2100,
          floorHeight: floorHeight,
          asset: 'assets/signpost-leadership.png',
          width: 140,
        ),

        // EXPERIENCE
        SignpostWidget(
          worldX: worldX,
          positionX: 2700,
          floorHeight: floorHeight,
          asset: 'assets/signpost-experience.png',
          width: 140,
        ),

        // PROJECTS
        SignpostWidget(
          worldX: worldX,
          positionX: 3300,
          floorHeight: floorHeight,
          asset: 'assets/signpost-project.png',
          width: 140,
        ),

        // CAR
        CarWidget(screenX: carX),

        // Define a threshold around the starting position to show the card

        // Then use this in build method:
        Positioned(
          left: worldX + signpostPositionX + signpostOffsetX,
          bottom: floorHeight + 150, // above the floor
          child: const LoadingProfileCard(),
        ),

        // CONTROLS
        ControlsWidget(
          onLeftStart: startLeft,
          onLeftEnd: stopLeft,
          onRightStart: startRight,
          onRightEnd: stopRight,
          onStopAll: stopAll,
        ),
      ],
    );
  }
}
