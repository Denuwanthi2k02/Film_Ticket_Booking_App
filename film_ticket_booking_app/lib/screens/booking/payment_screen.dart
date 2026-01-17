import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/screens/ticket/ticket_screen.dart';
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';
import 'package:film_ticket_booking_app/models/seat.dart';

class PaymentScreen extends StatefulWidget {
  final Movie movie;
  final Showtime showtime;
  final List<Seat> seats;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.movie,
    required this.showtime,
    required this.seats,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment(BuildContext context) async {
    setState(() => _isProcessing = true);

    // Simulate network delay for premium feel
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Navigate to Ticket Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          movie: widget.movie,
          showtime: widget.showtime,
          seats: widget.seats,
          bookingId: 'NOVA-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        ),
      ),
      (route) => route.isFirst, // Go back to home after ticket
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      appBar: AppBar(
        title: const Text(
          'CHECKOUT',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 14),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'ORDER SUMMARY',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOrderSummaryCard(),
                const Spacer(),
                _buildPriceBreakdown(),
                const SizedBox(height: 24),
                _buildPayButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.movie.title.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(Icons.calendar_today_outlined, 'DATE', DateFormat('EEEE, MMM d').format(widget.showtime.date)),
          _buildSummaryRow(Icons.access_time_rounded, 'TIME', widget.showtime.time),
          _buildSummaryRow(Icons.chair_outlined, 'SEATS', widget.seats.map((s) => s.seatNumber).join(', ')),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white10),
          ),
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF09FBD3)),
              const SizedBox(width: 8),
              Text(
                'SECURE TRANSACTION BY CINEMA NEXUS PAY',
                style: TextStyle(
                  color: const Color(0xFF09FBD3).withOpacity(0.8),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryRed),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SUBTOTAL', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12, fontWeight: FontWeight.bold)),
            Text('\$${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SERVICE FEE', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12, fontWeight: FontWeight.bold)),
            const Text('\$1.50', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(color: Colors.white10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TOTAL PAYABLE', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
            Text(
              '\$${(widget.totalAmount + 1.5).toStringAsFixed(2)}',
              style: const TextStyle(color: primaryRed, fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: () => _processPayment(context),
        child: const Text(
          'CONFIRM & PAY',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: primaryRed,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'ENCRYPTING TRANSACTION...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'PLEASE DO NOT CLOSE THE APP',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}