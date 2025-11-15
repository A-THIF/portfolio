import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  // ✅ must match exactly
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Me')),
      body: const Center(child: Text('About Me Page')),
    );
  }
}
