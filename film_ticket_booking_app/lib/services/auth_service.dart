import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // make sure you have a User model

class AuthService {
  static const String baseUrl = "http://localhost:5000/api/auth";

  // LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save JWT token
      return true;
    }
    return false;
  }

  // REGISTER
  static Future<bool> register(
      String name, String email, String password, String phone) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      }),
    );

    if (response.statusCode == 201) { // <-- changed from 200 to 201
    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data['token']); // Save JWT token
    return true;
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Registration failed');
  }
}

  // GET LOGGED-IN USER
  static Future<User> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch profile");
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
