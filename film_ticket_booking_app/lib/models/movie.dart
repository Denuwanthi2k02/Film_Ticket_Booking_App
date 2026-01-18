class Movie {
  final String id;
  final String title;
  final String genre;
  final int duration;
  final String language;
  final double rating;
  final String description;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.language,
    required this.rating,
    required this.description,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      genre: json['genre'] ?? '',
      duration: json['duration']?.toInt() ?? 0,
      language: json['language'] ?? '',
      rating: (json['rating'] is int ? json['rating'].toDouble() : json['rating']) ?? 0.0,
      description: json['description'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
    );
  }

  // Optional: Add toJson method if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'duration': duration,
      'language': language,
      'rating': rating,
      'description': description,
      'posterUrl': posterUrl,
    };
  }
}