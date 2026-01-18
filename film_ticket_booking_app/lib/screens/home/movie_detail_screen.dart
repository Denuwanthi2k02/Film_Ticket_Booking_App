import 'package:flutter/material.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/services/movie_service.dart';
import 'package:film_ticket_booking_app/screens/booking/booking_screen.dart';
import 'package:film_ticket_booking_app/models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieFuture;
  Movie? _movie;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }

  Future<void> _loadMovie() async {
    try {
      _movie = await MovieService.getMovieById(widget.movieId);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading movie: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundBlack,
        body: Center(
          child: CircularProgressIndicator(color: primaryRed),
        ),
      );
    }

    if (_movie == null) {
      return Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'Error loading movie',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return _buildMovieDetailScaffold(context, _movie!);
  }

  Widget _buildMovieDetailScaffold(BuildContext context, Movie movie) {
    const Color neonCyan = Color(0xFF09FBD3);

    return Scaffold(
      backgroundColor: backgroundBlack,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, movie),
              _buildSliverDetails(neonCyan, movie),
            ],
          ),

          
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),

          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundBlack.withOpacity(0.0),
                    backgroundBlack.withOpacity(0.9),
                    backgroundBlack,
                  ],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryRed.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
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
                    'RESERVE SEATS',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SLIVER APP BAR 
  Widget _buildSliverAppBar(BuildContext context, Movie movie) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundBlack,
      expandedHeight: MediaQuery.of(context).size.height * 0.6,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'movie-poster-${movie.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              
              Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie_outlined,
                    color: Colors.white30,
                    size: 100,
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: primaryRed,
                      ),
                    ),
                  );
                },
              ),
              
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                      backgroundBlack.withOpacity(0.8),
                      backgroundBlack,
                    ],
                    stops: const [0.0, 0.4, 0.8, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  DETAILS 
  Widget _buildSliverDetails(Color neonCyan, Movie movie) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MAIN TITLE & RATING PANEL
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accentYellow.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: accentYellow, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toStringAsFixed(1), 
                            style: const TextStyle(
                              color: accentYellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // METADATA TAGS
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildMetaTag(movie.genre.split(' | ')[0].toUpperCase(), primaryRed),
                    _buildMetaTag('${movie.duration} MINS', Colors.white24),
                    _buildMetaTag(movie.language.toUpperCase(), neonCyan),
                    _buildMetaTag('4K • ATMOS', Colors.white24),
                  ],
                ),

                const SizedBox(height: 32),

                // SECTION HEADER
                Row(
                  children: [
                    const Text(
                      'SYNOPSIS',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Divider(color: Colors.white.withOpacity(0.1), thickness: 1)),
                  ],
                ),

                const SizedBox(height: 16),

                // DESCRIPTION
                Text(
                  movie.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == Colors.white24 ? Colors.white70 : color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}