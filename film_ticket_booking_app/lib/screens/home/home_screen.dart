import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/models/dummy_data.dart';
import 'package:film_ticket_booking_app/screens/home/movie_detail_screen.dart';
import 'package:film_ticket_booking_app/screens/bookings/bookings_screen.dart';
import 'package:film_ticket_booking_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          title: const Text(
            'CINEMA NEXUS',
            style: TextStyle(
              color: foregroundLight,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.0,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: backgroundBlack,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: accentYellow),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: foregroundLight),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Trending Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(width: 4, height: 18, color: primaryRed),
                    const SizedBox(width: 10),
                    const Text(
                      'TRENDING NOW',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        color: foregroundLight,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrendingCarousel(context),
              
              const SizedBox(height: 32),

              // 🎬 Now Showing Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 4, height: 18, color: accentYellow),
                        const SizedBox(width: 10),
                        const Text(
                          'NOW SHOWING',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                            color: foregroundLight,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: accentYellow,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildNowShowingGrid(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: _buildCustomBottomNavBar(context),
      ),
    );
  }

  // ================= TRENDING CAROUSEL =================
  Widget _buildTrendingCarousel(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.4,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.75,
      ),
      items: dummyMovies.take(3).map((movie) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: primaryRed.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Movie poster
                Hero(
                  tag: 'movie-poster-${movie.movieId}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                // Premium Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        backgroundBlack.withOpacity(0.8),
                        backgroundBlack,
                      ],
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: accentYellow, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(
                              color: accentYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              movie.genre.split(' | ')[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= NOW SHOWING GRID =================
  Widget _buildNowShowingGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: dummyMovies.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          final movie = dummyMovies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailScreen(movie: movie),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'grid-poster-${movie.movieId}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: Colors.white38, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${movie.duration}m',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'IMAX',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF09FBD3).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildCustomBottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: BoxDecoration(
        color: backgroundBlack.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navBarItem(Icons.movie_creation_outlined, 'FILMS', true),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingsScreen(),
                ),
              );
            },
            child: _navBarItem(Icons.confirmation_number_outlined, 'TICKETS', false),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            child: _navBarItem(Icons.person_outline_rounded, 'STUDIO', false),
          ),
        ],
      ),
    );
  }

  Widget _navBarItem(IconData icon, String label, bool selected) {
    final color = selected ? accentYellow : Colors.white38;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(color: accentYellow, shape: BoxShape.circle),
          ),
      ],
    );
  }
}