import 'package:flutter/material.dart';

class CarWidget extends StatelessWidget {
  final double screenX; // 0.0 to 1.0

  const CarWidget({required this.screenX, super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final double carWidth = (screenW * 0.2).clamp(120, 180);
    final double bottomOffset = screenH * 0.08;

    return Align(
      alignment: Alignment(screenX * 2 - 1, 1),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomOffset),
        child: SizedBox(
          width: carWidth,
          child: Image.asset('assets/car_man1.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
