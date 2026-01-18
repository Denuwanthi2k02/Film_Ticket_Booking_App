const mongoose = require("mongoose");

const showtimeSchema = new mongoose.Schema({
  movieId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Movie",
    required: true
  },
  date: {
    type: Date,
    required: true
  },
  time: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  hall: {
    type: String,
    default: "Hall 1"
  },
  totalSeats: {
    type: Number,
    default: 80
  },
  availableSeats: {
    type: Number,
    default: 80
  }
}, { timestamps: true });

module.exports = mongoose.model("Showtime", showtimeSchema);