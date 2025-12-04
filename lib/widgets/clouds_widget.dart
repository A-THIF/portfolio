import 'package:flutter/material.dart';

class CloudsWidget extends StatelessWidget {
  final double position;
  const CloudsWidget({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Assume cloud image is wide enough to loop
    final double fixedWidth = 1000.0; 

    // Calculate how many images needed to fill screen + 1 buffer
    final int tiles = (screenWidth / fixedWidth).ceil() + 1;
    
    // Calculate offset for smooth scrolling
    final double effectiveX = position % fixedWidth;

    return Stack(
      children: List.generate(tiles, (index) {
        return Positioned(
          // Logic: Tile Index * Width - Scroll Offset
          left: (fixedWidth * index) - effectiveX,
          top: 0,
          bottom: 0, // Stretch vertically to fit container
          child: Image.asset(
            'assets/images/clouds.png',
            width: fixedWidth,
            fit: BoxFit.cover, // Ensures it covers the area
          ),
        );
      }),
    );
  }
}