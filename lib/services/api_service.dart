import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://portfolio-backend-bnhn.onrender.com";

  static Future<bool> login(String username, String email, String link) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'email': email.isEmpty ? null : email,
          'profile_link': link.isEmpty ? null : link,
        }),
      );

      if (response.statusCode == 200) {
        print("Contact sent successfully");
        return true;
      } else {
        print("Failed to send contact: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending contact: $e");
      return false;
    }
  }
}
