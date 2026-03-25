import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://portfolio-backend-bnhn.onrender.com";

  // Modified login to return the Token map
  static Future<Map<String, dynamic>?> login(
      String username, String email, String link) async {
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

// C:\Users\parve\Documents\Projects\portfolio\lib\services\api_service.dart

  static Future<int?> getTotalVisitors() async {
    final prefs = await SharedPreferences.getInstance();
    // IMPORTANT: For your admin stats, you used a query token in the backend
    // but your Flutter app uses JWT. Make sure your backend /admin/stats
    // allows the JWT token or use your ADMIN_SECRET_KEY.
    final token = prefs.getString('jwt_token');

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/admin/stats'), // Or a new endpoint like /admin/total
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Logic: Sum the counts array if the backend only sends daily stats
        List<dynamic> counts = data['counts'] ?? [];
        int total = counts.fold(0, (sum, item) => sum + (item as int));
        return total;
      }
    } catch (e) {
      print("Error fetching visitors: $e");
    }
    return null;
  }
}
