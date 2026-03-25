import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/widgets/retro_battery_age.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../widgets/hills_background.dart';
import '../widgets/home_screen_buttons.dart';
import 'lock_screen.dart';
import '../widgets/clouds_widget.dart';
import '../widgets/retro_clock.dart';
import '../widgets/profile_background.dart';
import '../services/api_service.dart';
import '../widgets/sound_effects.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<DateTime> _currentTime =
      ValueNotifier<DateTime>(DateTime.now());
  final FocusNode _focusNode = FocusNode();
  late Timer _timer;
  int _selectedProfileIndex = 0;
  int? _totalVisitors; // New state variable for total visitors
  bool _isNavigating = false;
  double _dragOffset = 0.0;
  double _maxDrag = 300; // how much needed to unlock
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _fetchVisitorStats(); // Fetch visitor stats on load
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime.value = DateTime.now();
    });
  }

  Future<void> _fetchVisitorStats() async {
    try {
      final stats = await ApiService.getAdminStats();
      if (stats != null && stats.containsKey('counts')) {
        // Summing the daily counts to get the total
        final List<dynamic> counts = stats['counts'];
        final total = counts.fold(0, (sum, item) => sum + (item as int));
        if (mounted) setState(() => _totalVisitors = total);
      }
    } catch (e) {
      debugPrint("Stats fetch failed: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _currentTime.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToLock({bool isKey = false}) {
    if (_isNavigating) return;
    _isNavigating = true;

    if (isKey) {
      SoundEffects.playJump();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LockScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          final curve =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(curve),
              child: child,
            ),
          );
        },
      ),
    ).then((_) {
      _isNavigating = false;
      _focusNode.requestFocus();
    });
  }

  void _resetDrag() {
    setState(() {
      _dragOffset = 0;
    });
  }

  void _completeUnlock() {
    setState(() {
      _dragOffset = _maxDrag;
    });

    SoundEffects.playWhoa();

    Future.delayed(const Duration(milliseconds: 200), () {
      _navigateToLock(isKey: false);
      _dragOffset = 0;
    });
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
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

    final profileWidth = (size.height * 0.22).clamp(80.0, 120.0);
    final leftSpace = (size.width / 2) - profileWidth / 2 - 40;
    final clockScale = leftSpace < 80 ? (leftSpace / 80) : 1.0;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          _navigateToLock(isKey: true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2666A6),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (_) {
            _isDragging = true;
          },
          onPanUpdate: (details) {
            setState(() {
              _dragOffset -= details.delta.dy;
              _dragOffset = _dragOffset.clamp(0.0, _maxDrag);
            });
          },
          onPanEnd: (_) {
            _isDragging = false;

            if (_dragOffset > _maxDrag * 0.4) {
              // smoother trigger
              _completeUnlock();
            } else {
              _resetDrag();
            }
          },
          child: Stack(
            children: [
              /// 🔥 LOCK SCREEN (background reveal)
              IgnorePointer(
                child: Opacity(
                  opacity: Curves.easeOut.transform(
                    (_dragOffset / _maxDrag).clamp(0.0, 1.0),
                  ),
                  child: const LockScreen(),
                ),
              ),

              /// 🔥 MAIN SCREEN (moves with drag)
              Transform.translate(
                offset: Offset(0, -_dragOffset),
                child: Stack(
                  children: [
                    ProfileBackground.getBackgroundWidget(
                        _selectedProfileIndex),
                    const HillsBackground(),
                    const CloudsWidget(),

                    /// CLOCK
                    Positioned(
                      left: 20,
                      top: 90,
                      child: Transform.scale(
                        scale: clockScale,
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder<DateTime>(
                          valueListenable: _currentTime,
                          builder: (_, time, __) =>
                              RetroClock(currentTime: time),
                        ),
                      ),
                    ),

                    /// BATTERY + SCORE
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _currentTime,
                      builder: (_, time, __) => RetroBatteryAge(
                        currentTime: time,
                        visitorCount: _totalVisitors ?? 0,
                      ),
                    ),

                    /// MAIN CONTENT
                    SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: isSmallHeight ? 10 : 30,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DynamicBackground(
                                index: _selectedProfileIndex,
                                onNext: () => setState(() {
                                  _selectedProfileIndex =
                                      (_selectedProfileIndex + 1) %
                                          ProfileBackground.themes.length;
                                }),
                                onPrev: () => setState(() {
                                  _selectedProfileIndex =
                                      (_selectedProfileIndex -
                                              1 +
                                              ProfileBackground.themes.length) %
                                          ProfileBackground.themes.length;
                                }),
                              ),

                              const SizedBox(height: 20),

                              /// NAME
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
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              /// TAGLINE
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

                              const SizedBox(height: 20),
                              const HomeScreenButtons(),
                              const SizedBox(height: 15),

                              /// SOCIALS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _socialIcon(FontAwesomeIcons.linkedin,
                                      PortfolioData.linkedin),
                                  const SizedBox(width: 25),
                                  _socialIcon(FontAwesomeIcons.github,
                                      PortfolioData.github),
                                  const SizedBox(width: 25),
                                  _socialIcon(FontAwesomeIcons.envelope,
                                      PortfolioData.email),
                                ],
                              ),

                              const SizedBox(height: 30),

                              if (!isSmallHeight) const SlideUpWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
