import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final String imagePath;

  const MenuButton({
    super.key,
    required this.onPressed,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            // 🔥 CHANGED: Use BoxFit.contain or fill
            // .contain ensures the text inside the image doesn't get cut off
            // .fill will stretch it to match width/height exactly (might distort text)
            fit: BoxFit.contain,
            filterQuality: FilterQuality.none, // Keep pixel art sharp
          ),
        ),
      ),
    );
  }
}
