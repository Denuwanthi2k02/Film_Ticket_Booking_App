import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';

class Booking {
  final String id;
  final String bookingId;
  final Movie? movie; // Make nullable
  final Showtime? showtime; // Make nullable
  final List<String> seatNumbers;
  final double totalAmount;
  final String status;

  Booking({
    required this.id,
    required this.bookingId,
    this.movie,
    this.showtime,
    required this.seatNumbers,
    required this.totalAmount,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse Movie
    Movie? parseMovie(dynamic movieData) {
      if (movieData is Map<String, dynamic>) {
        return Movie.fromJson(movieData);
      }
      return null;
    }

    // Helper function to safely parse Showtime
    Showtime? parseShowtime(dynamic showtimeData) {
      if (showtimeData is Map<String, dynamic>) {
        return Showtime.fromJson(showtimeData);
      }
      return null;
    }

    // Extract movie data (could be nested in movieId field)
    dynamic movieData = json['movieId'];
    if (movieData == null) {
      movieData = json['movie']; // Alternative field name
    }

    // Extract showtime data
    dynamic showtimeData = json['showtimeId'];
    if (showtimeData == null) {
      showtimeData = json['showtime']; // Alternative field name
    }

    // Parse seat numbers safely
    List<String> seats = [];
    if (json['seatNumbers'] is List) {
      for (var item in json['seatNumbers']) {
        if (item is String) {
          seats.add(item);
        } else if (item != null) {
          seats.add(item.toString());
        }
      }
    }

    return Booking(
      id: json['_id'] ?? json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      movie: parseMovie(movieData),
      showtime: parseShowtime(showtimeData),
      seatNumbers: seats,
      totalAmount: (json['totalAmount'] is int 
          ? json['totalAmount'].toDouble() 
          : json['totalAmount']) ?? 0.0,
      status: json['status'] ?? 'Confirmed',
    );
  }

  // Helper getters for safe access
  String get movieTitle => movie?.title ?? 'Unknown Movie';
  String get moviePosterUrl => movie?.posterUrl ?? '';
  DateTime get showtimeDate => showtime?.date ?? DateTime.now();
  String get showtimeTime => showtime?.time ?? '';
  double get showtimePrice => showtime?.price ?? 0.0;

  // For debugging
  @override
  String toString() {
    return 'Booking(id: $id, bookingId: $bookingId, movie: ${movie?.title}, seats: $seatNumbers)';
  }
}