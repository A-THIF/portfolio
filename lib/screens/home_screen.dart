import 'package:flutter/material.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/floor_widget.dart';
import '../widgets/car_widget.dart';
import '../widgets/controls_widget.dart';
import '../widgets/signpost_widget.dart';
import '../widgets/profile_details.dart';
import '../screens/optimized_profile_layout.dart';
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
  bool _forceShowGame = false;

  final double cloudParallax = 0.3;
  final double floorParallax = 1.0;
  final double signpostPositionX = 5;
  final double signpostOffsetX = 70;
  final double leftLimit = 0.25;
  final double rightLimit = 0.75;
  static const double floorHeight = 63;

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
    // Force show game override
    if (_forceShowGame) return _buildGameWorld();

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        bool showGame = false;

        if (height < 360) {
          showGame = false;
        } else if (width < 600) {
          showGame = true; // Mobile
        } else if (width >= 600 && width < 1000) {
          showGame = false; // Tablet / Half window
        } else {
          showGame = true; // Desktop
        }

        if (!showGame) {
          return OptimizedProfileLayout(
            onUnlockGame: () {
              setState(() {
                _forceShowGame = true;
              });
            },
          );
        }

        return _buildGameWorld();
      },
    );
  }

  Widget _buildGameWorld() {
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

        // SIGNPOSTS
        SignpostWidget(
          worldX: worldX,
          positionX: 300,
          floorHeight: floorHeight,
          asset: 'assets/signpost-home.png',
          width: 140,
          onTap: () {},
        ),
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
        SignpostWidget(
          worldX: worldX,
          positionX: 1500,
          floorHeight: floorHeight,
          asset: 'assets/signpost-skills.png',
          width: 140,
        ),
        SignpostWidget(
          worldX: worldX,
          positionX: 2100,
          floorHeight: floorHeight,
          asset: 'assets/signpost-leadership.png',
          width: 140,
        ),
        SignpostWidget(
          worldX: worldX,
          positionX: 2700,
          floorHeight: floorHeight,
          asset: 'assets/signpost-experience.png',
          width: 140,
        ),
        SignpostWidget(
          worldX: worldX,
          positionX: 3300,
          floorHeight: floorHeight,
          asset: 'assets/signpost-project.png',
          width: 140,
        ),

        // CAR
        CarWidget(screenX: carX),

        // PROFILE CARD
        Positioned(
          left: worldX + signpostPositionX + signpostOffsetX,
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
      ],
    );
  }
}
