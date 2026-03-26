import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreenOpening extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const LoadingScreenOpening({super.key, required this.onLoadingComplete});

  @override
  State<LoadingScreenOpening> createState() => _LoadingScreenOpeningState();
}

class _LoadingScreenOpeningState extends State<LoadingScreenOpening>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  int progress = 0;

  // 🖼 ALL IMAGES
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

  // 🔊 ALL AUDIO
  final List<String> _audioAssets = [
    'audios/maro-jump-sound-effect_1.mp3',
    'audios/sm64_mario_whoa.mp3',
    'audios/mario-1-up.mp3',
    'audios/super-mario-bros.mp3',
    'audios/mario-fireball.mp3',
    'audios/mario-coin-sound-effect.mp3',
  ];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPreloading();
    });
  }

  Future<void> _startPreloading() async {
    int totalTasks = _imageAssets.length + _audioAssets.length + 3; // + fonts
    int loaded = 0;

    void updateProgress() {
      if (mounted) {
        setState(() {
          progress = ((loaded / totalTasks) * 100).toInt();
        });
      }
    }

    // 🖼 1. Preload Images
    for (String path in _imageAssets) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (_) {
        debugPrint("❌ Failed image: $path");
      }
      loaded++;
      updateProgress();
    }

    // 🔊 2. Preload Audio (warm-up)
    for (String path in _audioAssets) {
      try {
        final player = AudioPlayer();
        await player.setSource(AssetSource(path)); // 🔥 preload only
      } catch (_) {
        debugPrint("❌ Failed audio: $path");
      }
      loaded++;
      updateProgress();
    }

    // 🔤 3. Warm-up Fonts (VERY IMPORTANT for first load lag)
    try {
      await GoogleFonts.luckiestGuy();
      loaded++;
      updateProgress();

      await GoogleFonts.fredoka();
      loaded++;
      updateProgress();

      await GoogleFonts.vt323();
      loaded++;
      updateProgress();
    } catch (_) {
      debugPrint("❌ Font preload failed");
    }

    // Small delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 300));

    widget.onLoadingComplete();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
