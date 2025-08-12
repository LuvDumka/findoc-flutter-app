import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FindocApp());
}

// Main app widget
class FindocApp extends StatelessWidget {
  const FindocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findoc Gallery',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue.shade600,
        scaffoldBackgroundColor: Colors.white,
        // App bar styling
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // Button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        // Input field styling
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
        ),
        // Using Montserrat font throughout the app
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
