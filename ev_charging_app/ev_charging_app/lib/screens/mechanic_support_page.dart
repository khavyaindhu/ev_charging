import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'payment_gateway_page.dart'; // Import the Payment Gateway Page

class MechanicService {
  final String name;
  final String description;
  final String price;
  final String duration;
  final IconData icon;

  MechanicService({
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.icon,
  });
}

class MechanicSupportPage extends StatefulWidget {
  const MechanicSupportPage({super.key});

  @override
  State<MechanicSupportPage> createState() => _MechanicSupportPageState();
}

class _MechanicSupportPageState extends State<MechanicSupportPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wrenchAnimation;

  // List of EV Stations
  final List<String> evStations = [
    "Salem EV Station",
    "Madurai Charge Hub",
    "Coimbatore EV Power",
    "Tiruppur Charging Point",
    "Nagercoil Green Charge"
  ];

  String? selectedStation; // Stores selected EV station

  final List<MechanicService> services = [
    MechanicService(
      name: 'Basic Diagnostics',
      description:
          'Computer-based vehicle diagnostic scan and basic inspection',
      price: '₹499',
      duration: '30 mins',
      icon: Icons.build_circle,
    ),
    MechanicService(
      name: 'Battery Service',
      description: 'Battery check, charging, and replacement if needed',
      price: '₹799',
      duration: '45 mins',
      icon: Icons.battery_charging_full,
    ),
    MechanicService(
      name: 'Brake Service',
      description: 'Brake inspection, pad replacement, and system check',
      price: '₹1,499',
      duration: '1.5 hrs',
      icon: Icons.directions_car,
    ),
    MechanicService(
      name: 'Emergency Repair',
      description: '24/7 emergency mechanical support and roadside assistance',
      price: '₹2,999',
      duration: 'Varies',
      icon: Icons.emergency,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _wrenchAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    selectedStation = evStations[0]; // Default selected station
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
        title: const Text("Mechanic Support"),
        backgroundColor: Colors.red,
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
                  colors: [Colors.red.shade700, Colors.red.shade400],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _wrenchAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _wrenchAnimation.value,
                              child: const Icon(
                                Icons.build,
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Expert Mechanical Support",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Professional Service at Your Fingertips",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // EV Station Selection Dropdown
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select EV Station",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedStation,
                    items: evStations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedStation = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Services List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Our Services",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...services
                      .map((service) => _buildServiceCard(service))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(MechanicService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(service.icon, color: Colors.red, size: 30),
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text('Duration: ${service.duration}'),
        trailing: Text(
          service.price,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.description),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showPaymentModePopup(context, service.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Book Service"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentModePopup(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Payment Mode"),
          content: const Text("Would you like to pay online or offline?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
                _showConfirmationPopup(context, serviceName, isOffline: true);
              },
              child: const Text("Offline"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentGatewayPage()),
                ).then((_) {
                  // Show confirmation after returning from the payment page
                  _showConfirmationPopup(context, serviceName, isOffline: false);
                });
              },
              child: const Text("Online"),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationPopup(BuildContext context, String serviceName,
      {required bool isOffline}) {
    String paymentMethod = isOffline ? "Offline" : "Online";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Confirmed"),
          content: Text(
            "Your booking for $serviceName at $selectedStation has been successfully confirmed!\n\nPayment Method: $paymentMethod",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
