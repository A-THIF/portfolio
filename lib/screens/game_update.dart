import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final logoSize = 120;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() {
        x += dx;
        y += dy;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Bounce logic
    if (x <= 0 || x + logoSize >= size.width) {
      dx = -dx;
    }

    if (y <= 0 || y + logoSize >= size.height) {
      dy = -dy;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// DVD LOGO
          Positioned(
            left: x,
            top: y,
            child: Image.asset(
              "assets/images/loading_logo.png",
              width: 80,
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
