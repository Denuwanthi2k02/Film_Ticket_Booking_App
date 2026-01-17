import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/models/dummy_data.dart';
import 'package:film_ticket_booking_app/models/booking.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tickets', // Changed title to reflect the purpose
          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundBlack,
        elevation: 0,
      ),
      body: dummyBookings.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyBookings.length,
              itemBuilder: (context, index) {
                final booking = dummyBookings[index];
                return _bookingCard(context, booking);
              },
            ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_filter_outlined, size: 60, color: primaryRed),
          const SizedBox(height: 10),
          Text(
            'No bookings yet',
            style: TextStyle(color: foregroundLight.withOpacity(0.8), fontSize: 18),
          ),
          const SizedBox(height: 5),
          const Text(
            'Time to catch a new release!',
            style: TextStyle(color: foregroundLight, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ================= CREATIVE BOOKING CARD =================
  Widget _bookingCard(BuildContext context, Booking booking) {
    // Format date and time
    final dateFormat = DateFormat('EEE, MMM d');
    final formattedDateTime = '${dateFormat.format(booking.showtime.date)} at ${booking.showtime.time}';
    final isExpired = booking.status == 'Expired';

    // The QR data string
    final qrData = 'BookingID: ${booking.bookingId}|${booking.movie.title}|${booking.seatNumbers.join(', ')}';
    
    // Status color logic
    Color statusColor = isExpired ? bookedGrey : primaryRed;
    if (booking.status == 'Confirmed') statusColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: backgroundBlack,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Movie Poster Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isExpired ? Colors.black.withOpacity(0.7) : Colors.transparent, 
                    BlendMode.darken
                  ),
                  child: Image.asset(
                    // Use posterUrl, assuming assets/posters/movieX.jpg exists
                    booking.movie.posterUrl, 
                    width: 100,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Optional: Expired Overlay
              if (isExpired) 
                Positioned.fill(
                  child: Center(
                    child: Text('EXPIRED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, backgroundColor: Colors.black.withOpacity(0.5))),
                  )
                )
            ],
          ),

          // 2. Booking Info Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.movie.title,
                    style: const TextStyle(
                      color: foregroundLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  _buildDetailRow(Icons.calendar_today, formattedDateTime),
                  _buildDetailRow(Icons.event_seat, 'Seats: ${booking.seatNumbers.join(', ')}'),
                  
                  const SizedBox(height: 10),
                  
                  // Status Chip
                  Chip(
                    label: Text(
                      'Status: ${booking.status}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  ),
                ],
              ),
            ),
          ),

          // 3. QR Code / Action Section
          Container(
            width: 70, // Fixed width for QR code column
            height: 160,
            decoration: BoxDecoration(
              color: backgroundBlack.withOpacity(0.8),
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
              border: Border(left: BorderSide(color: statusColor.withOpacity(0.5), width: 1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Mini QR Code
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 45.0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
                
                // View Ticket Button
                IconButton(
                  icon: const Icon(Icons.qr_code_2_rounded),
                  color: isExpired ? bookedGrey : accentYellow,
                  iconSize: 30,
                  onPressed: () {
                    if (!isExpired) {
                      // Navigate to the full Ticket Screen (if you have one)
                      // Or show a dialog with the large QR code
                      _showQrDialog(context, booking, qrData);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // --- Reusable Detail Row ---
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: primaryRed.withOpacity(0.8)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: foregroundLight.withOpacity(0.8), fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // --- QR Code Dialog ---
  void _showQrDialog(BuildContext context, Booking booking, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundBlack,
          title: Text(
            'Scan to Enter', 
            textAlign: TextAlign.center,
            style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Large QR Code for Scanning
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10)
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                booking.movie.title, 
                style: const TextStyle(color: foregroundLight, fontSize: 18, fontWeight: FontWeight.bold)
              ),
              Text(
                'Seats: ${booking.seatNumbers.join(', ')} | ID: ${booking.bookingId}',
                style: TextStyle(color: foregroundLight.withOpacity(0.7), fontSize: 14)
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE', style: TextStyle(color: primaryRed)),
            ),
          ],
        );
      },
    );
  }
}