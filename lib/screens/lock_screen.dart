import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/widgets/clouds_widget.dart';
import '../widgets/hills_background.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import '../routes/app_routes.dart';

enum LockState { username, connections, provideDetails, incorrect }

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  LockState _currentState = LockState.username;

  Future<String> _generateNpcName() async {
    final prefs = await SharedPreferences.getInstance();
    await AppRoutes.setLoggedIn(); // ✅ Use AppRoutes here

    int count = prefs.getInt('npc_count') ?? 0;
    count++;

    await prefs.setInt('npc_count', count);

    return "NPC_${count}_Guest";
  }

  // Called after both screens are done (username + connections)
  void _handleLogin() async {
    final user = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final link = _linkController.text.trim();

    if (user.isEmpty) {
      setState(() => _currentState = LockState.provideDetails);
      return;
    }

    final response = await ApiService.login(user, email, link);

    if (response != null) {
      final prefs = await SharedPreferences.getInstance(); // Initialize prefs

      // Save the token for API calls (like stats)
      await prefs.setString('jwt_token', response['access_token']);
      await AppRoutes.setLoggedIn(jwtToken: response['access_token']);

      if (response['role'] == 'admin') {
        if (kIsWeb) {
          final token = response['access_token'];
          // Use fragment (#) — not sent to server, stays client-side
          web.window.location.assign(
              "https://portfolio-backend-bnhn.onrender.com/admin-dashboard#$token");
        }
        return; // Exit here for admins
      }

      // --- LOGIC FOR REGULAR VISITORS ---
      double width = MediaQuery.of(context).size.width;
      bool isMobileDevice = defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;
      bool isSmallScreen = width < 1024;

      if (isMobileDevice || isSmallScreen) {
        Navigator.pushReplacementNamed(context, '/mobile-info');
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/game',
          ModalRoute.withName('/home'),
        );
      }
    } else {
      setState(() => _currentState = LockState.incorrect);
    }
  }

  // From username screen: if user typed something, go to connections; if skip, login with empty
  void _handleUsernameNext() {
    final user = _usernameController.text.trim();
    if (user.isEmpty) {
      // Skipped — treat as anonymous, go straight to login
      _handleLogin();
    } else {
      setState(() => _currentState = LockState.connections);
    }
  }

  // From connections screen: skip or submit both lead to login
  void _handleConnectionsNext() {
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          const HillsBackground(),
          const CloudsWidget(),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: const Color(0xFF2666A6).withOpacity(0.3)),
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: _buildCurrentUI(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUI() {
    switch (_currentState) {
      case LockState.username:
        return _buildUsernameScreen();
      case LockState.connections:
        return _buildConnectionsScreen();
      case LockState.provideDetails:
        return _buildMessagePanel("Provide Details", Icons.info_outline);
      case LockState.incorrect:
        return _buildMessagePanel("Incorrect! Try Again.", Icons.error_outline);
    }
  }

  // ─── SCREEN 1: Username ───────────────────────────────────────────────────

  Widget _buildUsernameScreen() {
    return Container(
      key: const ValueKey('username'),
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: const Icon(Icons.videogame_asset_rounded,
                  size: 38, color: Colors.white60),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "PLAYER DETECTED",
            style: GoogleFonts.vt323(
              fontSize: 13,
              color: Colors.yellowAccent.withOpacity(0.7),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "How should\nwe remember you?",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Give yourself a callsign, alias, codename — anything really.",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.5,
              color: Colors.white54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildGamifiedInput(
            controller: _usernameController,
            hint: "e.g. DarkMatter42, Priya, etc.",
            icon: Icons.person_outline_rounded,
            onSubmit: _handleUsernameNext,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildGhostButton(
                label: "I'll be an NPC",
                icon: Icons.smart_toy_outlined,
                onTap: () async {
                  final npcName = await _generateNpcName();
                  _usernameController.text = npcName;
                  _handleUsernameNext();
                },
              ),
              const Spacer(),
              _buildPrimaryButton(
                label: "Continue",
                icon: Icons.arrow_forward_rounded,
                onTap: _handleUsernameNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── SCREEN 2: Connections ────────────────────────────────────────────────

  Widget _buildConnectionsScreen() {
    return Container(
      key: const ValueKey('connections'),
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _currentState = LockState.username),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white38, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                "STAGE 2 / 2",
                style: GoogleFonts.vt323(
                  fontSize: 13,
                  color: Colors.greenAccent.withOpacity(0.6),
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Want to\nlink up with me?",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Drop your email or a link — so we can stay in touch after this. Totally optional.",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.5,
              color: Colors.white54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildGamifiedInput(
            controller: _emailController,
            hint: "Your email (optional)",
            icon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 10),
          _buildGamifiedInput(
            controller: _linkController,
            hint: "A link — portfolio, LinkedIn, anything",
            icon: Icons.link_rounded,
            onSubmit: _handleConnectionsNext,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildGhostButton(
                label: "Nah, I'm good",
                icon: Icons.close_rounded,
                onTap: () {
                  _emailController.clear();
                  _linkController.clear();
                  _handleConnectionsNext();
                },
              ),
              const Spacer(),
              _buildPrimaryButton(
                label: "Let's Go",
                icon: Icons.rocket_launch_rounded,
                onTap: _handleConnectionsNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── SHARED WIDGETS ───────────────────────────────────────────────────────

  Widget _buildGamifiedInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    void Function()? onSubmit,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: Colors.white38, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmit != null ? (_) => onSubmit() : null,
              style:
                  GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
              cursorColor: Colors.yellowAccent,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.spaceGrotesk(
                    color: Colors.white38, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildGhostButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white38, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white38,
              fontSize: 12.5,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePanel(String message, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 64),
        const SizedBox(height: 16),
        Text(message,
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 24),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentState = LockState.username),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("OK"),
          ),
        ),
      ],
    );
  }
}
