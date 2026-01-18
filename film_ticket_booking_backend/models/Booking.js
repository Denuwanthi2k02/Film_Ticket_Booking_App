const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  movieId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Movie",
    required: true
  },
  showtimeId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Showtime",
    required: true
  },
  seatNumbers: [{
    type: String,
    required: true
  }],
  totalAmount: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['Confirmed', 'Pending', 'Cancelled', 'Expired'],
    default: 'Confirmed'
  },
  bookingId: {
    type: String,
    unique: true,
    required: true
  },
  paymentMethod: {
    type: String,
    default: "Card"
  },
  paymentStatus: {
    type: String,
    enum: ['Paid', 'Pending', 'Failed'],
    default: 'Paid'
  }
}, { timestamps: true });

module.exports = mongoose.model("Booking", bookingSchema);