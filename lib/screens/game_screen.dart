import 'package:flutter/material.dart';
import 'home_screen.dart'; // To navigate back

// WIDGET IMPORTS
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';
import '../widgets/signpost_widget.dart';
import '../widgets/profile_details.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopState();
}

class _DesktopState extends State<DesktopScreen> {
  // --- GAME STATE VARIABLES ---
  double worldX = 0;
  double carX = 0.5;

  bool movingLeft = false;
  bool movingRight = false;
  bool _isLoopRunning = false;

  final double cloudParallax = 0.3;
  final double floorParallax = 1.0;
  final double signpostPositionX = 5;
  final double signpostOffsetX = 70;
  final double leftLimit = 0.25;
  final double rightLimit = 0.75;
  static const double floorHeight = 63;

  @override
  void dispose() {
    stopAll(); // Ensure loop stops when leaving screen
    super.dispose();
  }

  // --- GAME LOOP LOGIC ---
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
      if (!mounted) break;
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
    // Boost speed on mobile to make it feel responsive
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
    return Scaffold(
      body: Stack(
        children: [
          // SKY
          Positioned.fill(
            child: Image.asset('assets/images/sky.png', fit: BoxFit.cover),
          ),

          // CLOUDS
          CloudsWidget(),

          // FLOOR
          Align(
            alignment: Alignment.bottomCenter,
            child: FloorWidget(position: worldX * floorParallax),
          ),

          // --- SIGNPOSTS ---
          SignpostWidget(
            worldX: worldX,
            positionX: 300,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-home.png',
            width: 140,
            onTap: () {},
          ),
          SignpostWidget(
            worldX: worldX,
            positionX: 900,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-aboutme.png',
            width: 140,
            onTap: () {},
          ),
          SignpostWidget(
            worldX: worldX,
            positionX: 1500,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-skills.png',
            width: 140,
          ),
          SignpostWidget(
            worldX: worldX,
            positionX: 2100,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-leadership.png',
            width: 140,
          ),
          SignpostWidget(
            worldX: worldX,
            positionX: 2700,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-experience.png',
            width: 140,
          ),
          SignpostWidget(
            worldX: worldX,
            positionX: 3300,
            floorHeight: floorHeight,
            asset: 'assets/images/signpost-project.png',
            width: 140,
          ),

          // CAR
          CarWidget(screenX: carX),

          // PROFILE CARD
          Positioned(
            left: worldX + 5 + 70, // signpostPositionX + offset
            bottom: floorHeight + 150,
            child: const ProfileDetailsCard(),
          ),

          // CONTROLS
          ControlsWidget(
            onLeftStart: startLeft,
            onLeftEnd: stopLeft,
            onRightStart: startRight,
            onRightEnd: stopRight,
            onStopAll: stopAll,
          ),

          // EXIT BUTTON (Top Right)
          // Allows user to return to Optimized Screen
          Positioned(
            top: 40,
            right: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
