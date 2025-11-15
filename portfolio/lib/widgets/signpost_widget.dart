import 'package:flutter/material.dart';

class SignpostWidget extends StatelessWidget {
  final double worldX; // current world scroll offset
  final double positionX; // fixed position of signpost in the world
  final double width;
  final double floorHeight; // to align perfectly with floor
  final double offsetY; // small vertical adjustment
  final VoidCallback? onTap; // make it tappable

  const SignpostWidget({
    super.key,
    required this.worldX,
    required this.positionX,
    required this.floorHeight,
    this.width = 130,
    this.offsetY = 5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: worldX + positionX,
      bottom: floorHeight + offsetY,
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          'assets/signpost-home.png',
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
