import 'dart:convert';
import 'package:http/http.dart' as http;




class AuthService {
  static const String baseUrl = "http://localhost:5000/api/auth";

  // LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode == 200;
  }

  // REGISTER
  static Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
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

    return response.statusCode == 201;
  }
}
