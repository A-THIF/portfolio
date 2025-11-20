import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingProfileCard extends StatelessWidget {
  const LoadingProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Mobile detection
    final bool isMobile = screenWidth < 600;

    // Card dimensions for mobile
    final double cardWidth = isMobile ? screenWidth * 0.8 : 0;
    final double cardHeight = isMobile ? screenHeight * 0.7 : 0;

    if (!isMobile) {
      // Placeholder for laptop version
      return const SizedBox.shrink();
    }

    return Center(
      child: CustomPaint(
        size: Size(cardWidth, cardHeight),
        painter: WoodPanelPainter(
          fillColor: const Color.fromARGB(255, 38, 102, 166), // sea blue
          borderColor: Colors.yellow, // yellow border
        ),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircleAvatar with yellow border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: cardWidth * 0.3,
                    backgroundImage: const AssetImage('assets/profile.png'),
                  ),
                ),
                const SizedBox(height: 15),
                // Name
                Text(
                  "M O H A M E D  A T H I F  N",
                  style: GoogleFonts.luckiestGuy(
                    fontSize: cardWidth * 0.08,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 8),
                // Quote
                Text(
                  "INSPIRE & INFLUENCE",
                  style: GoogleFonts.fredoka(
                    fontSize: cardWidth * 0.05,
                    fontStyle: FontStyle.italic,
                    color: Colors.yellow[200],
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 15),
                // Short bio
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      "Self-learning coder exploring AI, Flutter, IoT, and game development. "
                      "Forever a beginner, passionate about learning, guiding others, and volunteering. "
                      "Loves collaborating in teams and turning ideas into projects.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.fredoka(
                        fontSize: cardWidth * 0.045,
                        color: Colors.yellow[100],
                        height: 1.4,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Resume Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add resume URL launch logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: cardWidth * 0.2,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "RESUME",
                    style: GoogleFonts.fredoka(
                      fontSize: cardWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Social icons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        // TODO: Open LinkedIn URL
                      },
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.github,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        // TODO: Open GitHub URL
                      },
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.envelope,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        // TODO: Open Gmail
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WoodPanelPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;

  WoodPanelPainter({required this.fillColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Draw card background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
