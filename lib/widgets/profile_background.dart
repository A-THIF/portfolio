import 'package:flutter/material.dart';
import 'sound_effects.dart';

class ProfileBackground {
  static final List<Map<String, dynamic>> themes = [
    {
      'image': 'assets/profiles/original.png',
      'bg': const Color(0xFF2666A6),
      'isImageBg': false,
    },
    {
      'image': 'assets/profiles/avatar_1.png',
      'bg': 'assets/images/sky.png',
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

  static String getProfileImage(int index) => themes[index]['image'];

  static Widget getBackgroundWidget(int index) {
    final theme = themes[index];
    if (theme['isImageBg'] == true) {
      return Positioned.fill(
        child: Image.asset(theme['bg'], fit: BoxFit.cover),
      );
    } else if (theme['bg'] is LinearGradient) {
      return Positioned.fill(
        child: Container(decoration: BoxDecoration(gradient: theme['bg'])),
      );
    } else if (theme['bg'] is Color) {
      return Positioned.fill(
        child: Container(color: theme['bg']),
      );
    }
    return const SizedBox.shrink();
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

class _DynamicBackgroundState extends State<DynamicBackground>
    with SingleTickerProviderStateMixin {
  bool _canSwipe = true;
  bool _hasPlayedEffect = false;
  late AnimationController _effectController;
  late Animation<int> _colorIndex;

  // Mario "Star Power" LED sequence
  final List<Color> _starColors = [
    const Color(0xFFE52521), // Mario Red
    const Color(0xFF049CD8), // Mario Blue
    const Color(0xFF43B047), // Mario Green
    Colors.white, // Flash White
    const Color(0xFFFBD000), // Star Yellow
  ];

  @override
  void initState() {
    super.initState();
    _effectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // This makes the colors cycle 4 times (20 changes) in 1 second
    _colorIndex = IntTween(begin: 0, end: (_starColors.length - 1)).animate(
      CurvedAnimation(parent: _effectController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _effectController.dispose();
    super.dispose();
  }

  void _runStarEffect() {
    if (_hasPlayedEffect) return; // 🚫 Stop if already played

    _hasPlayedEffect = true; // ✅ Mark as played
    _effectController.forward(from: 0.0);
  }

  void _handleNext() {
    SoundEffects.playOneUp();
    _runStarEffect();
    widget.onNext();
  }

  void _handlePrev() {
    SoundEffects.playOneUp();
    _runStarEffect();
    widget.onPrev();
  }

  void _triggerNext() {
    if (!_canSwipe) return;

    _canSwipe = false;
    _handleNext();

    Future.delayed(const Duration(milliseconds: 400), () {
      _canSwipe = true;
    });
  }

  void _triggerPrev() {
    if (!_canSwipe) return;

    _canSwipe = false;
    _handlePrev();

    Future.delayed(const Duration(milliseconds: 400), () {
      _canSwipe = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double profileSize = (size.height * 0.2).clamp(70.0, 110.0);
    final theme = ProfileBackground.themes[widget.index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left,
              color: Color(0xFFFBD000), size: 36),
          onPressed: _triggerPrev,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (!_canSwipe) return;

              // Detect swipe direction
              if (details.primaryVelocity! < 0) {
                // Swipe Left → Next
                _triggerNext();
              } else if (details.primaryVelocity! > 0) {
                // Swipe Right → Prev
                _triggerPrev();
              }
            },
            child: AnimatedBuilder(
              animation: _effectController,
              builder: (context, child) {
                final Color activeColor = _effectController.isAnimating
                    ? _starColors[_colorIndex.value % _starColors.length]
                    : const Color(0xFFFBD000);

                return Container(
                  width: profileSize,
                  height: profileSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: activeColor, width: 3.5),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.6),
                        blurRadius: _effectController.isAnimating ? 15 : 8,
                        spreadRadius: _effectController.isAnimating ? 3 : 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (c, a) =>
                          ScaleTransition(scale: a, child: c),
                      child: ClipOval(
                        key: ValueKey(widget.index),
                        child: Image.asset(
                          theme['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right,
              color: Color(0xFFFBD000), size: 36),
          onPressed: _triggerNext,
        ),
      ],
    );
  }
}
