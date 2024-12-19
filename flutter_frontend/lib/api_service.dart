import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.0.48:5000";
  static String? jwtToken; // Store the JWT token globally for simplicity

  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode != 201) {
      throw Exception("Registration failed: ${response.body}");
    }
  }


  static Future<List<dynamic>> fetchWatchedMovies(String token) async {
  final response = await http.get(
    Uri.parse("$baseUrl/watched"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception("Failed to load watched movies: ${response.statusCode} ${response.reasonPhrase}");
  }
}

}

