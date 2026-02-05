import 'package:flutter/material.dart';

class BeverageAndStorePage extends StatelessWidget {
  const BeverageAndStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refreshments & Convenience Store"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Status Card
              _buildStatusCard(),
              const SizedBox(height: 20),

              // Water Station Section
              _buildSectionTitle('Water Station Services'),
              _buildWaterServices(),
              const SizedBox(height: 20),

              // Beverage Section
              _buildSectionTitle('Available Beverages'),
              _buildBeverageGrid(),
              const SizedBox(height: 20),

              // Store Section
              _buildSectionTitle('Convenience Store'),
              _buildStoreCategories(),
              const SizedBox(height: 20),

              // Special Offers
              _buildSpecialOffers(),
              const SizedBox(height: 20),

              // Operating Hours
              _buildOperatingHours(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add order functionality
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Place Order'),
              content: const Text('Online ordering coming soon!\n\nCall us: (555) 123-4567'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
        label: const Text('Place Order'),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade100],
          ),
        ),
        child: Column(
          children: const [
            Text(
              'Welcome to QuickStop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your one-stop shop for refreshments and daily essentials',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildWaterServices() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceItem(
              'Water Refilling',
              'Clean and purified drinking water',
              '₱25/5 gallons',
            ),
            _buildServiceItem(
              'Mineral Water',
              'Various brands and sizes available',
              'From ₱15',
            ),
            _buildServiceItem(
              'Alkaline Water',
              'Premium alkaline water options',
              'From ₱35',
            ),
            const SizedBox(height: 10),
            const Text(
              '* All our water undergoes 8-stage filtration process',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String title, String description, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeverageGrid() {
    final beverages = [
      {'name': 'Soft Drinks', 'price': 'From ₱25'},
      {'name': 'Fresh Juices', 'price': 'From ₱45'},
      {'name': 'Energy Drinks', 'price': 'From ₱65'},
      {'name': 'Coffee/Tea', 'price': 'From ₱35'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemCount: beverages.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  beverages[index]['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  beverages[index]['price']!,
                  style: const TextStyle(color: Colors.teal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoreCategories() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoryItem(
              Icons.breakfast_dining,
              'Snacks & Candies',
              'Chips, chocolates, biscuits, and more',
            ),
            _buildCategoryItem(
              Icons.cleaning_services,
              'Personal Care',
              'Toiletries, hygiene products',
            ),
            _buildCategoryItem(
              Icons.receipt_long,
              'Groceries',
              'Basic household items and supplies',
            ),
            _buildCategoryItem(
              Icons.medical_services,
              'Medicine Cabinet',
              'Over-the-counter medicines',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Special Offers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Text('• 10% off on water refill every Monday'),
            Text('• Buy 1 Get 1 on selected beverages (2-4 PM daily)'),
            Text('• Loyalty points on store purchases'),
            Text('• Senior citizen and PWD discounts available'),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatingHours() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Operating Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Monday - Saturday: 7:00 AM - 9:00 PM'),
            Text('Sunday: 8:00 AM - 8:00 PM'),
            SizedBox(height: 8),
            Text(
              'Water refilling services available during store hours',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}