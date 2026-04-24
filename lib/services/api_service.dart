import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/browser_client.dart';

class ApiService {
  static const String baseUrl = "https://portfolio-backend-bnhn.onrender.com";

  // Modified login to return the Token map
  static Future<Map<String, dynamic>?> login(
      String username, String email, String link) async {
    try {
      final client = BrowserClient()..withCredentials = true;

      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'email': email.isEmpty ? null : email,
          'profile_link': link.isEmpty ? null : link,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ store token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['access_token']);

        return data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // NEW: Fetch Admin Stats using the Token
  // lib/services/api_service.dart

  static Future<Map<String, dynamic>?> getAdminStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    try {
      final client = BrowserClient()..withCredentials = true;

      final response = await client.get(
        Uri.parse('$baseUrl/admin/stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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

// C:\Users\parve\Documents\Projects\portfolio\lib\services\api_service.dart

  static Future<int?> getPublicVisitors() async {
    try {
      final response = await http.get(
        Uri.parse('https://portfolio-backend-bnhn.onrender.com/public/stats'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['total_visitors']; // ✅ IMPORTANT CHANGE
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("API Error: $e");
      return null;
    }
  }
}
