import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetroBatteryAge extends StatefulWidget {
  final DateTime currentTime;

  const RetroBatteryAge({
    super.key,
    required this.currentTime,
  });

  @override
  State<RetroBatteryAge> createState() => _RetroBatteryAgeState();
}

class _RetroBatteryAgeState extends State<RetroBatteryAge> {
  // 🎮 ENERGY SYSTEM
  int getEnergyLevel() {
    final now = widget.currentTime;
    final hour = now.hour;
    final minute = now.minute;

    // 🌅 5AM Reset Full
    if (hour >= 5 && hour < 6) {
      return 100;
    }

    // ☀️ 6AM – 5PM gradual decrease
    if (hour >= 6 && hour < 17) {
      int totalMinutes = (hour - 6) * 60 + minute;
      double percentDrop = (totalMinutes / (11 * 60)) * 70;
      return (100 - percentDrop).clamp(30, 100).toInt();
    }

    // 🌆 5PM – 10PM stays low
    if (hour >= 17 && hour < 22) {
      return 30;
    }

    // 🌙 10PM – 5AM charging
    if (hour >= 22 || hour < 5) {
      int chargeHour = hour >= 22 ? hour - 22 : hour + 2;
      double chargeProgress = (chargeHour * 60 + minute) / (7 * 60);
      return (30 + (chargeProgress * 70)).clamp(30, 100).toInt();
    }

    return 100;
  }

  bool isCharging() {
    final hour = widget.currentTime.hour;
    return hour >= 22 || hour < 5;
  }

  // 🎂 AGE SYSTEM
  int getAge() {
    final now = widget.currentTime;
    final birthDate = DateTime(2005, 4, 12);

    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Widget outlinedText(String text, double fontSize, Color fillColor) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize * 0.15
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: fontSize,
            color: fillColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallWidth = screenWidth < 400;
    final double fontSize = isSmallWidth ? 8 : 12;

    return Positioned(
      top: 50,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/mushroom.png",
                width: fontSize * 4.5,
                height: fontSize * 4.5,
              ),
              const SizedBox(width: 4),
              outlinedText(
                "${getEnergyLevel()}%${isCharging() ? " ⚡" : ""}",
                fontSize,
                Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 4),
          outlinedText(
            "LIVES x ${getAge()}",
            fontSize,
            Colors.white,
          ),
        ],
      ),
    );
  }
}
