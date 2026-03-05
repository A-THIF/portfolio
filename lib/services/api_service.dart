import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://portfolio-backend-bnhn.onrender.com";

  // Modified login to return the Token map
  static Future<Map<String, dynamic>?> login(String username, String email, String link) async {
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
        return jsonDecode(response.body); // Contains access_token
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // NEW: Fetch Admin Stats using the Token
  static Future<Map<String, dynamic>?> getAdminStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/stats'), // Match this to your backend route
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // This is how you "access" it
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}