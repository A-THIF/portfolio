import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'game_card.dart';
import 'menu_button.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        // Handle infinite constraints (e.g., inside ScrollView)
        if (maxWidth.isInfinite) maxWidth = MediaQuery.of(context).size.width;
        if (maxHeight.isInfinite)
          maxHeight = MediaQuery.of(context).size.height;

        final bool isLaptop = maxWidth > 800;

        // 🔥 FIX 1: CLAMPING
        // We set a minimum size so the UI doesn't crush itself.
        // But we also ensure it doesn't exceed the screen size.
        double cardWidth = isLaptop ? maxWidth * 0.6 : maxWidth * 0.9;

        // On laptop, height is 60%, but AT LEAST 400px (unless screen is smaller)
        double cardHeight = isLaptop
            ? (maxHeight * 0.65).clamp(400.0, 800.0)
            : (maxHeight * 0.75).clamp(500.0, 900.0);

        // Safety check: Card can't be bigger than the screen itself
        if (cardHeight > maxHeight) cardHeight = maxHeight * 0.95;

        return GameCard(
          width: cardWidth,
          height: cardHeight,
          padding: const EdgeInsets.all(24),
          child: isLaptop
              ? _buildLaptopLayout(context, cardWidth, cardHeight)
              : _buildMobileLayout(context, cardWidth, cardHeight),
        );
      },
    );
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(BuildContext context, double width, double height) {
    return Column(
      children: [
        _buildProfilePhoto(radius: width * 0.2), // Slightly smaller photo
        const SizedBox(height: 15),

        // Expanded ensures the scrollview takes all remaining space
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min, // shrink wrap content
              children: [
                _buildName(fontSize: width * 0.07),
                _buildQuote(fontSize: width * 0.045),
                const SizedBox(height: 12),
                _buildBio(fontSize: 16),
                const SizedBox(height: 20),
                _buildMenuButtons(isVertical: false, btnWidth: width * 0.25),
                const SizedBox(height: 20),
                _buildSocialIcons(iconSize: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- LAPTOP LAYOUT (Fixed Overflow) ---
  Widget _buildLaptopLayout(BuildContext context, double width, double height) {
    return Row(
      children: [
        // Left Side: Photo & Socials (Fixed width logic)
        SingleChildScrollView(
          // Wrap left side in scroll just in case height is tiny
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfilePhoto(radius: 80), // Fixed safe size for laptop
              const SizedBox(height: 30),
              _buildSocialIcons(iconSize: 40),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // Right Side: Details & Buttons
        // 🔥 FIX 2: WRAP IN EXPANDED + SINGLE CHILD SCROLL VIEW
        // This removes the "Bottom Overflow" error.
        Expanded(
          child: Center(
            // Centers vertically if there is space
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildName(fontSize: 40, align: TextAlign.left),
                  _buildQuote(fontSize: 20, align: TextAlign.left),
                  const SizedBox(height: 20),

                  // Bio doesn't need a container constraint anymore because
                  // the whole parent column scrolls.
                  _buildBio(fontSize: 18, align: TextAlign.left),

                  const SizedBox(height: 30), // Replace Spacer with fixed gap

                  _buildMenuButtons(
                    isVertical: false,
                    btnWidth: 120,
                    btnHeight: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- REUSABLE WIDGETS (Keep these mostly the same) ---

  Widget _buildProfilePhoto({required double radius}) {
    return Container(
      width: radius * 2, // Explicit width/height helps layout
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.yellow, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage('assets/profile.png'),
        backgroundColor: Colors.black26,
      ),
    );
  }

  // (Paste your _buildName, _buildQuote, _buildBio, _buildMenuButtons, _buildSocialIcons, _socialIcon here)
  // They do not need changes.

  // ... [Keep existing widget methods]
  Widget _buildName({
    required double fontSize,
    TextAlign align = TextAlign.center,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        "M O H A M E D  A T H I F  N",
        textAlign: align,
        style: GoogleFonts.luckiestGuy(
          fontSize: fontSize.clamp(20.0, 60.0), // 🔥 Clamp font size too!
          color: Colors.white,
          decoration: TextDecoration.none,
          letterSpacing: 1.5,
          shadows: [
            const Shadow(
              color: Colors.black,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuote({
    required double fontSize,
    TextAlign align = TextAlign.center,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        "INSPIRE & INFLUENCE",
        textAlign: align,
        style: GoogleFonts.fredoka(
          fontSize: fontSize.clamp(14.0, 30.0), // 🔥 Clamp font size
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.none,
          color: Colors.yellow[200],
        ),
      ),
    );
  }

  Widget _buildBio({
    required double fontSize,
    TextAlign align = TextAlign.left,
  }) {
    return Text(
      "Self-learning coder exploring AI, Flutter, IoT, and game development. "
      "Passionate about learning, guiding others, and volunteering. "
      "Loves collaborating in teams and turning ideas into projects.",
      textAlign: align,
      style: GoogleFonts.fredoka(
        fontSize: fontSize,
        decoration: TextDecoration.none,
        color: Colors.yellow[100],
        height: 1.5,
      ),
    );
  }

  Widget _buildMenuButtons({
    required bool isVertical,
    double btnWidth = 100,
    double btnHeight = 45, // Ensure this ratio matches your image ratio!
  }) {
    List<Widget> buttons = [
      MenuButton(
        imagePath: 'assets/about_button.png', // Image now contains "ABOUT" text
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
      const SizedBox(width: 10, height: 10),
      MenuButton(
        imagePath:
            'assets/experience_button.png', // Image now contains "EXP" text
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
      const SizedBox(width: 10, height: 10),
      MenuButton(
        imagePath:
            'assets/projects_button.png', // Image now contains "PROJECTS" text
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
    ];

    return isVertical
        ? Column(children: buttons)
        : Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            children: buttons,
          );
  }

  Widget _buildSocialIcons({required double iconSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(FontAwesomeIcons.linkedin, iconSize),
        const SizedBox(width: 20),
        _socialIcon(FontAwesomeIcons.github, iconSize),
        const SizedBox(width: 20),
        _socialIcon(FontAwesomeIcons.envelope, iconSize),
      ],
    );
  }

  Widget _socialIcon(IconData icon, double size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Icon(icon, color: Colors.yellow, size: size),
    );
  }
}
