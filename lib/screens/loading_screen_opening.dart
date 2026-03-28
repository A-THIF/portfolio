import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/sound_effects.dart';

class LoadingScreenOpening extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const LoadingScreenOpening({super.key, required this.onLoadingComplete});

  @override
  State<LoadingScreenOpening> createState() => _LoadingScreenOpeningState();
}

class _LoadingScreenOpeningState extends State<LoadingScreenOpening>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int progress = 0;
  bool _isFinished = false;

  final List<String> _imageAssets = [
    'assets/images/sky.png',
    'assets/images/clouds.png',
    'assets/images/grass_floor.png',
    'assets/images/portfolio_button.png',
    'assets/images/resume_button.png',
    'assets/images/hill_1.png',
    'assets/images/hill_2.png',
    'assets/images/mushroom.png',
    'assets/images/loading_logo.png',
    'assets/profiles/avatar_1.png',
    'assets/profiles/avatar_2.png',
    'assets/profiles/avatar_3.png',
    'assets/profiles/original.png',
  ];

  final List<String> _audioAssets = [
    'audios/maro-jump-sound-effect_1.mp3',
    'audios/sm64_mario_whoa.mp3',
    'audios/mario-1-up.mp3',
    'audios/super-mario-bros.mp3',
    'audios/mario-fireball.mp3',
    'audios/mario-coin-sound-effect.mp3',
    'audios/mario-opening.mp3',
    'audios/mario-bouncing.mp3',
    'audios/mario-cleared.mp3',
  ];

  @override
  void initState() {
    super.initState();

    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeInOutCubic, // smoother than easeInOut
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.15).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPreloading();
    });
  }

  Future<void> _onLoadingFinished() async {
    if (_isFinished) return;
    _isFinished = true;

    await Future.delayed(const Duration(milliseconds: 500));
    await _transitionController.forward();
    widget.onLoadingComplete();
  }

  Future<void> _triggerSoundAndNavigate() async {
    if (!_isFinished) return;

    // 🔊 Play sound
    await SoundEffects.playOpening();

    // 🎬 Start transition animation
    await _transitionController.forward();

    // 🚀 Navigate AFTER animation completes
    widget.onLoadingComplete();
  }

  Future<void> _startPreloading() async {
    final fontLoaders = [
      GoogleFonts.luckiestGuy,
      GoogleFonts.fredoka,
      GoogleFonts.vt323
    ];

    int totalTasks = _imageAssets.length + fontLoaders.length; // + fonts
    int loaded = 0;

    void updateProgress() {
      if (!mounted) return;
      final newProgress = ((loaded / totalTasks) * 100).toInt();
      setState(() {
        progress = newProgress;
      });
      if (newProgress >= 100) {
        setState(() {
          _isFinished = true;
        });
      }
    }

    // 1️⃣ Preload images
    for (String path in _imageAssets) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (_) {}
      loaded++;
      updateProgress();
    }

    // 3️⃣ Warm-up fonts
    for (final fontLoader in [
      GoogleFonts.luckiestGuy,
      GoogleFonts.fredoka,
      GoogleFonts.vt323
    ]) {
      try {
        fontLoader();
      } catch (_) {}
      loaded++;
      updateProgress();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _isFinished
              ? _triggerSoundAndNavigate
              : null, // Allow tap to skip
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _rotationController,
                    child: Image.asset(
                      'assets/images/loading_logo.png',
                      width: 80,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "$progress%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[800],
                      color: Colors.white,
                    ),
                  ),

                  // 👇 ADD HERE
                  if (_isFinished)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Tap to Start",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              )),
            ),
          ),
        ));
  }
}
