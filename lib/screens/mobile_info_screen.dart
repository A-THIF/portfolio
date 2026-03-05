import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileMessageScreen extends StatelessWidget {
  const MobileMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.laptop_mac, color: Colors.yellow, size: 80),
              const SizedBox(height: 24),
              Text(
                "PREMIUM EXPERIENCE DETECTED",
                textAlign: TextAlign.center,
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "To explore the interactive gamified world of Athif's portfolio, please switch to a Desktop or Laptop browser.",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              // Optional: Add a button to go back or link to LinkedIn
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: const Text("Return to Lock Screen",
                    style: TextStyle(color: Colors.yellow)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
