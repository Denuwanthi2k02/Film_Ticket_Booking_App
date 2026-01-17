// lib/screens/booking/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/screens/ticket/ticket_screen.dart';
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';
import 'package:film_ticket_booking_app/models/seat.dart';



class PaymentScreen extends StatelessWidget {
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

  // Dummy payment simulation
  Future<bool> _simulatePayment() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful payment
    return true; 
  }

  void _processPayment(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing payment...')));
    bool success = await _simulatePayment();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful!')));
      // Navigate to Ticket Screen
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => TicketScreen(
          movie: movie, 
          showtime: showtime, 
          seats: seats, 
          bookingId: 'BK${DateTime.now().millisecondsSinceEpoch}', // Dummy ID
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Failed. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm & Pay'),
        backgroundColor: backgroundBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryRed)),
            const Divider(color: foregroundLight),
            _buildSummaryRow('Movie', movie.title),
            _buildSummaryRow('Time', '${DateFormat('MMM d').format(showtime.date)} at ${showtime.time}'),
            _buildSummaryRow('Seats', seats.map((s) => s.seatNumber).join(', ')),
            const Spacer(),
            
            // Payment Gateway Integration Placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: foregroundLight.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Method: Stripe (Dummy)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Card ending in **** 4242', style: TextStyle(color: foregroundLight.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Total and Pay Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL AMOUNT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryRed)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _processPayment(context),
                child: const Text('CONFIRM PAYMENT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title:', style: TextStyle(fontSize: 16, color: foregroundLight.withOpacity(0.7))),
          Flexible(
            child: Text(value, 
              style: const TextStyle(fontSize: 16, color: foregroundLight, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}