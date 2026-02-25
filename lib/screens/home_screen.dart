import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

// IMPORTS
import '../widgets/menu_button.dart';
import '../data/portfolio_data.dart';
import 'portfolio_scroll_screen.dart'; // Ensure this file exists
import 'game_screen.dart'; // Ensure this file exists

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _clickCount = 0;
  bool _isLoadingGame = false;

  // ---------------------------------------------------------
  // 🚀 ASSET PRELOADING LOGIC
  // ---------------------------------------------------------
  Future<void> _preloadGameAssets(BuildContext context) async {
    // 🔥 FIXED: Added commas to prevent "InvalidType" error
    final List<String> assets = [
      'assets/images/car_man1.png',
      'assets/images/clouds.png',
      'assets/images/grass_floor.png',
      'assets/images/sky.png',
      'assets/images/signpost-home.png',
      'assets/images/signpost-skills.png',
      'assets/images/signpost-leadership.png',
      'assets/images/signpost-experience.png',
      'assets/images/signpost-project.png',
      'assets/images/signpost-aboutme.png',
      'assets/images/profile.png',
      'assets/images/about_button.png',
      'assets/images/experience_button.png',
      'assets/images/projects_button.png',
    ];

    for (var path in assets) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        // Just print error, don't crash app if one image fails
        debugPrint("Error loading image: $path");
      }
    }
  }

  void _handleSecretTap() {
    setState(() {
      _clickCount++;
    });

    if (_clickCount == 1) {
      _showSnack("Tap 2 more times to unlock the Game World!");
    } else if (_clickCount == 2) {
      _showSnack("1 more time...");
    } else if (_clickCount >= 3) {
      ScaffoldMessenger.of(context).clearSnackBars();
      _checkAndLaunchGame();
      _clickCount = 0;
    }
  }

  void _checkAndLaunchGame() async {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    bool isSafeForGame = false;

    // 1. LAPTOP/DESKTOP
    if (width >= 1000) {
      isSafeForGame = height >= 400;
    }
    // 2. MOBILE PORTRAIT
    else if (width < 600) {
      isSafeForGame = height >= 480;
    }
    // 3. TABLET / SPLIT SCREEN
    else {
      isSafeForGame = false;
    }

    if (isSafeForGame) {
      // ✅ Screen is perfect? Direct Launch
      setState(() => _isLoadingGame = true);
      await _preloadGameAssets(context);

      if (!mounted) return;
      setState(() => _isLoadingGame = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    } else {
      // ⚠️ Screen is weird? Show Warning
      _showWarningDialog();
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.fredoka()),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const GameWarningDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 500;

    return Scaffold(
      backgroundColor: const Color(0xFF2666A6),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: isSmallHeight ? 10 : 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1. PROFILE PHOTO
                    Container(
                      width: (size.height * 0.22).clamp(80.0, 120.0),
                      height: (size.height * 0.22).clamp(80.0, 120.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.yellow, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(PortfolioData.profileImage),
                        backgroundColor: Colors.black26,
                      ),
                    ),

                    SizedBox(height: isSmallHeight ? 10 : 20),

                    // 2. NAME
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        PortfolioData.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // 3. TAGLINE
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        PortfolioData.tagline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.yellow[200],
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallHeight ? 15 : 30),

                    // 4. MENU BUTTONS
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildButton(
                          "ABOUT",
                          'assets/images/about_button.png',
                          'ABOUT',
                        ),
                        _buildButton(
                          "EXP",
                          'assets/images/experience_button.png',
                          'EXP',
                        ),
                        _buildButton(
                          "PROJECTS",
                          'assets/images/projects_button.png',
                          'PROJECTS',
                        ),
                      ],
                    ),

                    SizedBox(height: isSmallHeight ? 15 : 30),

                    // 5. SOCIALS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon(FontAwesomeIcons.linkedin),
                        const SizedBox(width: 25),
                        _socialIcon(FontAwesomeIcons.github),
                        const SizedBox(width: 25),
                        _socialIcon(FontAwesomeIcons.envelope),
                      ],
                    ),

                    SizedBox(height: isSmallHeight ? 15 : 30),

                    // 6. SECRET TAP AREA
                    GestureDetector(
                      onTap: _handleSecretTap,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Text(
                              "(Want to play the game?)",
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _clickCount > 0
                                  ? "Unlock Game? (${3 - _clickCount})"
                                  : "Tap 3 times here to start",
                              style: GoogleFonts.fredoka(
                                fontSize: 12,
                                color: Colors.yellow.withOpacity(0.7),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🎮 LOADING OVERLAY
          if (_isLoadingGame)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.yellow),
                    const SizedBox(height: 20),
                    Text(
                      "LOADING WORLD...",
                      style: GoogleFonts.vt323(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String asset, String sectionKey) {
    return MenuButton(
      imagePath: asset,
      width: 110,
      height: 45,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PortfolioScrollPage(initialSection: sectionKey),
          ),
        );
      },
    );
  }

  Widget _socialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Icon(icon, color: Colors.yellow, size: 35),
    );
  }
}

// WARNING DIALOG
class GameWarningDialog extends StatefulWidget {
  const GameWarningDialog({super.key});

  @override
  State<GameWarningDialog> createState() => _GameWarningDialogState();
}

class _GameWarningDialogState extends State<GameWarningDialog> {
  int _secondsRemaining = 5;
  Timer? _timer;
  bool _assetsLoaded = false;
  @override
  void initState() {
    super.initState();
    _startTimer();
    _preloadAssetsInBackground();
  }

  Future<void> _preloadAssetsInBackground() async {
    final List<String> assets = [
      'assets/images/sky.png',
      'assets/images/clouds.png',
      'assets/images/grass_floor.png',
      'assets/images/profile.png',
      'assets/images/signpost-home.png',
      'assets/images/signpost-aboutme.png',
      'assets/images/signpost-skills.png',
      'assets/images/signpost-leadership.png',
      'assets/images/signpost-experience.png',
      'assets/images/signpost-project.png',
    ];

    for (var path in assets) {
      if (mounted) {
        await precacheImage(AssetImage(path), context);
      }
    }
    if (mounted) {
      setState(() => _assetsLoaded = true);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "WARNING !!!",
        textAlign: TextAlign.center,
        style: GoogleFonts.luckiestGuy(color: Colors.red, fontSize: 28),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "The game world is best experienced on larger screens.",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            "On smaller screens, it might look squashed. Proceed at your own risk!",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _secondsRemaining == 0 ? Colors.red : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: _secondsRemaining > 0
              ? null
              : () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
          child: Text(
            _secondsRemaining > 0
                ? "Wait $_secondsRemaining s"
                : "OK! I UNDERSTAND",
            style: GoogleFonts.vt323(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
