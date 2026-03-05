import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDashboardRedirect extends StatelessWidget {
  const AdminDashboardRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your Render backend URL
    final Uri adminUrl = Uri.parse('https://portfolio-backend-bnhn.onrender.com/admin-dashboard?token=nmohamedathif@12042005');

    // Open the URL automatically when this widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await canLaunchUrl(adminUrl)) {
        await launchUrl(adminUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch admin dashboard URL')),
        );
      }
      Navigator.pop(context); // Optional: go back to previous screen
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Redirecting to Admin Dashboard..."),
          ],
        ),
      ),
    );
  }
}