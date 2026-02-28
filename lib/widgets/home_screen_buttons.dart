import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../screens/portfolio_scroll_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenButtons extends StatelessWidget {
  const HomeScreenButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    // Button size
    final double buttonWidth = 120;
    final double buttonHeight = 160;

    // Gap settings
    final double spacing = isDesktop ? 15 : 5;
    final double runSpacing = isDesktop ? 10 : 5;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: WrapAlignment.center,
      children: [
        _buildButton(
          context,
          PortfolioData.portfolioButton, // added in portfolio_data.dart
          "PORTFOLIO",
          buttonWidth,
          buttonHeight,
          () {
            // Navigate to portfolio scroll screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PortfolioScrollPage()),
            );
          },
        ),
        _buildButton(
          context,
          PortfolioData.resumeButton, // added in portfolio_data.dart
          "RESUME",
          buttonWidth,
          buttonHeight,
          () {
            // Open resume in browser / drive
            // Example: Google Drive link
            final Uri uri = Uri.parse(
              "https://drive.google.com/file/d/1HmuNQE84kJaUaCy8EfuNgI2BOs2bb9FP/view?usp=sharing",
            );
            launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String assetPath,
    String label,
    double width,
    double height,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
