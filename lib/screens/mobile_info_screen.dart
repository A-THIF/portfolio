import 'dart:ui';
import 'package:flutter/material.dart';
// Removed duplicate imports of backgrounds
import '../widgets/hills_background.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/profile_background.dart';

class MobileInfoScreen extends StatelessWidget {
  final int selectedIndex;

  const MobileInfoScreen({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Static Background (No need for onNext/onPrev here)
          // We use the themes list directly to avoid constructor errors
          _buildStaticBackground(selectedIndex),

          const HillsBackground(),
          const CloudsWidget(),

          // 2. Blur Overlay with updated .withValues() for precision
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),

          // 3. The Interactive Wooden Alert Board
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image.asset(
                  'assets/images/mobile_alert.png',
                  width: MediaQuery.of(context).size.width * 0.85,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the background without the ProfileSelector logic
  Widget _buildStaticBackground(int index) {
    final theme = ProfileBackground.themes[index];
    if (theme['isImageBg'] == true) {
      return Image.asset(
        theme['bg'],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: theme['bg'] is Color ? theme['bg'] : null,
        gradient: theme['bg'] is Gradient ? theme['bg'] : null,
      ),
    );
  }
}
