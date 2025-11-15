import 'package:flutter/material.dart';

class ControlsWidget extends StatefulWidget {
  final VoidCallback onLeftStart;
  final VoidCallback onRightStart;
  final VoidCallback onLeftEnd;
  final VoidCallback onRightEnd;

  const ControlsWidget({
    required this.onLeftStart,
    required this.onRightStart,
    required this.onLeftEnd,
    required this.onRightEnd,
    super.key,
  });

  @override
  _ControlsWidgetState createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Left translucent arrow
        Positioned(
          left: 10,
          top: isPortrait ? screenHeight / 2 - 30 : (screenHeight / 2) - 30,
          bottom: isPortrait ? null : (screenHeight / 4),
          child: GestureDetector(
            onTapDown: (_) => widget.onLeftStart(),
            onTapUp: (_) => widget.onLeftEnd(),
            onTapCancel: widget.onLeftEnd,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        // Right translucent arrow
        Positioned(
          right: 10,
          top: isPortrait ? screenHeight / 2 - 30 : (screenHeight / 2) - 30,
          bottom: isPortrait ? null : (screenHeight / 4),
          child: GestureDetector(
            onTapDown: (_) => widget.onRightStart(),
            onTapUp: (_) => widget.onRightEnd(),
            onTapCancel: widget.onRightEnd,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
