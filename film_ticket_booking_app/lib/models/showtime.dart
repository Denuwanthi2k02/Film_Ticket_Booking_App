class Showtime {
  final String id;
  final String movieId;
  final DateTime date;
  final String time;
  final double price;
  final String? hall;
  final int? availableSeats;

  Showtime({
    required this.id,
    required this.movieId,
    required this.date,
    required this.time,
    required this.price,
    this.hall,
    this.availableSeats,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return Showtime(
      id: json['_id'] ?? json['id'] ?? '',
      movieId: json['movieId'] is String 
          ? json['movieId'] 
          : (json['movieId']?['_id'] ?? ''),
      date: parseDate(json['date']),
      time: json['time'] ?? '',
      price: (json['price'] is int ? json['price'].toDouble() : json['price']) ?? 0.0,
      hall: json['hall'],
      availableSeats: json['availableSeats']?.toInt(),
    );
  }
}