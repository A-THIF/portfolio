import 'package:flutter/material.dart';

class LeadershipScreen extends StatelessWidget {
  const LeadershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/sky.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leadership",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _sectionCard("IEEE Leadership Roles", [
                    "Organised multiple events for IEEE",
                    "Handled technical & non-technical event planning",
                    "Collaborated with teams for execution",
                    "Presented ideas & solutions",
                  ]),

                  _sectionCard("Initiatives", [
                    "Built IoT prototype for telemedicine startup",
                    "Created assistive projects (EnvisionCap, Smart Watch Light)",
                    "Led college mini projects",
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade800, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $e", style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
