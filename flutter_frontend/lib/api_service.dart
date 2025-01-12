import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.2.39:5000";

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


  static Future<void> addMovieToWatchlist(String token, dynamic movie) async {
    print("Request data: $movie");
    print("Sending to: $baseUrl/watched");

    final response = await http.post(
      Uri.parse("$baseUrl/watched"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(movie),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception("Failed to add movie to watchlist");
    }
  }


  static Future<List<dynamic>> searchMovies(String token, String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/thumbnails?query=$query"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['thumbnails'] as List<dynamic>;
    } else {
      throw Exception("Failed to fetch search results: ${response.body}");
    }
  }



  static Future<void> removeMovieFromWatchlist(String token, int movieId) async {
  final response = await http.delete(
    Uri.parse("$baseUrl/watched/$movieId"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to remove movie from watchlist");
  }
}


}

