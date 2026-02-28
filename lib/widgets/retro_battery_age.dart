import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';

class RetroBatteryAge extends StatefulWidget {
  final DateTime currentTime; // <- now we take time from RetroClock
  const RetroBatteryAge({super.key, required this.currentTime});

  @override
  State<RetroBatteryAge> createState() => _RetroBatteryAgeState();
}

class _RetroBatteryAgeState extends State<RetroBatteryAge> {
  final Battery _battery = Battery();
  int batteryLevel = 100;
  BatteryState? batteryState;
  StreamSubscription<BatteryState>? batterySubscription;

  @override
  void initState() {
    super.initState();
    _updateBattery();
    batterySubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        batteryState = state;
      });
      _updateBattery();
    });
  }

  Future<void> _updateBattery() async {
    try {
      final level = await _battery.batteryLevel;
      setState(() {
        batteryLevel = level;
      });
    } catch (_) {
      setState(() {
        batteryLevel = 0;
      });
    }
  }

  @override
  void dispose() {
    batterySubscription?.cancel();
    super.dispose();
  }

  int getAge() {
    final now = widget.currentTime; // <- use RetroClock time
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
                "$batteryLevel%${batteryState == BatteryState.charging ? " ⚡" : ""}",
                fontSize,
                const Color.fromARGB(255, 255, 255, 255),
              ),
            ],
          ),
          const SizedBox(height: 4),
          outlinedText("LIVES x ${getAge()}", fontSize,
              const Color.fromARGB(255, 255, 255, 255)),
        ],
      ),
    );
  }
}
