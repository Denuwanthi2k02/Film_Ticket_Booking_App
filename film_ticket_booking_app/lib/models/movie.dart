class Movie {
  final int movieId;
  final String title;
  final String genre;
  final int duration; // in minutes
  final String language;
  final double rating;
  final String description;
  final String posterUrl; 

  Movie({
    required this.movieId,
    required this.title,
    required this.genre,
    required this.duration,
    required this.language,
    required this.rating,
    required this.description,
    required this.posterUrl,
  });
}