const express = require("express");
const Showtime = require("../models/Showtime");
const Movie = require("../models/Movie");

const router = express.Router();

// Get showtimes for a movie
router.get("/movie/:movieId", async (req, res) => {
  try {
    const { movieId } = req.params;
    const showtimes = await Showtime.find({ 
      movieId,
      date: { $gte: new Date() } // Only future showtimes
    }).sort({ date: 1, time: 1 });
    
    res.status(200).json(showtimes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get showtime by ID
router.get("/:id", async (req, res) => {
  try {
    const showtime = await Showtime.findById(req.params.id)
      .populate("movieId", "title posterUrl duration");
    
    if (!showtime) return res.status(404).json({ message: "Showtime not found" });
    
    res.status(200).json(showtime);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create showtime (Admin only - optional)
router.post("/", async (req, res) => {
  try {
    const showtime = new Showtime(req.body);
    await showtime.save();
    res.status(201).json(showtime);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;