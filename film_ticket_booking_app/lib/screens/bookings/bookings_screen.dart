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
      backgroundColor: backgroundBlack,
      appBar: AppBar(
        title: const Text(
          'MY TICKETS',
          style: TextStyle(
            color: foregroundLight,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.0,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: accentYellow, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: dummyBookings.isEmpty
          ? _emptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryRed.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.confirmation_number_outlined, size: 60, color: primaryRed),
          ),
          const SizedBox(height: 24),
          const Text(
            'NO ADMISSIONS YET',
            style: TextStyle(
              color: foregroundLight,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Time to catch a new release!',
            style: TextStyle(color: foregroundLight.withOpacity(0.5), fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ================= CREATIVE BOOKING CARD =================
  Widget _bookingCard(BuildContext context, Booking booking) {
    const Color neonCyan = Color(0xFF09FBD3);
    final dateFormat = DateFormat('EEE, MMM d');
    final formattedDateTime = '${dateFormat.format(booking.showtime.date)} at ${booking.showtime.time}';
    final isExpired = booking.status == 'Expired';

    final qrData = 'BookingID: ${booking.bookingId}|${booking.movie.title}|${booking.seatNumbers.join(', ')}';
    
    Color statusAccent = isExpired ? Colors.white24 : (booking.status == 'Confirmed' ? neonCyan : primaryRed);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Movie Poster Section
              Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      isExpired ? Colors.black.withOpacity(0.8) : Colors.transparent, 
                      BlendMode.darken
                    ),
                    child: Image.asset(
                      booking.movie.posterUrl, 
                      width: 110,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isExpired) 
                    const Positioned.fill(
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'VOID',
                            style: TextStyle(
                              color: Colors.white24,
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // 2. Booking Info Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.movie.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(Icons.calendar_today_rounded, formattedDateTime, isExpired),
                      _buildDetailRow(Icons.chair_alt_rounded, 'Seats: ${booking.seatNumbers.join(', ')}', isExpired),
                      const Spacer(),
                      
                      // Status Indicator
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (!isExpired)
                                  BoxShadow(color: statusAccent.withOpacity(0.5), blurRadius: 6),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            booking.status.toUpperCase(),
                            style: TextStyle(
                              color: statusAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. QR TICKET ACTION SECTION
              Container(
                width: 75,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  border: Border(left: BorderSide(color: Colors.white.withOpacity(0.05))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Visual Divider Dots (Ticket aesthetic)
                    ...List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                    )),
                    const SizedBox(height: 15),
                    IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: isExpired ? Colors.white10 : accentYellow,
                      ),
                      iconSize: 32,
                      onPressed: isExpired ? null : () => _showQrDialog(context, booking, qrData),
                    ),
                    const SizedBox(height: 15),
                    ...List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String text, bool isExpired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isExpired ? Colors.white24 : accentYellow.withOpacity(0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isExpired ? Colors.white24 : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context, Booking booking, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundBlack,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ADMIT ONE',
                  style: TextStyle(
                    color: foregroundLight,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  booking.movie.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'SEATS: ${booking.seatNumbers.join(', ')}',
                  style: const TextStyle(color: accentYellow, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'DISMISS',
                    style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}