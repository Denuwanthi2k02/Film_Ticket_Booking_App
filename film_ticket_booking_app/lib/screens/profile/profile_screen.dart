import 'package:flutter/material.dart';
import '../../config/theme_config.dart'; // Using backgroundBlack, primaryRed, accentYellow, etc.
import '../../models/user.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Creative Palette extension based on existing theme
    const Color neonCyan = Color(0xFF09FBD3);
    const Color glassWhite = Colors.white10;

    return Scaffold(
      backgroundColor: backgroundBlack,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'THE STUDIO',
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: foregroundLight,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: accentYellow),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: AuthService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryRed),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error fetching your profile"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // --- Creative Header with Gradient & Avatar ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic background glow
                    Container(
                      height: 380,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF3E060E), // Deep muted red
                            backgroundBlack,
                          ],
                        ),
                      ),
                    ),
                    // Glassmorphic Ring
                    Positioned(
                      top: 100,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryRed.withOpacity(0.05),
                          border: Border.all(color: primaryRed.withOpacity(0.1), width: 1),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 110),
                        // Avatar with Neon-bordered Container
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [primaryRed, accentYellow],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: bookedGrey,
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "PREMIUM CRITIC",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: accentYellow,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // --- Stats Row ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("CREDITS", "240"),
                      _buildStatItem("MOVIES", "18"),
                      _buildStatItem("REVIEWS", "5"),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- Details & Preferences ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(title: "PERSONAL INFO", color: primaryRed),
                      const SizedBox(height: 16),
                      _buildInfoBox(Icons.alternate_email, "Email", user.email),
                      _buildInfoBox(Icons.phone_android, "Phone", user.phone),
                      
                      const SizedBox(height: 32),
                      
                      const _SectionHeader(title: "CINEMA SETTINGS", color: accentYellow),
                      const SizedBox(height: 16),
                      _buildMenuTile(Icons.history, "Booking History", Colors.white),
                      _buildMenuTile(Icons.local_activity_outlined, "Active Tickets", neonCyan),
                      _buildMenuTile(Icons.favorite_outline, "My Watchlist", primaryRed),
                      
                      const SizedBox(height: 40),
                      
                      // Creative Logout Button
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "SIGN OUT",
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white38, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildInfoBox(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentYellow, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text(value, style: const TextStyle(color: foregroundLight, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.white.withOpacity(0.02),
        leading: Icon(icon, color: color, size: 22),
        title: Text(title, style: const TextStyle(color: foregroundLight, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
        onTap: () {},
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: foregroundLight,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}