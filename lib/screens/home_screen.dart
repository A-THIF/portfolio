import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

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
import '../routes/app_routes.dart';

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
  bool _isUnlocked = false;
  bool _isNavigating = false; // prevent double-trigger

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

  // ── REMOVED didChangeDependencies focus stealing ──
  // The KeyboardListener only needs focus when this screen is active.
  // We request focus only once after the first frame.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only request focus if we are the top route (not covered by another screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
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
      final total = await ApiService.getPublicVisitors();
      if (mounted) setState(() => _totalVisitors = total ?? 0);
    } catch (e) {
      debugPrint("Stats fetch failed: $e");
      if (mounted) setState(() => _totalVisitors = 0);
    }
  }

  void _completeUnlock({bool isKey = false}) {
    if (_isUnlocked || _isNavigating) return;

    if (isKey) {
      SoundEffects.playJump();
    } else {
      SoundEffects.playWhoa();
    }

    setState(() {
      _isUnlocked = true;
      _isNavigating = true;
    });

    _dragController
        .animateTo(1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut)
        .then((_) async {
      await _navigateAfterUnlock();
      if (mounted) {
        // Snap back instantly — no animation — so LockScreen bg is never seen
        _dragController.value = 0.0;
        setState(() {
          _isUnlocked = false;
          _isNavigating = false;
        });
        // Re-request focus for keyboard shortcuts
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void _lockBack({bool playSound = false}) {
    if (!_isUnlocked) return;
    if (playSound) SoundEffects.playWhoa();
    _dragController.animateBack(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _isUnlocked = false);
  }

  Future<void> _navigateAfterUnlock() async {
    if (AppRoutes.isLoggedIn) {
      final width = MediaQuery.of(context).size.width;
      final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;

      if (isMobile || width < 1024) {
        await Navigator.pushNamed(context, AppRoutes.mobileInfo, arguments: 0);
      } else {
        await Navigator.pushNamed(context, AppRoutes.game);
      }
    } else {
      // Show lock screen as a full push — no slide animation from home needed
      // because home content is already slid up out of view
      await Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 1),
          // ← instant reverse so you never see it slide back down
          pageBuilder: (_, __, ___) => const LockScreen(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    }
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        await SoundEffects.playCoin();
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
    return PopScope(
      canPop: !_isUnlocked,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isUnlocked) _lockBack();
      },
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.space) {
            if (!_isUnlocked && !_isNavigating) {
              _completeUnlock(isKey: true);
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // ── BACKGROUND: just a static blurred/dark layer, NOT LockScreen widget ──
              // This prevents the double-LockScreen flash on back navigation.
              // The real LockScreen is pushed as a separate route.
              Container(color: Colors.black),

              // ── FOREGROUND: Sliding Home Screen ──
              AnimatedBuilder(
                animation: _dragController,
                builder: (context, child) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final scale = 1 - (_dragController.value * 0.03);

                  return Transform.translate(
                    offset: Offset(0, -_dragController.value * screenHeight),
                    child: Transform.scale(
                      scale: scale,
                      child: IgnorePointer(
                        ignoring: _dragController.value > 0.8,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onVerticalDragUpdate: (details) {
                            if (_isNavigating) return;
                            _dragController.value -=
                                details.primaryDelta! / screenHeight;
                          },
                          onVerticalDragEnd: (details) {
                            if (_isNavigating) return;
                            final velocity = details.primaryVelocity ?? 0.0;
                            if (velocity < -500 ||
                                _dragController.value > 0.3) {
                              _completeUnlock();
                            } else {
                              _lockBack(playSound: false);
                            }
                          },
                          child: _buildHomeContent(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
        ValueListenableBuilder<DateTime>(
          valueListenable: _currentTime,
          builder: (_, time, __) => RetroBatteryAge(
            currentTime: time,
            visitorCount: _totalVisitors ?? 0,
          ),
        ),
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

// ── SlideUpWidget unchanged ──
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
