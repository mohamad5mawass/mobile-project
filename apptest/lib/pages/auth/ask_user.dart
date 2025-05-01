import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // For showing Lottie animations
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

import 'package:apptest/pages/auth/client/client_login.dart'; // Importing ClientLoginPage

class AskUserPage extends StatelessWidget {
  const AskUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            // Adding gradient background
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple.shade50,
                Colors.deepPurple.shade100,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centering children vertically
            children: [
              // Display Lottie animation
              Lottie.asset(
                'assets/splash.json', // Animation path
                width: 240,
                height: 240,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40), // Space between animation and title

              // Title
              Text(
                'Welcome to FoodApp',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),

              const SizedBox(height: 30), // Space between title and subtitle

              // Subtitle
              Text(
                'Choose Your Role',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.deepPurple.shade600,
                ),
              ),

              const SizedBox(height: 40), // Space between subtitle and buttons

              // Authentication buttons for different roles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildRoleButton(
                      context,
                      'Owner', // Button for "Owner"
                      Icons.business_center_rounded,
                      Colors.deepPurple.shade400,
                          () {
                        // Snack bar for "Owner"
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🚀 Coming Soon  !!!!! 🎉'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20), // Space between buttons

                    _buildRoleButton(
                      context,
                      'Restaurant', // Button for "Restaurant"
                      Icons.restaurant_rounded,
                      Colors.green.shade400,
                          () {
                        // Snack bar for "Restaurant"
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🚀 Coming Soon !!!! 🎉'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        // Optionally navigate to Restaurant Login page
                      },
                    ),
                    const SizedBox(height: 20), // Space between buttons

                    _buildRoleButton(
                      context,
                      'Client', // Button for "Client"
                      Icons.person_rounded,
                      Colors.blue.shade400,
                          () {
                        // Navigate to Client Login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ClientLoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each role button
  Widget _buildRoleButton(
      BuildContext context,
      String role, // Role name for button text
      IconData icon, // Icon for the button
      Color color, // Color for the button
      VoidCallback onPressed, // Callback for button press action
      ) {
    return ElevatedButton(
      onPressed: onPressed, // Action when button is pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Button color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 5, // Shadow for button
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center content in row
        children: [
          Icon(icon, size: 24), // Display icon
          const SizedBox(width: 10), // Space between icon and text
          Text(
            'Continue as $role', // Button text: e.g., "Continue as Owner"
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
