import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'package:url_launcher/url_launcher.dart';

class AdminDashboardRedirect extends StatelessWidget {
  final String
      jwtToken; // Change name to reflect it's the JWT, not the raw secret

  const AdminDashboardRedirect({super.key, required this.jwtToken});

  @override
  Widget build(BuildContext context) {
    // 1. Prepare the high-security URL with Fragment (#)
    final String dashboardUrl =
        'https://portfolio-backend-bnhn.onrender.com/admin-dashboard#$jwtToken';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (kIsWeb) {
        // For Web: Use the bridge we built (this keeps URLs clean)
        web.window.location.assign(dashboardUrl);
      } else {
        // For Mobile: Use url_launcher
        final Uri uri = Uri.parse(dashboardUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    });

    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: CircularProgressIndicator(color: Colors.greenAccent),
      ),
    );
  }
}
