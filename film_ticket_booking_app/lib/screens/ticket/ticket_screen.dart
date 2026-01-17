import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
// Note: This needs the custom widget below, make sure it's in lib/widgets/
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
      appBar: AppBar(
        title: const Text('Your Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundBlack,
        automaticallyImplyLeading: false, // Prevents accidental back navigation
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Ticket Card Container ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Light background for high contrast
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section (Movie Info)
                    _buildTicketHeader(),
                    
                    // Perforated Divider (Simulates a tear-off stub)
                    const PerforatedDivider(),

                    // Bottom Section (QR Code & Details)
                    _buildTicketFooter(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Action Button to return home
              TextButton.icon(
                onPressed: () {
                  // Navigate back to the Home Screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home, color: primaryRed),
                label: const Text('Back to Home Screen', style: TextStyle(color: primaryRed, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    // Calculate total price
    final double totalPrice = showtime.price * seats.length;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Title
          Text(movie.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black)),
          
          const SizedBox(height: 10),
          // Booking Details
          _buildDetailRow('Date', DateFormat('EEEE, MMM d, y').format(showtime.date), Colors.black54),
          _buildDetailRow('Time', showtime.time, Colors.black54),
          _buildDetailRow('Hall', 'Cineplex Main Hall 3', Colors.black54), // Dummy Cinema/Hall
          
          const SizedBox(height: 15),
          
          // Seat Numbers (Highlighted in Primary Red)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SEATS:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(
                seats.map((s) => s.seatNumber).join(', '),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primaryRed),
              ),
            ],
          ),
           const SizedBox(height: 5),
          _buildDetailRow('Price Paid', '\$${totalPrice.toStringAsFixed(2)}', primaryRed),
        ],
      ),
    );
  }

  Widget _buildTicketFooter() {
    // Data encoded in QR code
    final qrData = 'BookingID: $bookingId | Movie: ${movie.title} | Time: ${showtime.time} | Seats: ${seats.map((s) => s.seatNumber).join(',')}';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // QR Code 
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 150.0,
            foregroundColor: Colors.black,
            // A subtle glow effect could be added here if desired:
            // eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: primaryRed),
          ),
          const SizedBox(height: 15),
          
          // Booking ID Detail
          _buildDetailRow('Booking Reference', bookingId, Colors.black87),
          _buildDetailRow('Ticket Type', 'Digital', Colors.black87),
        ],
      ),
    );
  }

  // Reusable row for ticket details
  Widget _buildDetailRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: color)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}