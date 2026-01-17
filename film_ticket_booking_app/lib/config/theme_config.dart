// lib/config/theme_config.dart
import 'package:flutter/material.dart';

// --- Colors ---
const Color primaryRed = Color(0xFFE50914);
const Color backgroundBlack = Color(0xFF121212);
const Color foregroundLight = Color(0xFFE0E0E0);
const Color accentYellow = Color(0xFFF5C518);
const Color bookedGrey = Color(0xFF333333);
const Color transparentBlack = Color(0x33000000); 

// --- Theme Data ---
final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundBlack,
  primaryColor: primaryRed,
  hintColor: foregroundLight.withOpacity(0.6),
  // Apply a consistent font family if needed, otherwise use default
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: foregroundLight, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: foregroundLight),
    bodyMedium: TextStyle(color: foregroundLight),
    titleMedium: TextStyle(color: foregroundLight),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: primaryRed,
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    // Thin Yellow/Red underline border for inputs
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: foregroundLight.withOpacity(0.5)),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: primaryRed, width: 2.0),
    ),
    labelStyle: TextStyle(color: foregroundLight.withOpacity(0.8)),
    floatingLabelStyle: const TextStyle(color: primaryRed),
  ),
);