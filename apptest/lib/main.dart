import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // For initializing Firebase
import 'package:apptest/pages/splash_screen.dart'; // Importing SplashScreen
void main() async {
  // Ensure widget binding is initialized before using Firebase
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase with custom configuration
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAjJO0DkylQJa72ex4YDQ4wiIeO1kw6AA8",
        projectId: "apptestshop-d75aa",
        messagingSenderId: "223469946880",
        appId: "1:223469946880:android:5770e23b39d36f787870e5",
        storageBucket: "apptestshop-d75aa.firebasestorage.app",
      ),
    );
    // Run the app if Firebase initialized successfully
    runApp(const MyApp());
  } catch (e) {
    // If Firebase initialization fails, show a simple error screen
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(
              'An error has occurred with your Firebase setup.',
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // App color theme
        useMaterial3: true, // Enable Material 3 design
      ),
      home: const SplashScreen(), // Starting page (Splash Screen)
    );
  }
}
