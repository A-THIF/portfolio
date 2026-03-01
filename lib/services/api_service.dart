import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://your-backend-url.com"; // Replace with your deployed FastAPI URL

  static Future<bool> sendContact(String name, String profileLink) async {
    final url = Uri.parse("$baseUrl/contact");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "profile_link": profileLink,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error sending contact: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception sending contact: $e");
      return false;
    }
  }
}
