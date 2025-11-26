import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/menu_button.dart';

class OptimizedProfileLayout extends StatefulWidget {
  // Function from parent to call when the game is unlocked
  final VoidCallback onUnlockGame;

  const OptimizedProfileLayout({super.key, required this.onUnlockGame});

  @override
  State<OptimizedProfileLayout> createState() => _OptimizedProfileLayoutState();
}

class _OptimizedProfileLayoutState extends State<OptimizedProfileLayout> {
  int _clickCount = 0;

  void _handleSecretTap() {
    setState(() {
      _clickCount++;
    });

    if (_clickCount == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tap 2 more times to force the game!"),
          duration: Duration(milliseconds: 500),
        ),
      );
    } else if (_clickCount == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("1 more time..."),
          duration: Duration(milliseconds: 500),
        ),
      );
    } else if (_clickCount >= 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      widget.onUnlockGame(); // Unlock the game
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2666A6), // Sea-blue theme
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. PROFILE PHOTO
                Container(
                  width: 120,
                  height: 120,
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
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                    backgroundColor: Colors.black26,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. NAME
                Text(
                  "M O H A M E D  A T H I F  N",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 32,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),

                // 3. QUOTE
                const SizedBox(height: 5),
                Text(
                  "INSPIRE & INFLUENCE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.yellow[200],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. MENU BUTTONS
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButton("ABOUT", 'assets/about_button.png', () {}),
                    _buildButton("EXP", 'assets/experience_button.png', () {}),
                    _buildButton(
                      "PROJECTS",
                      'assets/projects_button.png',
                      () {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 5. SOCIAL ICONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(FontAwesomeIcons.linkedin),
                    const SizedBox(width: 25),
                    _socialIcon(FontAwesomeIcons.github),
                    const SizedBox(width: 25),
                    _socialIcon(FontAwesomeIcons.envelope),
                  ],
                ),

                const SizedBox(height: 30),

                // 6. BOTTOM SECRET MESSAGE (Force game start)
                GestureDetector(
                  onTap: _handleSecretTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Text(
                          "(Screen too awkward for Mario)",
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _clickCount > 0
                              ? "Force Start? (${3 - _clickCount})"
                              : "Tap 3 times here to play anyway",
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.yellow.withOpacity(0.7),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, String asset, VoidCallback onTap) {
    return MenuButton(
      imagePath: asset,
      width: 110,
      height: 45,
      onPressed: onTap,
    );
  }

  Widget _socialIcon(IconData icon) {
    return Icon(icon, color: Colors.yellow, size: 35);
  }
}
