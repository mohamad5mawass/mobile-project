// Import necessary packages and files
import 'package:apptest/pages/food_info.dart'; // Food information page
import 'package:apptest/pages/navbar_pages/category_info.dart'; // Category information page
import 'package:flutter/material.dart'; // Flutter material design widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:intl/intl.dart'; // For date formatting utilities
import 'package:google_fonts/google_fonts.dart'; // For custom Google fonts
// HomePage widget - the main page of the application
class HomePage extends StatelessWidget {
  // Firebase Firestore instance for database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Utility function to format offer expiration dates from various formats
  String formatOfferExpirationDate(dynamic expirationDate) {
    if (expirationDate == null) return 'No Expiry';
    try {
      // If it's already a DateTime object, format it directly
      if (expirationDate is DateTime) {
        return DateFormat('MMMM d, y').format(expirationDate);
      }
      // If it's a Firestore Timestamp, convert to DateTime first
      if (expirationDate is Timestamp) {
        final dateTime = expirationDate.toDate();
        return DateFormat('MMMM d, y').format(dateTime);
      }
      // If it's a string, return it as is
      if (expirationDate is String) {
        return expirationDate;
      }
      // Fallback for invalid date formats
      return 'Invalid Date';
    } catch (e) {
      print('Error formatting date: $e');
      return 'No Expiry';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Space at the top of the page
            SizedBox(height: 30),
            // Categories Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Space between header and category buttons
            SizedBox(height: 20),
            // Horizontal scrollable list of category buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Meat category button
                  CategoryButton(
                      icon: Icons.fastfood,
                      label: 'Meat',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Meat'),
                          ),
                        );
                      }),
                  // Drinks category button
                  CategoryButton(
                      icon: Icons.local_bar,
                      label: 'Drinks',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Drinks'),
                          ),
                        );
                      }),
                  // Salads category button
                  CategoryButton(
                      icon: Icons.grass,
                      label: 'Salads',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Salads'),
                          ),
                        );
                      }),
                  // Sweets category button
                  CategoryButton(
                      icon: Icons.cake,
                      label: 'Sweets',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Sweets'),
                          ),
                        );
                      }),
                  // Plates category button
                  CategoryButton(
                      icon: Icons.dinner_dining,
                      label: 'Plates',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Plates'),
                          ),
                        );
                      }),
                  // Sandwiches category button
                  CategoryButton(
                      icon: Icons.fastfood,
                      label: 'Sandwiches',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryInfoPage(categoryName: 'Sandwiches'),
                          ),
                        );
                      }),
                ],
              ),
            ),
            // Space between categories and recommended section
            SizedBox(height: 30),
            // Recommended Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended section header
                  Text(
                    'Recommended for You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Stream builder for recommended items
                  _buildRecommendedItemsStreamBuilder(),
                ],
              ),
            ),
            // Space between recommended and daily deals sections
            SizedBox(height: 30),
            // Daily Deals Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily deals header
                  Text(
                    'Daily Deals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Stream builder for daily deals items
                  _buildFeaturedItemsStreamBuilder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Build a card widget for a featured (daily deal) item
  Widget _buildFeatureItemCard(DocumentSnapshot menuItemDoc) {
    // Get the reference to the parent restaurant document
    DocumentReference restaurantRef = menuItemDoc.reference.parent.parent!;
    // Use FutureBuilder to get restaurant data asynchronously
    return FutureBuilder<DocumentSnapshot>(
      future: restaurantRef.get(),
      builder: (context, restaurantSnapshot) {
        // Show loading indicator while waiting for restaurant data
        if (!restaurantSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // Extract menu item data
        var menuItem = menuItemDoc.data() as Map<String, dynamic>;
        var restaurantId = restaurantRef.id;
        // Return a FeatureItemCard with all necessary data
        return FeatureItemCard(
          title: menuItem['name'] ?? '',
          description: '${menuItem['dealQuantity']?.toString() ?? ''} pieces',
          price: menuItem['price']?.toDouble() ?? 0.0,
          imageUrl: menuItem['imageUrl'] ?? '',
          discountPrice: menuItem['originalPrice']?.toString() ?? '0',
          restaurantId: restaurantId,
          itemId: menuItemDoc.id,
          foodItem: {
            'id': menuItemDoc.id,
            'name': menuItem['name'],
            'description': menuItem['description'],
            'price': menuItem['price'],
            'imageUrl': menuItem['imageUrl'],
            'originalPrice': menuItem['originalPrice'],
            'materials': menuItem['materials'],
            'instructions': menuItem['instructions'],
            "quantity": menuItem['quantity'],
            'dealQuantity': menuItem['dealQuantity'],
          },
        );
      },
    );
  }
  // Build a StreamBuilder for featured (daily deal) items
  StreamBuilder<QuerySnapshot> _buildFeaturedItemsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      // Query for all menu items marked as "Daily Deals"
      stream: _firestore
          .collectionGroup('menu_items')
          .where('type', isEqualTo: 'Daily Deals')
          .snapshots(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Show message if no daily deals are available
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Daily Deals available'));
        }
        // Build a list of feature item cards
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildFeatureItemCard(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }
  // Build a StreamBuilder for recommended items
  Widget _buildRecommendedItemsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      // Query for all menu items
      stream: _firestore.collectionGroup('menu_items').snapshots(),
      builder: (context, snapshot) {
        // Handle errors
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // Show loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Show message if no items are available
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items available'));
        }
        // Sort items by dealQuantity (descending) and price (ascending)
        final sortedDocs = snapshot.data!.docs.toList()
          ..sort((a, b) {
            final aDealQuantity =
                (a.data() as Map<String, dynamic>)['dealQuantity'] ?? 0;
            final bDealQuantity =
                (b.data() as Map<String, dynamic>)['dealQuantity'] ?? 0;
            final aPrice = (a.data() as Map<String, dynamic>)['price'] ?? 0.0;
            final bPrice = (b.data() as Map<String, dynamic>)['price'] ?? 0.0;
            // First compare by dealQuantity (descending)
            final quantityCompare = bDealQuantity.compareTo(aDealQuantity);
            if (quantityCompare != 0) return quantityCompare;
            // If dealQuantity is equal, compare by price (ascending)
            return aPrice.compareTo(bPrice);
          });
        // Take only the top 3 items
        final topItems = sortedDocs.take(3).toList();
        // Build a horizontal list of recommended item cards
        return Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topItems.length,
            itemBuilder: (context, index) {
              return _buildRecommendedItemCard(topItems[index]);
            },
          ),
        );
      },
    );
  }
  // Build a card widget for a recommended item
  Widget _buildRecommendedItemCard(DocumentSnapshot doc) {
    // Get the reference to the parent restaurant document
    DocumentReference restaurantRef = doc.reference.parent.parent!;
    // Use FutureBuilder to get restaurant data asynchronously
    return FutureBuilder<DocumentSnapshot>(
      future: restaurantRef.get(),
      builder: (context, restaurantSnapshot) {
        // Show loading indicator while waiting for restaurant data
        if (!restaurantSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // Extract menu item data
        var menuItem = doc.data() as Map<String, dynamic>;
        var restaurantId = restaurantRef.id;
        // Return a RecommendedItemCard with all necessary data
        return RecommendedItemCard(
          imageUrl: menuItem['imageUrl'] ?? '',
          title: menuItem['name'] ?? '',
          description: menuItem['description'] ?? '',
          price: (menuItem['price'] ?? 0).toDouble(),
          originalPrice: (menuItem['originalPrice'] ?? 0).toDouble(),
          dealQuantity: menuItem['dealQuantity'] ?? 0,
          foodItem: {
            'id': doc.id,
            'name': menuItem['name'],
            'description': menuItem['description'],
            'price': menuItem['price'],
            'imageUrl': menuItem['imageUrl'],
            'originalPrice': menuItem['originalPrice'],
            'materials': menuItem['materials'],
            'instructions': menuItem['instructions'],
            'quantity': menuItem['quantity'],
            'dealQuantity': menuItem['dealQuantity'],
          },
          restaurantId: restaurantId,
        );
      },
    );
  }
}
// Custom widget for category buttons
class CategoryButton extends StatelessWidget {
  final IconData icon; // Icon to display
  final String label; // Text label
  final VoidCallback onPressed; // Callback when pressed
  const CategoryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 100,
          height: 70,
          decoration: BoxDecoration(
            color: _getColorForCategory(label), // Get color based on category
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category icon
              Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              // Category label
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Helper method to get a color based on category name
  Color _getColorForCategory(String label) {
    switch (label) {
      case 'Meat':
        return Colors.deepOrange[400]!;
      case 'Drinks':
        return Colors.green[600]!;
      case 'Salads':
        return Colors.teal[400]!;
      case 'Sweets':
        return Colors.purple[400]!;
      case 'Plates':
        return Colors.blue[600]!;
      case 'Sandwiches':
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
// Custom widget for featured (daily deal) items
class FeatureItemCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String discountPrice;
  final String imageUrl;
  final String restaurantId;
  final String itemId;
  final Map<String, dynamic> foodItem; // Complete food item data
  FeatureItemCard({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.discountPrice,
    required this.restaurantId,
    required this.itemId,
    required this.foodItem,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigate to food info page when tapped
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodInfoPage(
              foodItem: foodItem,
              restaurantId: restaurantId,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.none,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          // Food item image
          leading: Image.network(
            imageUrl,
            width: 100,
            height: 100,
          ),
          // Food item title
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food item description
              Text(description),
              SizedBox(height: 5),
              Row(
                children: [
                  // Current price
                  Text(
                    '\$$price',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 40),
                  // Original price (with strikethrough)
                  Text(
                    '\$$discountPrice',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Custom widget for recommended items
class RecommendedItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final Map<String, dynamic> foodItem; // Complete food item data
  final String restaurantId;
  final int dealQuantity;
  const RecommendedItemCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.foodItem,
    required this.restaurantId,
    required this.dealQuantity,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigate to food info page when tapped
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodInfoPage(
              foodItem: foodItem,
              restaurantId: restaurantId,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            // Main card content
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food image with loading and error handling
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  // Food details
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Food title
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        // Deal quantity if available
                        if (dealQuantity > 0)
                          Text(
                            '$dealQuantity pieces',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        SizedBox(height: 8),
                        // Price information
                        Row(
                          children: [
                            // Current price
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            // Original price if different
                            if (originalPrice > 0)
                              Text(
                                '\$${originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // "Recommended" badge
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recommended',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}