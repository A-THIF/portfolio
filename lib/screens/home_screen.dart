import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../widgets/hills_background.dart';
import '../widgets/home_screen_buttons.dart';
import 'lock_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Navigate to Lock Screen ---
  void _navigateToLock() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LockScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // A heavy ease-out cubic curve feels more like a physical object
          final curve =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              // Increased to 0.2 for a more noticeable "rising" effect
              position:
                  Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Icon(icon, color: Colors.yellow, size: 35),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 500;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space) {
          _navigateToLock();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2666A6),
        body: GestureDetector(
          // Makes the entire screen sensitive to the swipe, not just where there is text
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (details) {
            // Negative velocity means swiping UP
            if (details.primaryVelocity! < -300) {
              _navigateToLock();
            }
          },
          child: Stack(
            children: [
              const HillsBackground(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: isSmallHeight ? 10 : 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // PROFILE IMAGE
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
                                  offset: const Offset(0, 5)),
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage(PortfolioData.profileImage),
                            backgroundColor: Colors.black26,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // NAME
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
                                    offset: Offset(2, 2)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // TAGLINE
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

                        // MENU BUTTONS
                        const HomeScreenButtons(),
                        const SizedBox(height: 15),

                        // SOCIAL ICONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIcon(FontAwesomeIcons.linkedin,
                                PortfolioData.linkedin),
                            const SizedBox(width: 25),
                            _socialIcon(
                                FontAwesomeIcons.github, PortfolioData.github),
                            const SizedBox(width: 25),
                            _socialIcon(
                                FontAwesomeIcons.envelope, PortfolioData.email),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // SLIDE UP TO UNLOCK TEXT
                        if (!isSmallHeight) const SlideUpWidget(),
                      ],
                    ),
                  ),
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
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
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
            "Slide up to unlock",
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "or press Space",
            style: GoogleFonts.fredoka(
              fontSize: 12,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
