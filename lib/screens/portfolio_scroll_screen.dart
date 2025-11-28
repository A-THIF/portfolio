import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// IMPORT YOUR WIDGETS
import '../widgets/clouds_widget.dart';
import '../widgets/game_card.dart';

class PortfolioScrollPage extends StatefulWidget {
  final String? initialSection;
  const PortfolioScrollPage({super.key, this.initialSection});

  @override
  State<PortfolioScrollPage> createState() => _PortfolioScrollPageState();
}

class _PortfolioScrollPageState extends State<PortfolioScrollPage>
    with SingleTickerProviderStateMixin {
  // 1. ANIMATION CONTROLLER
  late AnimationController _controller;

  // 2. SCROLL CONTROLLER
  final ScrollController _scrollController = ScrollController();

  // 3. KEYS (Uncommented and fixed)
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _expKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _leadershipKey = GlobalKey();
  final GlobalKey _connectKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Animation Loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Auto-Scroll Logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialSection != null) {
        _handleInitialScroll(widget.initialSection!);
      }
    });
  } // <--- Only closes initState, NOT the class

  void _handleInitialScroll(String section) {
    switch (section) {
      case 'ABOUT':
        _scrollToSection(_aboutKey);
        break;
      case 'EXP':
        _scrollToSection(_expKey);
        break;
      case 'PROJECTS':
        _scrollToSection(_projectsKey);
        break;
      case 'SKILLS':
        _scrollToSection(_skillsKey);
        break;
      case 'CONNECT':
        _scrollToSection(_connectKey);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper to scroll to a specific key
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ====================================================
          // LAYER 1: ANIMATED BACKGROUND (Fixed, does not scroll)
          // ====================================================

          // Sky (Static)
          Positioned.fill(
            child: Image.asset('assets/sky.png', fit: BoxFit.cover),
          ),

          // MOVING CLOUDS (Uses your CloudsWidget)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double speed =
                  _controller.value * 500; // slow drifting effect
              return CloudsWidget(position: speed);
            },
          ),

          // ====================================================
          // LAYER 2: TRANSLUCENT DARK OVERLAY
          // ====================================================
          Positioned.fill(
            child: Container(
              color: Colors.black54, // Replaced .withOpacity with constant
            ),
          ),

          // ====================================================
          // LAYER 3: SCROLLABLE CONTENT
          // ====================================================
          Column(
            children: [
              // --- TOP NAVIGATION BAR ---
              _buildNavBar(context),

              // --- SCROLLABLE BODY ---
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Container(
                      // Constrain max width for Laptop look
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // 1. ABOUT ME
                          _buildSectionBlock(
                            "ABOUT ME",
                            _aboutKey,
                            const Text(
                              "Put your bio here...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // 2. EXPERIENCE
                          _buildSectionBlock(
                            "EXPERIENCE",
                            _expKey,
                            const Text(
                              "Job 1, Job 2...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // 3. PROJECTS
                          _buildSectionBlock(
                            "PROJECTS",
                            _projectsKey,
                            const Text(
                              "App 1, App 2...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // 4. SKILLS
                          _buildSectionBlock(
                            "SKILLS",
                            _skillsKey,
                            const Text(
                              "Flutter, Dart, AI...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // 5. LEADERSHIP
                          _buildSectionBlock(
                            "LEADERSHIP",
                            _leadershipKey,
                            const Text(
                              "Club lead, Volunteer...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // 6. CONNECT
                          _buildSectionBlock(
                            "CONNECT",
                            _connectKey,
                            const Text(
                              "Email, LinkedIn...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          // Footer spacing
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // WIDGET BUILDERS
  // ------------------------------------------

  // The Navigation Bar
  Widget _buildNavBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: SafeArea(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            _navButton("HOME", () {
              Navigator.pop(context); // Go back to Home Screen
            }),
            _navButton("ABOUT", () => _scrollToSection(_aboutKey)),
            _navButton("EXP", () => _scrollToSection(_expKey)),
            _navButton("PROJECTS", () => _scrollToSection(_projectsKey)),
            _navButton("SKILLS", () => _scrollToSection(_skillsKey)),
            _navButton("CONNECT", () => _scrollToSection(_connectKey)),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String text, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: GoogleFonts.vt323(
            color: Colors.yellow,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // The Section Block (Title + GameCard)
  Widget _buildSectionBlock(String title, GlobalKey key, Widget content) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              title,
              style: GoogleFonts.luckiestGuy(
                fontSize: 32,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  const Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          // The Game Card
          LayoutBuilder(
            builder: (context, constraints) {
              return GameCard(
                width: constraints.maxWidth,
                height: 400, // Can be adjusted
                child: SingleChildScrollView(child: content),
              );
            },
          ),
        ],
      ),
    );
  }
}
