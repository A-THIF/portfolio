import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class RetroClock extends StatefulWidget {
  final double? maxWidth;
  final DateTime? currentTime; // Add this line

  const RetroClock(
      {super.key, this.maxWidth, this.currentTime}); // Add to constructor

  @override
  State<RetroClock> createState() => _RetroClockState();
}

class _RetroClockState extends State<RetroClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = widget.currentTime ?? DateTime.now();
    // Only run internal timer if no external time is provided
    if (widget.currentTime == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _now = DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    if (widget.currentTime == null) _timer.cancel();
    super.dispose();
  }

  Widget _outlinedText(String text, double fontSize) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize * 0.1
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
    // Use the passed time if available, otherwise use local state
    final timeToDisplay = widget.currentTime ?? _now;

    const weekdayNames = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final day = weekdayNames[timeToDisplay.weekday - 1];
    final date =
        "${timeToDisplay.day}/${timeToDisplay.month}/${timeToDisplay.year}";
    final time =
        "${timeToDisplay.hour.toString().padLeft(2, '0')}:${timeToDisplay.minute.toString().padLeft(2, '0')}:${timeToDisplay.second.toString().padLeft(2, '0')}";

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
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
