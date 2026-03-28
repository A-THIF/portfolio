import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/sound_effects.dart'; // ✅ IMPORT THIS
import '../routes/app_routes.dart'; // ✅ IMPORT THIS

class GameUpdate extends StatefulWidget {
  const GameUpdate({super.key});

  @override
  State<GameUpdate> createState() => _GameUpdateState();
}

class _GameUpdateState extends State<GameUpdate> {
  double x = 100;
  double y = 100;

  double dx = 2.5;
  double dy = 2.0;

  final double logoSize = 80;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final size = MediaQuery.of(context).size;

      bool bounced = false;

      setState(() {
        x += dx;
        y += dy;

        // Horizontal bounce
        if (x <= 0 || x + logoSize >= size.width) {
          dx = -dx;
          bounced = true;
        }

        // Vertical bounce
        if (y <= 0 || y + logoSize >= size.height) {
          dy = -dy;
          bounced = true;
        }
      });

      // 🔊 Play sound ONLY when bounce happens
      if (bounced) {
        SoundEffects.playBouncing();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔙 BACK BUTTON
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          /// DVD LOGO
          Positioned(
            left: x,
            top: y,
            child: Image.asset(
              "assets/images/loading_logo.png",
              width: logoSize,
            ),
          ),

          /// GLASSMORPHISM MESSAGE
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    """You’ve reached the end of this experimental interface — for now.

This desktop-style experience was created to showcase a different side of development: creativity, interaction, and curiosity.

To explore the developer’s actual projects, experience, and work, please return to the Home Page and open the Portfolio section.

This space will continue evolving as new ideas are built and tested.

If you have an interesting idea, collaboration opportunity, or feedback, feel free to connect or send a message. Creative conversations are always welcome.""",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
