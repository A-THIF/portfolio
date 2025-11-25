import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final String imagePath;

  static const Rect slice = Rect.fromLTRB(8, 8, 653, 369);

  const MenuButton({
    super.key,
    required this.onPressed,
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
            centerSlice: slice,
            filterQuality: FilterQuality.none,
          ),
        ),
      ),
    );
  }
}
