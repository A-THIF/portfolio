import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 🚀 Added this
import '../data/portfolio_data.dart';
import '../screens/portfolio_scroll_screen.dart';

class HomeScreenButtons extends StatelessWidget {
  final VoidCallback? onResumePressed;

  const HomeScreenButtons({super.key, this.onResumePressed});

  // 🔗 The "Bulletproof" Link Logic
  Future<void> _handleResumeClick(BuildContext context) async {
    // This is the official Google Drive view link format
    const String resumeUrl =
        "https://drive.google.com/file/d/1HmuNQE84kJaUaCy8EfuNgI2BOs2bb9FP/view?usp=sharing";
    final Uri uri = Uri.parse(resumeUrl);

    try {
      // mode: LaunchMode.externalApplication forces it into a new Chrome tab
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $resumeUrl';
      }
    } catch (e) {
      debugPrint("Error launching resume: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Oops! Could not open the resume.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 800;

    final double buttonWidth = 120;
    final double buttonHeight = 160;
    final double spacing = isDesktop ? 15 : 5;
    final double runSpacing = isDesktop ? 10 : 5;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: WrapAlignment.center,
      children: [
        _buildButton(
          context,
          PortfolioData.portfolioButton,
          "PORTFOLIO",
          buttonWidth,
          buttonHeight,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PortfolioScrollPage()),
            );
          },
        ),
        _buildButton(
          context,
          PortfolioData.resumeButton,
          "RESUME",
          buttonWidth,
          buttonHeight,
          // 🔥 Directly calling the link handler here
          () => _handleResumeClick(context),
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
          // Removes the grey hover highlight to keep the Mario vibe
          overlayColor: Colors.transparent,
        ),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
