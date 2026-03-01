import 'package:flutter/material.dart';

int _currentThemeIndex = 0;

class ProfileBackground {
  static final List<Map<String, dynamic>> themes = [
    {
      'image': 'assets/profiles/original.png',
      'bg': const Color(0xFF2666A6),
      'isImageBg': false,
    },
    {
      'image': 'assets/profiles/avatar_1.png',
      'bg': 'assets/images/sky.png', // image background
      'isImageBg': true,
    },
    {
      'image': 'assets/profiles/avatar_2.png',
      'bg': const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 1, 97, 138),
          Color.fromARGB(255, 100, 211, 234),
        ],
      ),
      'isImageBg': false,
    },
    {
      'image': 'assets/profiles/avatar_3.png',
      'bg': const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF880E4F), Color(0xFF4A148C)],
      ),
      'isImageBg': false,
    },
  ];

  // --- Method to get current profile image ---
  static String getProfileImage(int index) {
    return themes[index]['image'];
  }

  // --- Method to get background widget ---
  static Widget getBackgroundWidget(int index) {
    final theme = themes[index];
    if (theme['isImageBg'] == true) {
      return Positioned.fill(
        child: Image.asset(
          theme['bg'], // image path
          fit: BoxFit.cover,
        ),
      );
    } else if (theme['bg'] is LinearGradient) {
      return Positioned.fill(
        child: Container(decoration: BoxDecoration(gradient: theme['bg'])),
      );
    } else if (theme['bg'] is Color) {
      return Positioned.fill(
        child: Container(color: theme['bg']),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class DynamicBackground extends StatefulWidget {
  final int index;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const DynamicBackground({
    super.key,
    required this.index,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground> {
  bool _canSwipe = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // We calculate a responsive width, but use Flexible to ensure it never overflows
    final double profileSize = (size.height * 0.2).clamp(70.0, 110.0);
    final theme = ProfileBackground.themes[widget.index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left Arrow
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_left, color: Colors.yellow, size: 36),
          onPressed: widget.onPrev,
        ),

        const SizedBox(width: 8),

        // Profile Circle - Wrapped in Flexible to prevent overflow
        Flexible(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (!_canSwipe) return;
              if (details.delta.dx > 10) {
                widget.onPrev();
                _canSwipe = false;
              } else if (details.delta.dx < -10) {
                widget.onNext();
                _canSwipe = false;
              }
            },
            onHorizontalDragEnd: (_) => _canSwipe = true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Container(
                key: ValueKey(widget.index),
                width: profileSize,
                height: profileSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    theme['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Right Arrow
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.chevron_right, color: Colors.yellow, size: 36),
          onPressed: widget.onNext,
        ),
      ],
    );
  }
}
