import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// Internal Imports
import '../data/portfolio_data.dart';
import '../widgets/hills_background.dart';
import '../widgets/home_screen_buttons.dart';
import 'lock_screen.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/retro_clock.dart';
import '../widgets/profile_background.dart';
import '../services/api_service.dart';
import '../widgets/sound_effects.dart';
import '../widgets/retro_battery_age.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<DateTime> _currentTime =
      ValueNotifier<DateTime>(DateTime.now());
  final FocusNode _focusNode = FocusNode();

  late Timer _timer;
  late final AnimationController _dragController;

  int _selectedProfileIndex = 0;
  int? _totalVisitors;
  final bool _isNavigating = false;
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _fetchVisitorStats();

    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = DateTime.now();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_focusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentTime.dispose();
    _focusNode.dispose();
    _dragController.dispose();
    super.dispose();
  }

  Future<void> _fetchVisitorStats() async {
    try {
      final stats = await ApiService.getAdminStats();
      if (stats != null && stats.containsKey('counts')) {
        final List<dynamic> counts = stats['counts'];
        final total = counts.fold(0, (sum, item) => sum + (item as int));
        if (mounted) setState(() => _totalVisitors = total);
      }
    } catch (e) {
      debugPrint("Stats fetch failed: $e");
    }
  }

  void _completeUnlock({bool isKey = false}) {
    if (_isUnlocked) return; // already unlocked

    if (isKey) {
      SoundEffects.playJump();
    } else {
      SoundEffects.playWhoa();
    }

    setState(() {
      _isUnlocked = true;
    });

    _dragController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _lockBack({bool playSound = false}) {
    if (!_isUnlocked) return;

    if (playSound) {
      SoundEffects.playWhoa(); // optional reverse sound
    }

    _dragController.animateBack(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _isUnlocked = false;
    });
  }

  Future<void> _navigateToLock({bool isKey = false}) async {
    if (isKey) SoundEffects.playJump();

    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, secondaryAnimation) => const LockScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOutCubic))
                  .animate(animation);
          final fadeAnimation =
              Tween<double>(begin: 0.0, end: 1.0).animate(animation);
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      ),
    );
  }

  void _resetDrag() {
    _dragController.animateBack(0.0,
        duration: const Duration(milliseconds: 200));
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        await SoundEffects.playCoin(); // 🪙 ADD THIS

        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Icon(icon, color: Colors.yellow, size: 35),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 500;

    return WillPopScope(
        onWillPop: () async {
          if (_isUnlocked) {
            _lockBack();
            return false; // prevent pop
          }
          return true; // allow pop
        },
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              // Check specifically for Space Key
              if (event.logicalKey == LogicalKeyboardKey.space) {
                if (!_isUnlocked) {
                  _completeUnlock(isKey: true);
                }
                // Removed the _lockBack() call here so Space only slides UP
              }
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // 🔥 BACKGROUND SCREEN (LockScreen)
                const LockScreen(),

                // 🔥 FOREGROUND (your current HomeScreen UI)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    _dragController.value -=
                        details.primaryDelta! / screenHeight;
                  },
                  onVerticalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0.0;

                    if (velocity < -500 || _dragController.value > 0.3) {
                      _completeUnlock();
                    } else if (velocity > 500 || _dragController.value < 0.7) {
                      _lockBack(
                          playSound:
                              false); // Explicitly turn off sound for drag
                    } else {
                      _dragController.animateBack(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _dragController,
                    builder: (context, child) {
                      final screenHeight = MediaQuery.of(context).size.height;

                      // 👇 ADD THIS
                      final scale = 1 - (_dragController.value * 0.03);

                      return Transform.translate(
                        offset:
                            Offset(0, -_dragController.value * screenHeight),
                        child: Transform.scale(
                          scale: scale,
                          child: _buildHomeContent(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildHomeContent() {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 500;
    final profileWidth = (size.height * 0.22).clamp(80.0, 120.0);
    final leftSpace = (size.width / 2) - profileWidth / 2 - 40;
    final clockScale = leftSpace < 80 ? (leftSpace / 80) : 1.0;

    return Stack(
      children: [
        ProfileBackground.getBackgroundWidget(_selectedProfileIndex),
        const HillsBackground(),
        const CloudsWidget(),

        // Clock
        Positioned(
          left: 20,
          top: 90,
          child: Transform.scale(
            scale: clockScale,
            alignment: Alignment.centerLeft,
            child: ValueListenableBuilder<DateTime>(
              valueListenable: _currentTime,
              builder: (_, time, __) => RetroClock(currentTime: time),
            ),
          ),
        ),

        // Battery & Visitors
        ValueListenableBuilder<DateTime>(
          valueListenable: _currentTime,
          builder: (_, time, __) => RetroBatteryAge(
            currentTime: time,
            visitorCount: _totalVisitors ?? 0,
          ),
        ),

        // Main UI
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: isSmallHeight ? 10 : 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DynamicBackground(
                    index: _selectedProfileIndex,
                    onNext: () => setState(() {
                      _selectedProfileIndex = (_selectedProfileIndex + 1) %
                          ProfileBackground.themes.length;
                    }),
                    onPrev: () => setState(() {
                      _selectedProfileIndex = (_selectedProfileIndex -
                              1 +
                              ProfileBackground.themes.length) %
                          ProfileBackground.themes.length;
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildNameSection(),
                  const SizedBox(height: 5),
                  _buildTaglineSection(),
                  const SizedBox(height: 20),
                  const HomeScreenButtons(),
                  const SizedBox(height: 15),
                  _buildSocialsRow(),
                  const SizedBox(height: 30),
                  if (!isSmallHeight) const SlideUpWidget(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameSection() => FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          PortfolioData.name,
          textAlign: TextAlign.center,
          style: GoogleFonts.luckiestGuy(
            fontSize: 32,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: const [
              Shadow(color: Colors.black, blurRadius: 2, offset: Offset(2, 2))
            ],
          ),
        ),
      );

  Widget _buildTaglineSection() => FittedBox(
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
      );

  Widget _buildSocialsRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialIcon(FontAwesomeIcons.linkedin, PortfolioData.linkedin),
          const SizedBox(width: 25),
          _socialIcon(FontAwesomeIcons.github, PortfolioData.github),
          const SizedBox(width: 25),
          _socialIcon(FontAwesomeIcons.envelope, PortfolioData.email),
        ],
      );
}

class SlideUpWidget extends StatefulWidget {
  const SlideUpWidget({super.key});

  @override
  State<SlideUpWidget> createState() => _SlideUpWidgetState();
}

class _SlideUpWidgetState extends State<SlideUpWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Column(
        children: [
          const Icon(Icons.keyboard_arrow_up, color: Colors.white70, size: 30),
          Text(
            "Slide up for Gamified View",
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "or press Any Key",
            style: GoogleFonts.fredoka(
              fontSize: 12,
              color: Colors.white.withOpacity(0.38),
            ),
          ),
        ],
      ),
    );
  }
}
