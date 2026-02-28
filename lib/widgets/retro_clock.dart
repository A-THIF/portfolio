import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class RetroClock extends StatefulWidget {
  final double? maxWidth; // optional max width to scale fonts
  const RetroClock({super.key, this.maxWidth});

  @override
  State<RetroClock> createState() => _RetroClockState();
}

class _RetroClockState extends State<RetroClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Text with black outline
  Widget _outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize * 0.1 // proportional stroke
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const weekdayNames = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final day = weekdayNames[_now.weekday - 1];
    final date = "${_now.day}/${_now.month}/${_now.year}";
    final time =
        "${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}:${_now.second.toString().padLeft(2, '0')}";

    // Detect mobile width
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Font sizes
    final dateFontSize = isMobile ? 8.0 : 12.0;
    final timeFontSize = isMobile ? 16.0 : 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _outlinedText("$day, $date", dateFontSize),
        const SizedBox(height: 2),
        _outlinedText(time, timeFontSize),
      ],
    );
  }
}
