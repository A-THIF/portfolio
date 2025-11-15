import 'package:flutter/material.dart';

class CloudsWidget extends StatelessWidget {
  final double position;
  const CloudsWidget({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fixedWidth = 1200.0;

    final tiles = (screenWidth / fixedWidth).ceil() + 1;
    final effectiveX = position % fixedWidth;

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: List.generate(tiles, (index) {
          return Positioned(
            left: fixedWidth * index - effectiveX,
            top: 0,
            child: Image.asset(
              'assets/clouds.png',
              width: fixedWidth,
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
    );
  }
}
