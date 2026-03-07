import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/widgets/clouds_widget.dart';
import '../widgets/hills_background.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html; // Only works for Web
import '../routes/app_routes.dart';

// Enum to manage Windows-style screen transitions
enum LockState { input, provideDetails, incorrect }

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  LockState _currentState = LockState.input;

  void _handleLogin() async {
    final user = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final link = _linkController.text.trim();

    if (user.isEmpty) {
      setState(() => _currentState = LockState.provideDetails);
      return;
    }

    // 1. Call Backend
    final response =
        await ApiService.login(user, email, link); // Rename method to login

    if (response != null) {
      // 2. Store the JWT Token for later use
      AppRoutes.isLoggedIn = true; // Set the session flag to true
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response['access_token']);

      // ADMIN CHECK: If the role returned is admin, go to the redirecter

      if (response['role'] == 'admin') {
        Navigator.pushReplacementNamed(
          context,
          '/admin-dashboard',
          arguments: link, // This sends the text from your link controller
        );
        return;
      }

      // 3. Detect Device & Navigate
      double width = MediaQuery.of(context).size.width;
      String userAgent = html.window.navigator.userAgent.toLowerCase();
      bool isMobileDevice = userAgent.contains("android") ||
          userAgent.contains("iphone") ||
          userAgent.contains("ipad") ||
          userAgent.contains("mobile");
      bool isSmallScreen = width < 1024;

      if (isMobileDevice || isSmallScreen) {
        Navigator.pushReplacementNamed(context, '/mobile-info');
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/game',
          (route) => false,
        );
      }
    } else {
      setState(() => _currentState = LockState.incorrect);
    }
  } // Fixed: Properly closed _handleLogin here

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
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child)),
              child: _buildCurrentUI(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUI() {
    switch (_currentState) {
      case LockState.provideDetails:
        return _buildMessagePanel("Provide Details", Icons.info_outline);
      case LockState.incorrect:
        return _buildMessagePanel("Incorrect! Try Again.", Icons.error_outline);
      case LockState.input:
      default:
        return _buildSignInPanel();
    }
  }

  Widget _buildMessagePanel(String message, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 64),
        const SizedBox(height: 16),
        Text(message,
            style: GoogleFonts.openSans(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 24),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentState = LockState.input),
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

  Widget _buildSignInPanel() {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white10,
            child: Icon(Icons.person, size: 60, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text("Welcome Back",
              style: GoogleFonts.openSans(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w300)),
          const SizedBox(height: 32),
          _buildWindowsInput(
              controller: _usernameController, hint: "Codename / Username"),
          const SizedBox(height: 8),
          _buildWindowsInput(
              controller: _emailController, hint: "Email", isPassword: false),
          const SizedBox(height: 8),
          _buildWindowsInput(
            controller: _linkController,
            hint: "Your Link to Connect (Password)",
            isPassword: false,
            hasSubmit: true,
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsInput({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool hasSubmit = false,
  }) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              onSubmitted: (_) => _handleLogin(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: InputBorder.none,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow, width: 2)),
              ),
            ),
          ),
          if (hasSubmit)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleLogin,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.white12)),
                  ),
                  child: const Icon(Icons.arrow_forward,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
