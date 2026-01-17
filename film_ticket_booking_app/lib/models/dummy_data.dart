// lib/models/dummy_data.dart
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';
import 'package:film_ticket_booking_app/models/seat.dart';
import 'package:film_ticket_booking_app/models/booking.dart';








// Dummy list of Movies
final List<Movie> dummyMovies = [
  Movie(movieId: 1, title: 'Crimson Fury', genre: 'Action | Thriller', duration: 135, language: 'English', rating: 8.7, description: 'A rogue agent races against time to expose a global conspiracy before it plunges the world into chaos. Featuring breathtaking stunts and non-stop action.', posterUrl: 'assets/posters/movie1.jpg'),
  Movie(movieId: 2, title: 'Starfall Odyssey', genre: 'Sci-Fi | Adventure', duration: 150, language: 'English', rating: 9.1, description: 'A lone starship captain undertakes a perilous journey across the galaxy to find the source of a mysterious signal that could save or doom humanity.', posterUrl: 'assets/posters/movie2.jpg'),
  Movie(movieId: 3, title: 'The Silent Witness', genre: 'Mystery | Drama', duration: 110, language: 'Hindi', rating: 7.5, description: 'When a small-town detective encounters a cryptic witness, the case leads him down a dark path uncovering secrets buried for decades.', posterUrl: 'assets/posters/movie3.jpg'),
  Movie(movieId: 4, title: 'Neon Samurai', genre: 'Cyberpunk | Action', duration: 120, language: 'Japanese', rating: 8.0, description: 'In a rain-soaked futuristic metropolis, a cybernetically enhanced samurai seeks revenge against the mega-corporation that built him.', posterUrl: 'assets/posters/movie4.jpg'),
  Movie(movieId: 5, title: 'Ancient Echoes', genre: 'Horror | Supernatural', duration: 95, language: 'Spanish', rating: 6.9, description: 'A group of archaeologists awakens an ancient curse in a remote jungle temple, trapping them in a nightmare where reality blurs with myth.', posterUrl: 'assets/posters/movie5.jpg'),
];

// Dummy Showtimes (for Movie 1: Crimson Fury)
final List<Showtime> dummyShowtimes = [
  Showtime(showtimeId: 101, date: DateTime.now(), time: '10:00 AM', price: 12.50),
  Showtime(showtimeId: 102, date: DateTime.now(), time: '02:30 PM', price: 15.00),
  Showtime(showtimeId: 103, date: DateTime.now(), time: '06:00 PM', price: 18.00),
  Showtime(showtimeId: 104, date: DateTime.now().add(const Duration(days: 1)), time: '11:00 AM', price: 12.50),
  Showtime(showtimeId: 105, date: DateTime.now().add(const Duration(days: 1)), time: '07:30 PM', price: 18.00),
];

// Dummy Seats for a Showtime (Mimicking checkAvailability logic)
List<Seat> getDummySeats() {
  List<Seat> seats = [];
  const int rows = 8;
  const int cols = 10;
  for (int i = 0; i < rows; i++) {
    String row = String.fromCharCode('A'.codeUnitAt(0) + i);
    for (int j = 1; j <= cols; j++) {
      String seatNum = '$row$j';
      SeatType type = i < 2 ? SeatType.premium : SeatType.standard;
      SeatStatus status;
      if (j % 5 == 0 && i < 6) {
        status = SeatStatus.booked; // Some seats are booked
      } else if (seatNum == 'C3' || seatNum == 'C4') {
        status = SeatStatus.selected; // Pre-select some seats
      } else {
        status = SeatStatus.available;
      }
      seats.add(Seat(seatId: seatNum, seatNumber: seatNum, seatType: type, status: status));
    }
  }
  return seats;
}


final List<Booking> dummyBookings = [
  Booking(
    bookingId: 'TB12345678',
    movie: dummyMovies[0],
    showtime: dummyShowtimes[2], // ✅ Showtime object
    seatNumbers: ['D5', 'D6'],
    totalAmount: 36.00,
    status: 'Confirmed',
  ),
  Booking(
    bookingId: 'TB98765432',
    movie: dummyMovies[3],
    showtime: dummyShowtimes[4], // ✅ Showtime object
    seatNumbers: ['A1', 'A2', 'A3'],
    totalAmount: 54.00,
    status: 'Confirmed',
  ),
  Booking(
    bookingId: 'TB00000001',
    movie: dummyMovies[4],
    showtime: Showtime(
      showtimeId: 999,
      date: DateTime.now().subtract(const Duration(days: 5)),
      time: '09:00 PM',
      price: 10.00,
    ),
    seatNumbers: ['B1'],
    totalAmount: 10.00,
    status: 'Expired',
  ),
];
