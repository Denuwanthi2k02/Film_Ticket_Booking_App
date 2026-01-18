enum SeatStatus { available, booked, selected }
enum SeatType { standard, premium, vip }

class Seat {
  final String seatId;
  final String seatNumber; 
  final SeatType seatType;
  final SeatStatus status;

  Seat({
    required this.seatId,
    required this.seatNumber,
    required this.seatType,
    required this.status,
  });

  Seat copyWith({SeatStatus? status}) {
    return Seat(
      seatId: seatId,
      seatNumber: seatNumber,
      seatType: seatType,
      status: status ?? this.status,
    );
  }
}
