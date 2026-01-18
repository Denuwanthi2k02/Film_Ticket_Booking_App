const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const Movie = require('./models/Movie');
const Showtime = require('./models/Showtime');
const User = require('./models/User');
require('dotenv').config();

async function seedData() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI);
    console.log('Connected to MongoDB for seeding');

    // Clear existing data (optional)
    await Movie.deleteMany({});
    await Showtime.deleteMany({});
    console.log('Cleared existing data');

    // 1. Create Movies
    const movies = [
      {
        title: 'Disney',
        genre: 'Action | Thriller',
        duration: 135,
        language: 'English',
        rating: 8.7,
        description: 'A rogue agent races against time to expose a global conspiracy before it plunges the world into chaos. Featuring breathtaking stunts and non-stop action.',
        posterUrl: 'assests/posters/movie1.png',
        releaseDate: new Date('2024-03-15'),
        isActive: true
      },
      {
        title: 'Pocahontas',
        genre: 'Sci-Fi | Adventure',
        duration: 150,
        language: 'English',
        rating: 9.1,
        description: 'A lone starship captain undertakes a perilous journey across the galaxy to find the source of a mysterious signal that could save or doom humanity.',
        posterUrl: 'assests/posters/movie2.png',
        releaseDate: new Date('2024-03-20'),
        isActive: true
      },
      {
        title: 'Dora And The Lost City Of Gold',
        genre: 'Mystery | Drama',
        duration: 110,
        language: 'Hindi',
        rating: 7.5,
        description: 'When a small-town detective encounters a cryptic witness, the case leads him down a dark path uncovering secrets buried for decades.',
        posterUrl: 'assests/posters/movie3.png',
        releaseDate: new Date('2024-03-10'),
        isActive: true
      },
      {
        title: 'The Assassin',
        genre: 'Cyberpunk | Action',
        duration: 120,
        language: 'Japanese',
        rating: 8.0,
        description: 'In a rain-soaked futuristic metropolis, a cybernetically enhanced samurai seeks revenge against the mega-corporation that built him.',
        posterUrl: 'assests/posters/movie4.png',
        releaseDate: new Date('2024-03-25'),
        isActive: true
      },
      {
        title: 'She Came To Me',
        genre: 'Horror | Supernatural',
        duration: 95,
        language: 'Spanish',
        rating: 6.9,
        description: 'A group of archaeologists awakens an ancient curse in a remote jungle temple, trapping them in a nightmare where reality blurs with myth.',
        posterUrl: 'assests/posters/movie5.png',
        releaseDate: new Date('2024-03-05'),
        isActive: true
      }
    ];

    const savedMovies = await Movie.insertMany(movies);
    console.log(`Created ${savedMovies.length} movies`);

    // 2. Create Showtimes for each movie
    const showtimes = [];
    
    savedMovies.forEach((movie, index) => {
      // Create 3-5 showtimes for each movie
      const movieShowtimes = [
        {
          movieId: movie._id,
          date: new Date(new Date().setDate(new Date().getDate() + index)),
          time: '10:00 AM',
          price: 400.00,
          hall: 'Hall A',
          totalSeats: 80,
          availableSeats: 80 - (index * 10) // Vary availability
        },
        {
          movieId: movie._id,
          date: new Date(new Date().setDate(new Date().getDate() + index)),
          time: '02:30 PM',
          price: 300.00,
          hall: 'Hall B',
          totalSeats: 80,
          availableSeats: 80 - (index * 15)
        },
        {
          movieId: movie._id,
          date: new Date(new Date().setDate(new Date().getDate() + index + 1)),
          time: '06:00 PM',
          price: 400.00,
          hall: 'Hall C',
          totalSeats: 80,
          availableSeats: 80 - (index * 8)
        },
        {
          movieId: movie._id,
          date: new Date(new Date().setDate(new Date().getDate() + index + 1)),
          time: '09:30 PM',
          price: 200.00,
          hall: 'Premium Hall',
          totalSeats: 50,
          availableSeats: 50 - (index * 5)
        }
      ];
      
      showtimes.push(...movieShowtimes);
    });

    const savedShowtimes = await Showtime.insertMany(showtimes);
    console.log(`Created ${savedShowtimes.length} showtimes`);


    console.log('✅ Database seeded successfully!');
    process.exit(0);

  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
}

// Run the seed function
seedData();