import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_ticket_booking_app/models/showtime.dart';

class ShowtimeService {
  static const String baseUrl = "http://localhost:5000/api";

  // Get showtimes for a movie
  static Future<List<Showtime>> getShowtimesByMovie(String movieId) async {
    final response = await http.get(Uri.parse("$baseUrl/showtimes/movie/$movieId"));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Showtime.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load showtimes');
    }
  }

  // Get showtime by ID
  static Future<Showtime> getShowtimeById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/showtimes/$id"));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Showtime.fromJson(data);
    } else {
      throw Exception('Failed to load showtime');
    }
  }
}