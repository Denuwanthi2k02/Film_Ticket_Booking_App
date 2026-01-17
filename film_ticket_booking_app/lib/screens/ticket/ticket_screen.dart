import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/widgets/perforated_divider.dart'; 
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';
import 'package:film_ticket_booking_app/models/seat.dart';

class TicketScreen extends StatelessWidget {
  final Movie movie;
  final Showtime showtime;
  final List<Seat> seats;
  final String bookingId;

  const TicketScreen({
    super.key,
    required this.movie,
    required this.showtime,
    required this.seats,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      appBar: AppBar(
        title: const Text(
          'DIGITAL PASS',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 14),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              // --- Ticket Card Container ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    // Top Section: Movie Branding
                    _buildTicketHeader(),
                    
                    // Perforated Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildCutterCircle(),
                          const Expanded(child: PerforatedDivider()),
                          _buildCutterCircle(),
                        ],
                      ),
                    ),

                    // Bottom Section: QR & Validation
                    _buildTicketFooter(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Back to Home Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'RETURN TO HOME',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.1),
                  border: Border.all(color: primaryRed.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'CONFIRMED',
                  style: TextStyle(color: primaryRed, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
              Text(
                'REF: #$bookingId',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            movie.title.toUpperCase(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
          ),
          const SizedBox(height: 24),
          _buildInfoGrid(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: [
        _buildInfoItem('DATE', DateFormat('MMM d, y').format(showtime.date)),
        _buildInfoItem('TIME', showtime.time),
        _buildInfoItem('HALL', 'PREMIUM 03'),
        _buildInfoItem('SEATS', seats.map((s) => s.seatNumber).join(', ')),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTicketFooter() {
    final qrData = 'ID:$bookingId|M:${movie.title}|S:${seats.length}';

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF09FBD3).withOpacity(0.2), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 140.0,
              gapless: false,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'SCAN AT GATE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'PLEASE ARRIVE 15 MINS EARLY',
            style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCutterCircle() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: backgroundBlack,
        shape: BoxShape.circle,
      ),
    );
  }
}