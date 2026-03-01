import 'package:flutter/material.dart';

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

  final List<String> _assets = [
    'assets/images/sky.png',
    'assets/images/clouds.png',
    'assets/images/grass_floor.png',
    'assets/images/portfolio_button.png',
    'assets/images/resume_button.png',
    'assets/images/hill_1.png',
    'assets/images/hill_2.png',
    'assets/images/mushroom.png',
    'assets/profiles/avatar_1.png',
    'assets/profiles/avatar_2.png',
    'assets/profiles/avatar_3.png',
    'assets/profiles/original.png',
  ];

  @override
  void initState() {
    super.initState();

    // 🔁 Logo rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Wait until widget is fully built before preloading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPreloading();
    });
  }

  Future<void> _startPreloading() async {
    int loaded = 0;

    for (String path in _assets) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        debugPrint("Failed to load $path");
      }

      loaded++;

      if (mounted) {
        setState(() {
          progress = ((loaded / _assets.length) * 100).toInt();
        });
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }

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
            // 🔄 Rotating Logo
            RotationTransition(
              turns: _rotationController,
              child: Image.asset(
                'assets/images/loading_logo.png', // your logo path
                width: 80,
              ),
            ),

            const SizedBox(height: 40),

            // 📊 Percentage Text
            Text(
              "$progress%",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 📈 Progress Bar
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
