// lib/main.dart
import 'package:flutter/material.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'package:film_ticket_booking_app/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema Booking',
      theme: appTheme, // Use the custom dark theme
      home: const LoginScreen(), // Start with the login screen
    );
  }
}