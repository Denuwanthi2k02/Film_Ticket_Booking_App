import 'package:flutter/material.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/screens/booking/booking_screen.dart';
import 'package:film_ticket_booking_app/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              _buildSliverDetails(),
            ],
          ),

          // BOOK TICKETS BUTTON
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 10,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(movie: movie),
                    ),
                  );
                },
                child: const Text(
                  'BOOK TICKETS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SLIVER APP BAR =================
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundBlack,
      expandedHeight: 450,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Text(
          movie.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: foregroundLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Hero(
          tag: 'movie-poster-${movie.movieId}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ FIXED IMAGE
              Image.asset(
                movie.posterUrl,
                fit: BoxFit.cover,
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      backgroundBlack.withOpacity(0.95),
                    ],
                    stops: const [0.65, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DETAILS =================
  Widget _buildSliverDetails() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MOVIE INFO CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundBlack,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: foregroundLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: accentYellow, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            '${movie.rating}/10',
                            style: const TextStyle(
                              color: accentYellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '| ${movie.duration} mins',
                            style: TextStyle(
                              color: foregroundLight.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '| ${movie.language}',
                            style: TextStyle(
                              color: foregroundLight.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.genre,
                        style: const TextStyle(
                          color: primaryRed,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // SYNOPSIS
                const Text(
                  'Synopsis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: foregroundLight,
                  ),
                ),
                const Divider(
                  color: primaryRed,
                  thickness: 1.5,
                  endIndent: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  movie.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: foregroundLight.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
