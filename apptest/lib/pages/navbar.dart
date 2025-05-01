// Import necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:apptest/pages/navbar_pages/hompage.dart';
import 'package:apptest/pages/navbar_pages/restaurants.dart';
import 'package:apptest/pages/navbar_pages/order.dart';
import 'package:apptest/pages/navbar_pages/profile.dart';

// Main screen with bottom navbar
class NavbarScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NavbarScreen> {
  int _currentIndex = 0; // Track current tab index
  String? _userProfileImageUrl; // Store user profile image
  String? _userLocation; // Store user location

  // List of active navbar icons
  List<String> _activeIcons = ['home', 'restaurant', 'shopping_cart', 'person'];

  // List of inactive navbar icons
  List<String> _inactiveIcons = [
    'home_outlined',
    'restaurant_outlined',
    'shopping_cart_outlined',
    'person_outlined'
  ];

  late List<Widget> _pages; // Pages for each tab

  @override
  void initState() {
    super.initState();
    _initializePages(); // Load pages
    _fetchUserData(); // Load user data
  }

  // Set the pages for tabs
  void _initializePages() {
    _pages = [
      HomePage(),
      RestaurantPage(),
      OrderPage(),
      ProfilePage(),
    ];
  }

  // Parse location string or map from Firestore
  String _parseLocation(dynamic location) {
    if (location == null) return "Location";

    // If location is map, get name field. Else convert to string
    String locationString =
    location is Map ? location['name'] ?? '' : location.toString();

    // Split location by comma
    List<String> parts = locationString.split(',');

    // Remove coordinates if exist
    if (parts.isNotEmpty && RegExp(r'^[A-Z0-9+]').hasMatch(parts[0].trim())) {
      parts.removeAt(0);
    }

    // Return cleaned location string
    return parts.isNotEmpty
        ? parts.map((part) => part.trim()).join(', ')
        : "Location";
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Get user document
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (mounted) {
          setState(() {
            _userProfileImageUrl = userDoc['profileImageUrl'];
            _userLocation = _parseLocation(userDoc['location']);

            // Load custom icons if present
            _activeIcons = List<String>.from(userDoc['activeIcons'] ?? _activeIcons);
            _inactiveIcons = List<String>.from(userDoc['inactiveIcons'] ?? _inactiveIcons);

            // Make sure index is valid
            _currentIndex = _currentIndex < _pages.length ? _currentIndex : 0;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        // Use defaults on error
        setState(() {
          _activeIcons = ['home', 'restaurant', 'shopping_cart', 'person'];
          _inactiveIcons = [
            'home_outlined',
            'restaurant_outlined',
            'shopping_cart_outlined',
            'person_outlined'
          ];
        });
      }
    }
  }

  // Convert icon name to actual Flutter icon
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home': return Icons.home;
      case 'home_outlined': return Icons.home_outlined;
      case 'restaurant': return Icons.restaurant;
      case 'restaurant_outlined': return Icons.restaurant_outlined;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'shopping_cart_outlined': return Icons.shopping_cart_outlined;
      case 'person': return Icons.person;
      case 'person_outlined': return Icons.person_outlined;
      case 'location_pin': return Icons.location_pin;
      case 'location_pin_outlined': return Icons.location_pin;
      default: return Icons.error;
    }
  }

  // Navigate to profile page with animation
  void _navigateToProfilePage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.8, 0.9); // Slide from corner
          var end = Offset.zero;
          var curve = Curves.fastLinearToSlowEaseIn;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          // Smooth scaling + sliding
          return ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 600),
        fullscreenDialog: true, // No app bar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with user location and profile icon
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 20),
                SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    _userLocation ?? "Location",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: _userProfileImageUrl != null
                ? CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(_userProfileImageUrl!),
            )
                : Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),

      // Display the current tab page
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Bottom navigation bar
      bottomNavigationBar: CircleNavBar(
        activeIndex: _currentIndex,
        activeIcons: _activeIcons.map<Icon>((icon) => Icon(
          _getIconData(icon),
          color: Colors.white,
        )).toList(),
        inactiveIcons: _inactiveIcons.map<Icon>((icon) => Icon(
          _getIconData(icon),
          color: Colors.grey,
        )).toList(),
        color: Colors.white,
        circleColor: Colors.blue,
        padding: EdgeInsets.all(16),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        onTap: (index) {
          if (index == 3) {
            // Profile page with custom transition
            _navigateToProfilePage();
            return;
          }

          // Change tab
          if (index < _pages.length) {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}

// Simple button used in categories (icon + label)
class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Card widget for showing deals or offers
class DealCard extends StatelessWidget {
  final String title;
  final int pieces;
  final String time;
  final int price;
  final int discountPrice;
  final String discountPercent;
  final String tag;
  final String productName;

  const DealCard({
    required this.title,
    required this.pieces,
    required this.time,
    required this.price,
    required this.discountPrice,
    required this.discountPercent,
    required this.tag,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with tag and prices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag (e.g., "Best Deal")
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(tag,
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    SizedBox(height: 8),
                    Text(productName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(title, style: TextStyle(fontSize: 14)),
                  ],
                ),
                // Prices info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$$discountPrice',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                    SizedBox(height: 4),
                    Text('\$$price',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)),
                    Text(discountPercent,
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),

            // Availability row
            Row(
              children: [
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 4),
                Text('Available until 24, day 9:00'),
              ],
            ),

            SizedBox(height: 8),

            // Pieces and time row
            Row(
              children: [
                Icon(Icons.shopping_bag, size: 16),
                SizedBox(width: 4),
                Text('Pieces $pieces'),
                Spacer(),
                Text(time),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
