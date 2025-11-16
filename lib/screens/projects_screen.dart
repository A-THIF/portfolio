import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

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
                    "Projects",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _projCard("EnvisionCap — Smart Hat for Visually Impaired", [
                    "Obstacle detection assistance",
                    "Vibration feedback",
                    "IoT + sensors",
                  ]),

                  _projCard("Mario Portfolio Website", [
                    "Flutter Web",
                    "Animated car movement with signposts",
                    "Interactive navigation system",
                  ]),

                  _projCard("Smart Light Watch", [
                    "Solar-powered",
                    "Reflector-based intensity control",
                    "Compact IoT mechanism",
                  ]),

                  _projCard("Terminal Snake Game", [
                    "Built using Warp AI",
                    "Packaged into Windows EXE",
                    "Shared on GitHub",
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _projCard(String title, List<String> points) {
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
          ...points.map(
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
