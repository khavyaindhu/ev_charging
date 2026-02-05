import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CarWashService {
  final String name;
  final String description;
  final String price;
  final IconData icon;

  CarWashService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

class CarWashPage extends StatefulWidget {
  const CarWashPage({super.key});

  @override
  State<CarWashPage> createState() => _CarWashPageState();
}

class _CarWashPageState extends State<CarWashPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<CarWashService> services = [
    CarWashService(
      name: 'Basic Wash',
      description: 'Exterior wash, tire cleaning, and basic drying',
      price: '₹299',
      icon: Icons.local_car_wash,
    ),
    CarWashService(
      name: 'Premium Wash',
      description: 'Basic wash + waxing, interior vacuum, dashboard cleaning',
      price: '₹499',
      icon: Icons.car_repair,
    ),
    CarWashService(
      name: 'Deluxe Package',
      description: 'Premium wash + interior detailing, ceramic coating',
      price: '₹999',
      icon: Icons.auto_awesome,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Wash Services"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green.shade700, Colors.green.shade400],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Professional Car Wash",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 4 * _controller.value),
                              child: const Text(
                                "Keep Your Car Sparkling Clean",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Services Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Our Services",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...services
                      .map((service) => _buildServiceCard(service))
                      .toList(),
                ],
              ),
            ),

            // Contact Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Book Your Wash",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfo(
                    icon: Icons.phone,
                    title: "Call Us",
                    subtitle: "+91 98765 43210",
                  ),
                  _buildContactInfo(
                    icon: Icons.access_time,
                    title: "Working Hours",
                    subtitle: "9:00 AM - 6:00 PM",
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add booking functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Booking feature coming soon!"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(CarWashService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          service.icon,
          size: 40,
          color: Colors.green,
        ),
        title: Text(
          service.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(service.description),
            const SizedBox(height: 8),
            Text(
              service.price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
