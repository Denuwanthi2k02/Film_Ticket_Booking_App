import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_ticket_booking_app/models/movie.dart';

class MovieService {
  static const String baseUrl = "http://localhost:5000/api";

  // Get all movies
  static Future<List<Movie>> getAllMovies() async {
    final response = await http.get(Uri.parse("$baseUrl/movies"));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Get trending movies
  static Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse("$baseUrl/movies/trending/now"));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  // Get movie by ID
  static Future<Movie> getMovieById(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/movies/$id"));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie');
    }
  }
}