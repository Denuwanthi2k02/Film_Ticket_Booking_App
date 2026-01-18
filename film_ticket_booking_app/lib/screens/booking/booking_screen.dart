import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/services/showtime_service.dart';
import 'package:film_ticket_booking_app/screens/booking/payment_screen.dart';
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
  List<Showtime> _showtimes = [];
  List<Seat> _seats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShowtimes();
  }

  Future<void> _loadShowtimes() async {
    try {
      final showtimes = await ShowtimeService.getShowtimesByMovie(widget.movie.id);
      setState(() {
        _showtimes = showtimes;
        if (showtimes.isNotEmpty) {
          _selectedDate = showtimes.first.date;
          _selectedShowtime = showtimes.first;
          _seats = _generateSeats(); 
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading showtimes: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Seat> _generateSeats() {
    List<Seat> seats = [];
    const int rows = 8;
    const int cols = 10;
    
    for (int i = 0; i < rows; i++) {
      String row = String.fromCharCode('A'.codeUnitAt(0) + i);
      for (int j = 1; j <= cols; j++) {
        String seatNum = '$row$j';
        SeatType type = i < 2 ? SeatType.premium : SeatType.standard;
        SeatStatus status = SeatStatus.available; 
        
        
        if (j % 5 == 0 && i < 6) {
          status = SeatStatus.booked;
        }
        
        seats.add(Seat(
          seatId: seatNum,
          seatNumber: seatNum,
          seatType: type,
          status: status,
        ));
      }
    }
    return seats;
  }

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
    
      _selectedShowtime = _showtimes.firstWhere(
        (st) => DateUtils.isSameDay(st.date, date),
        orElse: () => _showtimes.first,
      );
      _seats = _generateSeats();
    });
  }

  void _selectShowtime(Showtime showtime) {
    setState(() {
      _selectedShowtime = showtime;
      _selectedDate = showtime.date;
      _seats = _generateSeats();
    });
  }

  List<Seat> get _selectedSeats => _seats.where((s) => s.status == SeatStatus.selected).toList();
  double get _totalAmount => _selectedSeats.length * (_selectedShowtime?.price ?? 0.0);
  String get _selectedSeatNumbers => _selectedSeats.map((s) => s.seatNumber).join(', ');

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          title: Text(
            widget.movie.title.toUpperCase(), 
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: primaryRed),
        ),
      );
    }

    if (_showtimes.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          title: Text(
            widget.movie.title.toUpperCase(), 
            style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: primaryRed, size: 50),
              const SizedBox(height: 20),
              Text(
                'No showtimes available',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundBlack,
      appBar: AppBar(
        title: Text(
          widget.movie.title.toUpperCase(), 
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
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

  Widget _buildDateSelector() {
    final uniqueDates = _showtimes
        .map((st) => st.date)
        .where((date) => date.isAfter(DateTime.now().subtract(const Duration(hours: 12))))
        .toSet()
        .toList();
    uniqueDates.sort();

    if (uniqueDates.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 12.0),
          child: Text(
            'SELECT DATE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: uniqueDates.length,
            itemBuilder: (context, index) {
              final date = uniqueDates[index];
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              return GestureDetector(
                onTap: () => _selectDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryRed : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? primaryRed : Colors.white.withOpacity(0.08),
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(color: primaryRed.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                    ] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date).toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
    final availableShowtimes = _showtimes.where((st) => 
      _selectedDate != null && DateUtils.isSameDay(st.date, _selectedDate!)).toList();

    if (availableShowtimes.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0, bottom: 12.0),
          child: Text(
            'SELECT SHOWTIME',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: availableShowtimes.map((st) {
              final isSelected = st.id == _selectedShowtime?.id;

              return GestureDetector(
                onTap: () => _selectShowtime(st),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF09FBD3).withOpacity(0.1) : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF09FBD3) : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    st.time,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF09FBD3) : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatMap(BuildContext context) {
    if (_seats.isEmpty) {
      return Container();
    }

    final seatNumbers = _seats.map((s) => s.seatNumber).toList();
    final rows = seatNumbers.map((s) => s.substring(0, 1)).toSet().toList()..sort();
    final cols = seatNumbers.map((s) => int.parse(s.substring(1))).toSet().toList()..sort();
    final numCols = cols.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          // Cyberpunk Screen
          Column(
            children: [
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      primaryRed.withOpacity(0),
                      primaryRed,
                      primaryRed.withOpacity(0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(color: primaryRed.withOpacity(0.8), blurRadius: 15, spreadRadius: 2),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'SCREEN',
                style: TextStyle(
                  color: primaryRed.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numCols + 1,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: (numCols + 1) * rows.length,
              itemBuilder: (context, index) {
                final row = rows[index ~/ (numCols + 1)];
                final colIndex = index % (numCols + 1);

                if (colIndex == 0) {
                  return Center(
                    child: Text(
                      row,
                      style: TextStyle(color: Colors.white.withOpacity(0.2), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  );
                }

                final seatNumber = '$row${cols[colIndex - 1]}';
                final seat = _seats.firstWhere((s) => s.seatNumber == seatNumber);
                
                return _buildSeatWidget(seat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatWidget(Seat seat) {
    bool isSelected = seat.status == SeatStatus.selected;
    bool isBooked = seat.status == SeatStatus.booked;
    bool isPremium = seat.seatType == SeatType.premium;

    Color color = Colors.transparent;
    Color border = Colors.white.withOpacity(0.15);
    
    if (isBooked) {
      color = Colors.white.withOpacity(0.05);
      border = Colors.transparent;
    } else if (isSelected) {
      color = primaryRed;
      border = primaryRed;
    } else if (isPremium) {
      border = accentYellow.withOpacity(0.5);
    }

    return GestureDetector(
      onTap: () => _selectSeat(seat),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: border, width: 1.5),
          boxShadow: isSelected ? [
            BoxShadow(color: primaryRed.withOpacity(0.4), blurRadius: 8)
          ] : [],
        ),
        child: Center(
          child: Text(
            isBooked ? '' : seat.seatNumber.substring(1),
            style: TextStyle(
              fontSize: 8,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _legendItem(Colors.transparent, 'FREE', Colors.white.withOpacity(0.2)),
          _legendItem(Colors.white.withOpacity(0.1), 'TAKEN', Colors.transparent),
          _legendItem(primaryRed, 'YOURS', primaryRed),
          _legendItem(Colors.transparent, 'PREMIUM', accentYellow),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.4), letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
    final bool canProceed = _selectedSeats.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedSeats.length} SEATS SELECTED',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedSeats.isEmpty ? 'NONE' : _selectedSeatNumbers,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL PRICE',
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs${_totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(color: primaryRed, fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                disabledBackgroundColor: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: canProceed ? () {
                if (_selectedShowtime != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                    movie: widget.movie,
                    showtime: _selectedShowtime!,
                    seats: _selectedSeats,
                    totalAmount: _totalAmount,
                  )));
                }
              } : null,
              child: Text(
                canProceed ? 'PROCEED TO PAYMENT' : 'CHOOSE YOUR SEATS',
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 2,
                  color: canProceed ? Colors.white : Colors.white24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}