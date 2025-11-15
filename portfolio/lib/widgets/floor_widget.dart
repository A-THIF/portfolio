import 'package:flutter/material.dart';

class FloorWidget extends StatelessWidget {
  final double position;
  const FloorWidget({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const floorHeight = 250.0;

    // FIX: move floor correctly
    final effectiveX = (-position) % screenWidth;

    return SizedBox(
      width: double.infinity,
      height: floorHeight,
      child: Stack(
        children: [
          Positioned(
            left: -effectiveX,
            bottom: 0,
            child: Image.asset(
              'assets/grass_floor.png',
              height: floorHeight,
              width: screenWidth * 2,
              repeat: ImageRepeat.repeatX,
            ),
          ),
          Positioned(
            left: screenWidth * 2 - effectiveX,
            bottom: 0,
            child: Image.asset(
              'assets/grass_floor.png',
              height: floorHeight,
              width: screenWidth * 2,
              repeat: ImageRepeat.repeatX,
            ),
          ),
        ],
      ),
    );
  }
}
