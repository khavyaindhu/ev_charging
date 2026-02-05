import 'dart:math';
import 'package:flutter/material.dart';
import 'payment_gateway_page.dart'; // Import the Payment Gateway Page

class ChargingService {
  final String name;
  final String power;
  final String duration;
  final String price;
  final IconData icon;
  final String description;

  ChargingService({
    required this.name,
    required this.power,
    required this.duration,
    required this.price,
    required this.icon,
    required this.description,
  });
}

class FastChargingPage extends StatefulWidget {
  const FastChargingPage({super.key});

  @override
  State<FastChargingPage> createState() => _FastChargingPageState();
}

class _FastChargingPageState extends State<FastChargingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _chargeAnimation;

  final List<ChargingService> services = [
    ChargingService(
      name: 'Super Fast DC',
      power: '150 kW',
      duration: '15-30 min',
      price: '₹18/unit',
      icon: Icons.flash_on,
      description: 'Best for long-distance travel, 0-80% in 30 minutes',
    ),
    ChargingService(
      name: 'Fast AC',
      power: '22 kW',
      duration: '2-3 hours',
      price: '₹12/unit',
      icon: Icons.battery_charging_full,
      description: 'Ideal for overnight charging or longer stays',
    ),
    ChargingService(
      name: 'Ultra Fast DC',
      power: '350 kW',
      duration: '10-20 min',
      price: '₹22/unit',
      icon: Icons.electric_bolt,
      description: 'Premium charging solution, 0-80% in just 15 minutes',
    ),
  ];

  final List<String> chargingStations = [
    "Salem EV Port",
    "Madurai EV Port",
    "Coimbatore EV Hub",
    "Tiruppur Charging Point",
    "Nagercoil Green Charge",
  ];

  String? selectedStation;
  String currentWaitTime = "--";

  @override
  void initState() {
    super.initState();
    selectedStation = chargingStations[0]; // Default station

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _chargeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateWaitTime() {
    // Generate a random wait time between 5 and 30 minutes
    final random = Random();
    final waitTime = random.nextInt(26) + 5; // Random value between 5 and 30
    setState(() {
      currentWaitTime = "$waitTime minutes";
    });
  }

  void _showPaymentModePopup(BuildContext context) {
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
                _showConfirmationPopup(context, isOffline: true);
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
                  _showConfirmationPopup(context, isOffline: false);
                });
              },
              child: const Text("Online"),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationPopup(BuildContext context, {required bool isOffline}) {
    String paymentMethod = isOffline ? "Offline" : "Online";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Charging Confirmed"),
          content: Text(
            "Your charging session at $selectedStation has been successfully booked!\n\nPayment Method: $paymentMethod",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fast Charging"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange.shade700, Colors.orange.shade400],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _chargeAnimation,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bolt,
                                  color: Colors.white,
                                  size: 40 + (10 * _chargeAnimation.value),
                                ),
                                const Text(
                                  "Quick Charge",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Get Back on Road Quickly",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown for Charging Stations
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButton<String>(
                value: selectedStation,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStation = newValue!;
                    currentWaitTime = "--"; // Reset wait time
                    _updateWaitTime(); // Update wait time dynamically
                  });
                },
                items: chargingStations.map((station) {
                  return DropdownMenuItem(
                    value: station,
                    child: Text(station),
                  );
                }).toList(),
              ),
            ),

            // Status Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  _buildStatusIndicator(
                    "Chargers Available",
                    "4/6 Available",
                    Icons.ev_station,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildStatusIndicator(
                    "Current Wait Time",
                    currentWaitTime,
                    Icons.timer,
                    Colors.blue,
                  ),
                ],
              ),
            ),

            // Services Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Charging Options",
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

            // Call to Action
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentModePopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power),
                    SizedBox(width: 8),
                    Text(
                      "Start Charging",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
      String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(ChargingService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(service.icon, color: Colors.orange, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      service.power,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(service.description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "⚡ ${service.duration}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  service.price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';

// class ChargingService {
//   final String name;
//   final String power;
//   final String duration;
//   final String price;
//   final IconData icon;
//   final String description;

//   ChargingService({
//     required this.name,
//     required this.power,
//     required this.duration,
//     required this.price,
//     required this.icon,
//     required this.description,
//   });
// }

// class FastChargingPage extends StatefulWidget {
//   const FastChargingPage({super.key});

//   @override
//   State<FastChargingPage> createState() => _FastChargingPageState();
// }

// class _FastChargingPageState extends State<FastChargingPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _chargeAnimation;

//   final List<ChargingService> services = [
//     ChargingService(
//       name: 'Super Fast DC',
//       power: '150 kW',
//       duration: '15-30 min',
//       price: '₹18/unit',
//       icon: Icons.flash_on,
//       description: 'Best for long-distance travel, 0-80% in 30 minutes',
//     ),
//     ChargingService(
//       name: 'Fast AC',
//       power: '22 kW',
//       duration: '2-3 hours',
//       price: '₹12/unit',
//       icon: Icons.battery_charging_full,
//       description: 'Ideal for overnight charging or longer stays',
//     ),
//     ChargingService(
//       name: 'Ultra Fast DC',
//       power: '350 kW',
//       duration: '10-20 min',
//       price: '₹22/unit',
//       icon: Icons.electric_bolt,
//       description: 'Premium charging solution, 0-80% in just 15 minutes',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();

//     _chargeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Fast Charging"),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Hero Section
//             Container(
//               height: 220,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.orange.shade700, Colors.orange.shade400],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AnimatedBuilder(
//                           animation: _chargeAnimation,
//                           builder: (context, child) {
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.bolt,
//                                   color: Colors.white,
//                                   size: 40 + (10 * _chargeAnimation.value),
//                                 ),
//                                 const Text(
//                                   "Quick Charge",
//                                   style: TextStyle(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           "Get Back on Road Quickly",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Status Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.grey[100],
//               child: Column(
//                 children: [
//                   _buildStatusIndicator(
//                     "Chargers Available",
//                     "4/6 Available",
//                     Icons.ev_station,
//                     Colors.green,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildStatusIndicator(
//                     "Current Wait Time",
//                     "~5 minutes",
//                     Icons.timer,
//                     Colors.blue,
//                   ),
//                 ],
//               ),
//             ),

//             // Services Section
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Charging Options",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ...services
//                       .map((service) => _buildServiceCard(service))
//                       .toList(),
//                 ],
//               ),
//             ),

//             // Information Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.grey[100],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "How to Charge",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildStepCard(
//                     "1. Park & Connect",
//                     "Park your vehicle and connect the charging cable",
//                     Icons.local_parking,
//                   ),
//                   _buildStepCard(
//                     "2. Select & Pay",
//                     "Choose your charging option and complete payment",
//                     Icons.payment,
//                   ),
//                   _buildStepCard(
//                     "3. Monitor",
//                     "Track charging progress on your phone or display",
//                     Icons.phone_android,
//                   ),
//                   _buildStepCard(
//                     "4. Disconnect",
//                     "Once complete, safely disconnect and drive away",
//                     Icons.electric_car,
//                   ),
//                 ],
//               ),
//             ),

//             // Call to Action
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add start charging functionality
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Starting charging session..."),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                         horizontal: 32,
//                       ),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.power),
//                         SizedBox(width: 8),
//                         Text(
//                           "Start Charging",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   OutlinedButton(
//                     onPressed: () {
//                       // Add support functionality
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Connecting to support..."),
//                         ),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                         horizontal: 32,
//                       ),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.support_agent),
//                         SizedBox(width: 8),
//                         Text(
//                           "Need Help?",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusIndicator(
//       String title, String value, IconData icon, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 16),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildServiceCard(ChargingService service) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(service.icon, color: Colors.orange, size: 32),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       service.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       service.power,
//                       style: const TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(service.description),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "⚡ ${service.duration}",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   service.price,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepCard(String title, String description, IconData icon) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.orange),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(description),
//       ),
//     );
//   }
// }
