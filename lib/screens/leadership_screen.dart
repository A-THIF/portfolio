import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeadershipScreen extends StatelessWidget {
  const LeadershipScreen({super.key});

  // Sample leadership data
  final List<Map<String, String>> leadershipRoles = const [
    {
      'role': 'Event Coordinator',
      'organization': 'IEEE Student Branch',
      'year': '2024',
    },
    {'role': 'Volunteer Lead', 'organization': 'Tech Fest', 'year': '2023'},
    {'role': 'Team Lead', 'organization': 'IoT Workshop', 'year': '2023'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardWidth = isMobile ? screenWidth * 0.9 : 600.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leadership', style: GoogleFonts.luckiestGuy()),
        backgroundColor: Colors.brown[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: leadershipRoles
              .map(
                (role) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildLeadershipCard(role, cardWidth),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLeadershipCard(Map<String, String> role, double width) {
    return CustomPaint(
      size: Size(width, 140),
      painter: WoodPanelPainter(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              role['role'] ?? '',
              style: GoogleFonts.luckiestGuy(
                fontSize: width * 0.06,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role['organization'] ?? '',
              style: GoogleFonts.fredoka(
                fontSize: width * 0.045,
                color: Colors.brown[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role['year'] ?? '',
              style: GoogleFonts.fredoka(
                fontSize: width * 0.035,
                color: Colors.brown[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WoodPanelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.brown[300]!;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ),
      paint,
    );

    final grainPaint = Paint()
      ..color = Colors.brown[400]!
      ..strokeWidth = 1;

    for (double y = 5; y < size.height; y += 7) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grainPaint);
    }

    final nailPaint = Paint()..color = Colors.grey[700]!;
    double nailRadius = 4;
    canvas.drawCircle(
      Offset(nailRadius + 5, nailRadius + 5),
      nailRadius,
      nailPaint,
    );
    canvas.drawCircle(
      Offset(size.width - nailRadius - 5, nailRadius + 5),
      nailRadius,
      nailPaint,
    );
    canvas.drawCircle(
      Offset(nailRadius + 5, size.height - nailRadius - 5),
      nailRadius,
      nailPaint,
    );
    canvas.drawCircle(
      Offset(size.width - nailRadius - 5, size.height - nailRadius - 5),
      nailRadius,
      nailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
