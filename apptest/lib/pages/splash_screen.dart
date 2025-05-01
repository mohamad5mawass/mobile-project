import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // For showing Lottie animations
import 'package:apptest/pages/auth/ask_user.dart'; // Page to navigate after splash

// This is the Splash Screen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// State class for SplashScreen
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  // Controller to manage w tzabet  the animation
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller to run for 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // When the animation finishes, navigate to AskUserPage
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AskUserPage()),
        );
      }
    });

    // Start running the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the controller when screen is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // Show Lottie animation
            Lottie.asset(
              'assets/splash.json', // Path to your animation file in assets
              controller: _controller, // Use the controller to control animation
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              repeat: false, // Play the animation only once
            ),
            const SizedBox(height: 20), // Space between animation and text
            const Text(
              'Food App', // App name or any text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

