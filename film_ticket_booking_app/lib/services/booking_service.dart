import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:film_ticket_booking_app/models/booking.dart';

class BookingService {
  static const String baseUrl = "http://localhost:5000/api";
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  // Create booking
  static Future<Booking> createBooking({
    required String movieId,
    required String showtimeId,
    required List<String> seatNumbers,
    required double totalAmount,
  }) async {
    final headers = await _getHeaders();
    
    print('Creating booking for movie: $movieId, showtime: $showtimeId');
    print('Seats: $seatNumbers, Total: Rs$totalAmount');
    
    final response = await http.post(
      Uri.parse("$baseUrl/bookings"),
      headers: headers,
      body: jsonEncode({
        "movieId": movieId,
        "showtimeId": showtimeId,
        "seatNumbers": seatNumbers,
        "totalAmount": totalAmount,
      }),
    );
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data);
      } catch (e) {
        print('Error parsing booking response: $e');
        throw Exception('Invalid booking response format');
      }
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to create booking');
    }
  }

  // Get user bookings
  static Future<List<Booking>> getUserBookings() async {
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse("$baseUrl/bookings/my-bookings"),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing bookings: $e');
        return [];
      }
    } else {
      print('Failed to load bookings: ${response.statusCode}');
      return [];
    }
  }

  // Get booking by ID
  static Future<Booking> getBookingById(String id) async {
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse("$baseUrl/bookings/$id"),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Booking.fromJson(data);
    } else {
      throw Exception('Failed to load booking');
    }
  }
}