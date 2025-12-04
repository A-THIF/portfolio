import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; 

// IMPORT YOUR WIDGETS & DATA
import '../widgets/clouds_widget.dart';
import '../widgets/game_card.dart';
import '../data/portfolio_data.dart';

class PortfolioScrollPage extends StatefulWidget {
  final String? initialSection;
  const PortfolioScrollPage({super.key, this.initialSection});

  @override
  State<PortfolioScrollPage> createState() => _PortfolioScrollPageState();
}

class _PortfolioScrollPageState extends State<PortfolioScrollPage>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _expKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _leadershipKey = GlobalKey();
  final GlobalKey _connectKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(); // Loop forever

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialSection != null) {
        _handleInitialScroll(widget.initialSection!);
      }
    });
  }

  void _handleInitialScroll(String section) {
    switch (section) {
      case 'ABOUT': _scrollToSection(_aboutKey); break;
      case 'EXP': _scrollToSection(_expKey); break;
      case 'PROJECTS': _scrollToSection(_projectsKey); break;
      case 'SKILLS': _scrollToSection(_skillsKey); break;
      case 'CONNECT': _scrollToSection(_connectKey); break;
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
          // LAYER 1: SKY
          Positioned.fill(
            child: Image.asset('assets/images/sky.png', fit: BoxFit.cover),
          ),

          // LAYER 2: MOVING CLOUDS (Fixed!)
          // 🔥 FIX 1: Wrapped in Positioned.fill so it takes full screen height (like the game)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // 🔥 FIX 2: Multiplied by 1200 (Image Width) for perfect looping
                final double speed = _controller.value * 1200; 
                return CloudsWidget(position: speed);
              },
            ),
          ),

          // LAYER 3: DARK OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black54),
          ),

          // LAYER 4: CONTENT
          Column(
            children: [
              _buildNavBar(context),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          
                          // 1. ABOUT
                          _buildSectionBlock(
                            "ABOUT ME",
                            _aboutKey,
                            Text(
                              PortfolioData.aboutMe,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 16, height: 1.5),
                            ),
                          ),

                          // 2. EXPERIENCE
                          _buildSectionBlock(
                            "EXPERIENCE",
                            _expKey,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: PortfolioData.experience.map((exp) => _buildExperienceItem(exp)).toList(),
                            ),
                          ),

                          // 3. PROJECTS
                          _buildSectionBlock(
                            "PROJECTS",
                            _projectsKey,
                            Column(
                              children: PortfolioData.projects.map((proj) => _buildProjectItem(proj)).toList(),
                            ),
                          ),

                          // 4. SKILLS
                          _buildSectionBlock(
                            "SKILLS",
                            _skillsKey,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: PortfolioData.skills.map((cat) => _buildSkillCategory(cat)).toList(),
                            ),
                          ),

                          // 5. LEADERSHIP
                          _buildSectionBlock(
                            "LEADERSHIP",
                            _leadershipKey,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: PortfolioData.leadership.map((lead) => _buildExperienceItem(lead)).toList(),
                            ),
                          ),

                          // 6. CONNECT
                          _buildSectionBlock(
                            "CONNECT",
                            _connectKey,
                            _buildConnectSection(),
                          ),

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

  // --- WIDGET HELPERS ---

  Widget _buildExperienceItem(ExperienceItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.role, style: GoogleFonts.luckiestGuy(color: Colors.yellow, fontSize: 22)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(item.company, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold))),
              if (item.duration.isNotEmpty)
                Text(item.duration, style: const TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description, style: GoogleFonts.fredoka(color: Colors.white, fontSize: 15, height: 1.4)),
          const Divider(color: Colors.white24, height: 30),
        ],
      ),
    );
  }

  Widget _buildProjectItem(ProjectItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.vt323(color: Colors.yellowAccent, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  if (item.githubLink != null) 
                    _clickableIcon(FontAwesomeIcons.github, item.githubLink!),
                  
                  if (item.linkedinLink != null) 
                    _clickableIcon(FontAwesomeIcons.linkedin, item.linkedinLink!),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            item.shortDescription,
            style: const TextStyle(color: Colors.white60, fontStyle: FontStyle.italic, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            item.fullDescription,
            style: GoogleFonts.fredoka(color: Colors.white, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _clickableIcon(IconData icon, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildSkillCategory(SkillCategory category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.categoryName, style: GoogleFonts.vt323(color: Colors.cyanAccent, fontSize: 24)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: category.imageAssets.map((asset) {
              return Tooltip(
                message: asset.split('/').last.split('.').first.toUpperCase(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Image.asset(
                    asset,
                    width: 40,
                    height: 40,
                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectSection() {
    return Column(
      children: [
        const Text(
          "Feel free to reach out for collaborations or just a chat!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(FontAwesomeIcons.linkedin, "LinkedIn", PortfolioData.linkedin),
            const SizedBox(width: 25),
            _socialButton(FontAwesomeIcons.github, "GitHub", PortfolioData.github),
            const SizedBox(width: 25),
            _socialButton(FontAwesomeIcons.envelope, "Email", PortfolioData.email),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(IconData icon, String label, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Column(
          children: [
            Icon(icon, color: Colors.yellow, size: 40),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.vt323(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

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
            _navButton("HOME", () => Navigator.pop(context)),
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
        child: Text(text, style: GoogleFonts.vt323(color: Colors.yellow, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionBlock(String title, GlobalKey key, Widget content) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 15),
            child: Text(
              title,
              style: GoogleFonts.luckiestGuy(fontSize: 32, color: Colors.white, letterSpacing: 2, shadows: [const Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2))]),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return GameCard(
                width: constraints.maxWidth,
                height: null,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: content,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}