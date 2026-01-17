// lib/models/booking.dart
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart'; // Assuming you have a separate file for Showtime or use MovieModel

// Assuming Movie and Showtime are available and linked
class Booking {
  final String bookingId;
  final Movie movie;
  final Showtime showtime; // Should be a Showtime object, not just a string
  final List<String> seatNumbers; // List of seat numbers (e.g., ['A1', 'A2'])
  final double totalAmount;
  final String status;

  Booking({
    required this.bookingId,
    required this.movie,
    required this.showtime,
    required this.seatNumbers,
    required this.totalAmount,
    required this.status,
  });
}