import 'package:flutter/material.dart';

class CloudsWidget extends StatefulWidget {
  const CloudsWidget({super.key});

  @override
  State<CloudsWidget> createState() => _CloudsWidgetState();
}

class _CloudsWidgetState extends State<CloudsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _position = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // speed of clouds
    )..addListener(() {
        setState(() {
          _position += 1; // change speed here
        });
      });
    _controller.repeat(); // loop forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fixedWidth = 1000.0;
    final int tiles = (screenWidth / fixedWidth).ceil() + 1;
    final double effectiveX = _position % fixedWidth;

    return Stack(
      children: List.generate(tiles, (index) {
        return Positioned(
          left: (fixedWidth * index) - effectiveX,
          top: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/clouds.png',
            width: fixedWidth,
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }
}
