import 'package:flutter/material.dart';

class SignpostWidget extends StatelessWidget {
  final double worldX; // world scroll offset
  final double positionX; // horizontal world position
  final double width;
  final double floorHeight; // to align with floor
  final double offsetY; // vertical adjustment
  final String asset; // image file of signpost
  final VoidCallback? onTap;

  const SignpostWidget({
    super.key,
    required this.worldX,
    required this.positionX,
    required this.floorHeight,
    required this.asset,
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
        child: Image.asset(asset, width: width, fit: BoxFit.contain),
      ),
    );
  }
}
