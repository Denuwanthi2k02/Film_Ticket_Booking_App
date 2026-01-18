const express = require("express");
const Booking = require("../models/Booking");
const Showtime = require("../models/Showtime");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

// Create a booking
router.post("/", authMiddleware, async (req, res) => {
  try {
    const { movieId, showtimeId, seatNumbers, totalAmount } = req.body;
    
    
    if (!movieId || !showtimeId || !seatNumbers || !totalAmount) {
      return res.status(400).json({ message: "All fields are required" });
    }
    
    
    const bookingId = `TB${Date.now()}${Math.floor(Math.random() * 1000)}`;
    
    const booking = new Booking({
      userId: req.userId,
      movieId,
      showtimeId,
      seatNumbers,
      totalAmount,
      bookingId,
      status: 'Confirmed'
    });
    
    await booking.save();
    
    
    await Showtime.findByIdAndUpdate(
      showtimeId,
      { $inc: { availableSeats: -seatNumbers.length } }
    );
    
    res.status(201).json(booking);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user bookings
router.get("/my-bookings", authMiddleware, async (req, res) => {
  try {
    const bookings = await Booking.find({ userId: req.userId })
      .populate("movieId", "title posterUrl genre duration")
      .populate("showtimeId", "date time hall price")
      .sort({ createdAt: -1 });
    
    res.status(200).json(bookings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get booking by ID
router.get("/:id", authMiddleware, async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id)
      .populate("movieId", "title posterUrl genre duration")
      .populate("showtimeId", "date time hall price");
    
    if (!booking) return res.status(404).json({ message: "Booking not found" });
    
    
    if (booking.userId.toString() !== req.userId.toString()) {
      return res.status(403).json({ message: "Unauthorized" });
    }
    
    res.status(200).json(booking);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;