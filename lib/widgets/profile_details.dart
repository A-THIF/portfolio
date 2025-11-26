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
        // 1. GET RAW CONSTRAINTS
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        // 2. 🔥 FIX: HANDLE INFINITE CONSTRAINTS
        // If placed in a Stack/ScrollView, constraints might be infinite.
        // We fallback to the full screen size in that case.
        if (maxWidth.isInfinite) maxWidth = MediaQuery.of(context).size.width;
        if (maxHeight.isInfinite) {
          maxHeight = MediaQuery.of(context).size.height;
        }

        // 3. DETERMINE DEVICE TYPE
        final bool isLaptop = maxWidth > 800;

        // 4. CALCULATE CARD SIZE
        final double cardWidth = isLaptop ? maxWidth * 0.6 : maxWidth * 0.9;

        final double cardHeight = isLaptop ? maxHeight * 0.6 : maxHeight * 0.72;

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

  // ... (Keep the rest of your existing code: _buildMobileLayout, _buildLaptopLayout, etc. exactly the same)

  // Just to be safe, paste the rest of your methods here if you need them,
  // but the change above is the only thing needed to fix the crash.

  Widget _buildMobileLayout(BuildContext context, double width, double height) {
    return Column(
      children: [
        _buildProfilePhoto(radius: width * 0.25),
        const SizedBox(height: 15),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
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

  Widget _buildLaptopLayout(BuildContext context, double width, double height) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfilePhoto(radius: height * 0.2),
            const SizedBox(height: 30),
            _buildSocialIcons(iconSize: 40),
          ],
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildName(fontSize: 40, align: TextAlign.left),
              _buildQuote(fontSize: 20, align: TextAlign.left),
              const SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(maxHeight: height * 0.3),
                child: SingleChildScrollView(
                  child: _buildBio(fontSize: 18, align: TextAlign.left),
                ),
              ),
              const Spacer(),
              _buildMenuButtons(
                isVertical: false,
                btnWidth: 120,
                btnHeight: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- REUSABLE WIDGETS ---

  Widget _buildProfilePhoto({required double radius}) {
    return Container(
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
          fontSize: fontSize,
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
        softWrap: true,
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
        " "
        "INSPIRE & INFLUENCE",
        textAlign: align,

        style: GoogleFonts.fredoka(
          fontSize: fontSize,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.none,

          color: Colors.yellow[200],
        ),
        softWrap: true,
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
      softWrap: true,
    );
  }

  Widget _buildMenuButtons({
    required bool isVertical,
    double btnWidth = 100,
    double btnHeight = 45,
  }) {
    List<Widget> buttons = [
      MenuButton(
        imagePath: 'assets/about_button.png',
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
      const SizedBox(width: 10, height: 10),
      MenuButton(
        imagePath: 'assets/experience_button.png',
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
      const SizedBox(width: 10, height: 10),
      MenuButton(
        imagePath: 'assets/projects_button.png',
        width: btnWidth,
        height: btnHeight,
        onPressed: () {},
      ),
    ];
    return isVertical
        ? Column(children: buttons)
        : Wrap(alignment: WrapAlignment.center, children: buttons);
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
