import 'package:flutter/material.dart';

class GameUpdate extends StatelessWidget {
  const GameUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            """You’ve reached the end of this experimental interface — for now.

This desktop-style experience was created to showcase a different side of development: creativity, interaction, and curiosity.

To explore the developer’s actual projects, experience, and work, please return to the Home Page and open the Portfolio section.

This space will continue evolving as new ideas are built and tested.

If you have an interesting idea, collaboration opportunity, or feedback, feel free to connect or send a message. Creative conversations are always welcome.""",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.6, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
