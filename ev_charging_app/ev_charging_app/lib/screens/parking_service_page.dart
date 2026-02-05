import 'package:flutter/material.dart';
import 'payment_gateway_page.dart'; // Import the Payment Gateway Page

class ParkingServicePage extends StatefulWidget {
  const ParkingServicePage({super.key});

  @override
  State<ParkingServicePage> createState() => _ParkingServicePageState();
}

class _ParkingServicePageState extends State<ParkingServicePage> {
  final List<String> evPorts = [
    "Salem EV Port",
    "Madurai EV Port",
    "Coimbatore EV Hub",
    "Tiruppur Charging Point",
    "Nagercoil Green Charge"
  ];

  String? selectedPort;

  @override
  void initState() {
    super.initState();
    selectedPort = evPorts[0]; // Default selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parking Services"),
        backgroundColor: Colors.blue,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Help & Support'),
                  content: const Text(
                      'For assistance, please call:\n+1 (555) 123-4567\n\nOr email us at:\nsupport@smartparking.com'),
                  actions: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
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
              // EV Station Dropdown
              const Text(
                'Select EV Station',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPort,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPort = newValue!;
                  });
                },
                items: evPorts.map((port) {
                  return DropdownMenuItem(
                    value: port,
                    child: Text(port),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Welcome Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to $selectedPort',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find the perfect parking spot with real-time availability and convenient payment options.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Available Spaces Section
              const Text(
                'Available Spaces',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSpaceInfo('Ground Floor', '15/50', Colors.green),
                  _buildSpaceInfo('Level 1', '28/45', Colors.orange),
                  _buildSpaceInfo('Level 2', '40/40', Colors.red),
                ],
              ),
              const SizedBox(height: 20),

              // Parking Rates Section
              const Text(
                'Parking Rates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildRateCard(),
              const SizedBox(height: 20),

              // Features Section
              const Text(
                'Features & Amenities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildFeaturesList(),
              const SizedBox(height: 20),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentModePopup(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show popup to select payment mode
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
                _showBookingConfirmation(context, isOffline: true);
              },
              child: const Text("Offline"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentGatewayPage()),
                ).then((_) {
                  // Show confirmation after returning from the payment page
                  _showBookingConfirmation(context, isOffline: false);
                });
              },
              child: const Text("Online"),
            ),
          ],
        );
      },
    );
  }

  /// Show booking confirmation
  void _showBookingConfirmation(BuildContext context,
      {required bool isOffline}) {
    String paymentMethod = isOffline ? "Offline" : "Online";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Confirmed"),
          content: Text(
            "Your parking slot at $selectedPort has been successfully booked!\n\nPayment Method: $paymentMethod",
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

  Widget _buildSpaceInfo(String level, String availability, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              level,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              availability,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            _RateRow(duration: 'First Hour', rate: '\$2.00'),
            _RateRow(duration: 'Additional Hours', rate: '\$1.50/hour'),
            _RateRow(duration: 'Daily Maximum', rate: '\$15.00'),
            _RateRow(duration: 'Lost Ticket', rate: '\$20.00'),
            _RateRow(duration: 'Monthly Pass', rate: '\$150.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            _FeatureItem(
              icon: Icons.security,
              title: '24/7 Security',
              description:
                  'Round-the-clock surveillance and security personnel',
            ),
            _FeatureItem(
              icon: Icons.electric_car,
              title: 'EV Charging',
              description: 'Electric vehicle charging stations available',
            ),
            _FeatureItem(
              icon: Icons.wheelchair_pickup,
              title: 'Accessible Parking',
              description: 'Dedicated spaces for disabled visitors',
            ),
            _FeatureItem(
              icon: Icons.payment,
              title: 'Multiple Payment Options',
              description: 'Accept cash, credit cards, and mobile payments',
            ),
          ],
        ),
      ),
    );
  }
}

class _RateRow extends StatelessWidget {
  final String duration;
  final String rate;

  const _RateRow({
    required this.duration,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(duration),
          Text(
            rate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
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
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'payment_gateway_page.dart';

// class ParkingServicePage extends StatefulWidget {
//   const ParkingServicePage({super.key});

//   @override
//   State<ParkingServicePage> createState() => _ParkingServicePageState();
// }

// class _ParkingServicePageState extends State<ParkingServicePage> {
//   final List<String> evPorts = [
//     "Salem EV Port",
//     "Madurai EV Port",
//     "Coimbatore EV Hub",
//     "Tiruppur Charging Point",
//     "Nagercoil Green Charge"
//   ];

//   String? selectedPort;

//   @override
//   void initState() {
//     super.initState();
//     selectedPort = evPorts[0]; // Default selection
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Smart Parking Services"),
//         backgroundColor: Colors.blue,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.help_outline),
//             onPressed: () {
//               // Show help dialog
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Help & Support'),
//                   content: const Text(
//                       'For assistance, please call:\n+1 (555) 123-4567\n\nOr email us at:\nsupport@smartparking.com'),
//                   actions: [
//                     TextButton(
//                       child: const Text('Close'),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // EV Station Dropdown
//               const Text(
//                 'Select EV Station',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               DropdownButton<String>(
//                 value: selectedPort,
//                 isExpanded: true,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedPort = newValue!;
//                   });
//                 },
//                 items: evPorts.map((port) {
//                   return DropdownMenuItem(
//                     value: port,
//                     child: Text(port),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // Welcome Card
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Welcome to $selectedPort',
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Find the perfect parking spot with real-time availability and convenient payment options.',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Available Spaces Section
//               const Text(
//                 'Available Spaces',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildSpaceInfo('Ground Floor', '15/50', Colors.green),
//                   _buildSpaceInfo('Level 1', '28/45', Colors.orange),
//                   _buildSpaceInfo('Level 2', '40/40', Colors.red),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Parking Rates Section
//               const Text(
//                 'Parking Rates',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               _buildRateCard(),
//               const SizedBox(height: 20),

//               // Features Section
//               const Text(
//                 'Features & Amenities',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               _buildFeaturesList(),
//               const SizedBox(height: 20),

//               // Book Now Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add booking functionality
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Booking feature coming soon!'),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     backgroundColor: Colors.blue,
//                   ),
//                   child: const Text(
//                     'Book Now',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSpaceInfo(String level, String availability, Color color) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               level,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               availability,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRateCard() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: const [
//             _RateRow(duration: 'First Hour', rate: '\$2.00'),
//             _RateRow(duration: 'Additional Hours', rate: '\$1.50/hour'),
//             _RateRow(duration: 'Daily Maximum', rate: '\$15.00'),
//             _RateRow(duration: 'Lost Ticket', rate: '\$20.00'),
//             _RateRow(duration: 'Monthly Pass', rate: '\$150.00'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturesList() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: const [
//             _FeatureItem(
//               icon: Icons.security,
//               title: '24/7 Security',
//               description:
//                   'Round-the-clock surveillance and security personnel',
//             ),
//             _FeatureItem(
//               icon: Icons.electric_car,
//               title: 'EV Charging',
//               description: 'Electric vehicle charging stations available',
//             ),
//             _FeatureItem(
//               icon: Icons.wheelchair_pickup,
//               title: 'Accessible Parking',
//               description: 'Dedicated spaces for disabled visitors',
//             ),
//             _FeatureItem(
//               icon: Icons.payment,
//               title: 'Multiple Payment Options',
//               description: 'Accept cash, credit cards, and mobile payments',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _RateRow extends StatelessWidget {
//   final String duration;
//   final String rate;

//   const _RateRow({
//     required this.duration,
//     required this.rate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(duration),
//           Text(
//             rate,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FeatureItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const _FeatureItem({
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   description,
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
