// lib/screens/booking/booking_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/models/dummy_data.dart';
import 'package:film_ticket_booking_app/screens/booking/payment_screen.dart'; // Future Screen
import 'package:film_ticket_booking_app/models/movie.dart';
import 'package:film_ticket_booking_app/models/showtime.dart';
import 'package:film_ticket_booking_app/models/seat.dart';




class BookingScreen extends StatefulWidget {
  final Movie movie;

  const BookingScreen({super.key, required this.movie});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  Showtime? _selectedShowtime;
  List<Seat> _seats = [];

  @override
  void initState() {
    super.initState();
    // Initialize with the first date/showtime and dummy seats
    _selectedDate = dummyShowtimes.first.date;
    _selectedShowtime = dummyShowtimes.first;
    _seats = getDummySeats();
  }
  
  // --- State Management Logic ---
  void _selectSeat(Seat seat) {
    if (seat.status == SeatStatus.booked) return;

    setState(() {
      int index = _seats.indexWhere((s) => s.seatId == seat.seatId);
      if (index != -1) {
        if (seat.status == SeatStatus.selected) {
          _seats[index] = seat.copyWith(status: SeatStatus.available);
        } else {
          _seats[index] = seat.copyWith(status: SeatStatus.selected);
        }
      }
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Reset showtime selection when date changes
      _selectedShowtime = dummyShowtimes.firstWhere(
        (st) => DateUtils.isSameDay(st.date, date),
        orElse: () => dummyShowtimes.first,
      );
      // Re-fetch/Re-generate dummy seats for the new showtime
      _seats = getDummySeats();
    });
  }

  void _selectShowtime(Showtime showtime) {
    setState(() {
      _selectedShowtime = showtime;
      // Re-fetch/Re-generate dummy seats for the new showtime
      _seats = getDummySeats();
    });
  }

  // --- Calculations ---
  List<Seat> get _selectedSeats => _seats.where((s) => s.status == SeatStatus.selected).toList();
  double get _totalAmount => _selectedSeats.length * (_selectedShowtime?.price ?? 0.0);
  String get _selectedSeatNumbers => _selectedSeats.map((s) => s.seatNumber).join(', ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundBlack,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  _buildShowtimeSelector(),
                  _buildSeatMap(context),
                  _buildSeatLegend(),
                ],
              ),
            ),
          ),
          _buildBookingSummary(context),
        ],
      ),
    );
  }

  // --- Widgets ---

  // Part A: Showtime Selection
  Widget _buildDateSelector() {
    // Get unique dates from dummy showtimes
    final uniqueDates = dummyShowtimes.map((st) => st.date).where((date) => date.isAfter(DateTime.now().subtract(const Duration(hours: 12)))).toSet().toList();
    uniqueDates.sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text('📅 Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: uniqueDates.length,
            itemBuilder: (context, index) {
              final date = uniqueDates[index];
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              return GestureDetector(
                onTap: () => _selectDate(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryRed : backgroundBlack.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? primaryRed : foregroundLight.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('EEE').format(date), style: TextStyle(color: isSelected ? Colors.white : foregroundLight.withOpacity(0.8), fontSize: 14)),
                      Text(DateFormat('d').format(date), style: TextStyle(color: isSelected ? Colors.white : foregroundLight, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShowtimeSelector() {
    final availableShowtimes = dummyShowtimes.where((st) => DateUtils.isSameDay(st.date, _selectedDate)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text('🕒 Select Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: availableShowtimes.map((st) {
              final isSelected = st.showtimeId == _selectedShowtime?.showtimeId;
              // Dummy logic for 'unavailable' time slots (e.g., first one on the list)
              final isAvailable = st.showtimeId != availableShowtimes.first.showtimeId || availableShowtimes.length == 1;

              return ChoiceChip(
                label: Text(st.time),
                selected: isSelected,
                onSelected: isAvailable ? (_) => _selectShowtime(st) : null,
                selectedColor: primaryRed,
                backgroundColor: backgroundBlack,
                side: BorderSide(color: isSelected ? primaryRed : foregroundLight.withOpacity(0.3)),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : (isAvailable ? foregroundLight : bookedGrey),
                  decoration: isAvailable ? TextDecoration.none : TextDecoration.lineThrough,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Part B: Seat Selection
  Widget _buildSeatMap(BuildContext context) {
    // Determine number of rows and columns from dummy seats
    final seatNumbers = _seats.map((s) => s.seatNumber).toList();
    final rows = seatNumbers.map((s) => s.substring(0, 1)).toSet().toList()..sort();
    final cols = seatNumbers.map((s) => int.parse(s.substring(1))).toSet().toList()..sort();
    final numCols = cols.length;

    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 20.0),
      child: Column(
        children: [
          // Cinema Screen (Curved, Glowing Line)
          Container(
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: foregroundLight.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryRed.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text('SCREEN', style: TextStyle(color: foregroundLight, fontSize: 12)),
          const SizedBox(height: 25),

          // Seat Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numCols + 1, // +1 for the row label
                childAspectRatio: 1.0,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 2.0,
              ),
              itemCount: (numCols + 1) * rows.length,
              itemBuilder: (context, index) {
                final row = rows[index ~/ (numCols + 1)];
                final colIndex = index % (numCols + 1);

                // Row Label Column
                if (colIndex == 0) {
                  return Center(child: Text(row, style: TextStyle(color: foregroundLight.withOpacity(0.6), fontWeight: FontWeight.bold)));
                }

                // Seat Column
                final seatNumber = '$row${cols[colIndex - 1]}';
                final seat = _seats.firstWhere((s) => s.seatNumber == seatNumber);
                
                Color seatColor;
                Color borderColor;

                switch (seat.status) {
                  case SeatStatus.available:
                    seatColor = Colors.transparent;
                    borderColor = foregroundLight.withOpacity(0.4);
                    break;
                  case SeatStatus.booked:
                    seatColor = bookedGrey;
                    borderColor = bookedGrey;
                    break;
                  case SeatStatus.selected:
                    seatColor = primaryRed;
                    borderColor = primaryRed;
                    break;
                }

                // Premium Seat Border
                if (seat.seatType == SeatType.premium && seat.status != SeatStatus.selected) {
                    borderColor = accentYellow;
                }

                return GestureDetector(
                  onTap: () => _selectSeat(seat),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: seatColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        seat.status == SeatStatus.booked ? 'X' : seat.seatNumber.substring(1),
                        style: TextStyle(
                          fontSize: 10,
                          color: seat.status == SeatStatus.booked ? backgroundBlack : foregroundLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendItem(Colors.transparent, 'Available', foregroundLight.withOpacity(0.4)),
          _legendItem(bookedGrey, 'Booked', bookedGrey),
          _legendItem(primaryRed, 'Selected', primaryRed),
          _legendItem(Colors.transparent, 'Premium', accentYellow),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: foregroundLight.withOpacity(0.8))),
      ],
    );
  }


  // --- Bottom Summary ---
  Widget _buildBookingSummary(BuildContext context) {
    final bool canProceed = _selectedSeats.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      decoration: BoxDecoration(
        color: backgroundBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seats: ${_selectedSeats.length} (${_selectedSeatNumbers})',
                style: const TextStyle(fontSize: 16, color: foregroundLight),
              ),
              Text(
                'Total: \$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryRed),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: canProceed ? () {
                // Navigate to Payment Screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                  movie: widget.movie,
                  showtime: _selectedShowtime!,
                  seats: _selectedSeats,
                  totalAmount: _totalAmount,
                )));
              } : null,
              child: Text(
                canProceed ? 'PROCEED TO PAYMENT' : 'SELECT YOUR SEATS',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}