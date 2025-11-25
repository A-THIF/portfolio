import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final EdgeInsets padding;

  const GameCard({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(width, height),
        painter: GameCardPainter(
          fillColor: const Color(0xFF2666A6), // Sea-blue wooden texture base
          borderColor: Colors.yellow,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class GameCardPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  GameCardPainter({required this.fillColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      fillPaint,
    );

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
