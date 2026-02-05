import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'ev_dashboard_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'fast_charging_page.dart';
import 'parking_service_page.dart';
import 'car_wash_page.dart';
import 'mechanic_support_page.dart';
import 'drinking_water.dart';
import 'payment_gateway_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color color = Colors.black, // Added color parameter with default value
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color, // Using the color parameter
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color, // Using the color parameter
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildServiceCard(
              context: context,
              icon: Icons.ev_station,
              title: "Charging Port 1",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChargingPortDetailsPage(
                    portName: "Charging Port 1",
                    voltage: "240V",
                    selfService: true,
                  ),
                ),
              ),
            ),
            _buildServiceCard(
              context: context,
              icon: Icons.ev_station,
              title: "Charging Port 2",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChargingPortDetailsPage(
                    portName: "Charging Port 2",
                    voltage: "480V",
                    selfService: false,
                  ),
                ),
              ),
            ),
            _buildServiceCard(
              context: context,
              icon: Icons.bolt,
              title: "Fast Charging",
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FastChargingPage()),
              ),
            ),
            _buildServiceCard(
              context: context,
              icon: Icons.local_parking,
              title: "Parking Service",
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ParkingServicePage()),
              ),
            ),
            _buildServiceCard(
              context: context,
              icon: Icons.cleaning_services,
              title: "Car Wash",
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarWashPage()),
              ),
            ),
            _buildServiceCard(
              context: context,
              icon: Icons.location_on,
              title: "Location",
              onTap: () async {
                // Show loading spinner
                showDialog(
                  context: context,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                // Fetch charging stations
                try {
                  const String apiUrl =
                      "http://127.0.0.1:5000/charging-stations";
                  final response = await http.get(Uri.parse(apiUrl));
                  if (response.statusCode == 200) {
                    final List<dynamic> data = jsonDecode(response.body);
                    List<Map<String, dynamic>> chargingStations =
                        data.map((station) {
                      return {
                        'name': station['station_name'],
                        'location': LatLng(
                          station['latitude'],
                          station['longitude'],
                        ),
                      };
                    }).toList();

                    Navigator.pop(context); // Close the loading spinner
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationDetailsPage(
                            chargingStations: chargingStations),
                      ),
                    );
                  } else {
                    throw Exception(
                        "Failed to fetch stations. Status: ${response.statusCode}");
                  }
                } catch (e) {
                  Navigator.pop(context); // Close the loading spinner
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
            ),
            // _buildServiceCard(
            //   context: context,
            //   icon: Icons.build,
            //   title: "Beverage And Store",
            //   color: Colors.red,
            //   onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const BeverageAndStorePage()),
            //   ),
            // ),
            _buildServiceCard(
              context: context,
              icon: Icons.build,
              title: "Mechanic Support",
              color: Colors.deepPurpleAccent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MechanicSupportPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _fetchChargingStations() async {
  const String apiUrl = "http://127.0.0.1:5000/charging-stations";
  try {
    print("Fetching charging stations...");
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Fetched stations: $data");
      return data.map((station) {
        return {
          'name': station['station_name'],
          'location': LatLng(
            station['latitude'],
            station['longitude'],
          ),
        };
      }).toList();
    } else {
      throw Exception(
          "Failed to load stations. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching charging stations: $e");
    throw e;
  }
}

class ChargingPortDetailsPage extends StatefulWidget {
  final String portName;
  final String voltage;
  final bool selfService;

  const ChargingPortDetailsPage({
    super.key,
    required this.portName,
    required this.voltage,
    required this.selfService,
  });

  @override
  State<ChargingPortDetailsPage> createState() =>
      _ChargingPortDetailsPageState();
}

class _ChargingPortDetailsPageState extends State<ChargingPortDetailsPage> {
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
        title: Text(widget.portName),
      ),
      body: SingleChildScrollView(
        // Wrap the body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details for ${widget.portName}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Dropdown for EV Ports
              Text(
                "Select EV Port",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedPort,
                items: evPorts.map((port) {
                  return DropdownMenuItem(
                    value: port,
                    child: Text(port),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPort = newValue;
                  });
                },
              ),

              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.bolt,
                label: "Voltage",
                value: widget.voltage,
              ),
              _buildDetailRow(
                icon: Icons.build,
                label: "Self Service Required",
                value: widget.selfService ? 'Yes' : 'No',
              ),

              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () => _showBookingPopup(context),
                  child: const Text("Book Your Slot Now"),
                ),
              ),

              const SizedBox(height: 32),

              // 24/7 Open & Total Charges Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.access_time,
                      label: "Open 24/7",
                      value: "Yes",
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.payment,
                      label: "Total Charges",
                      value: "1568",
                      color: Colors.blue,
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

  void _showBookingPopup(BuildContext context) {
    List<String> timeSlots = List.generate(11, (index) {
      return "${8 + index}:00 ${8 + index < 12 ? 'AM' : 'PM'}";
    });

    String? selectedTimeSlot;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Book Slot"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Selected Date: ${DateFormat.yMMMMd().format(selectedDate)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text("Select Time Slot:",
                      style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: selectedTimeSlot,
                    isExpanded: true,
                    hint: const Text("Select Time"),
                    items: timeSlots.map((slot) {
                      return DropdownMenuItem(
                        value: slot,
                        child: Text(slot),
                      );
                    }).toList(),
                    onChanged: (newSlot) {
                      setState(() {
                        selectedTimeSlot = newSlot;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedTimeSlot == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          _showPaymentModePopup(context);
                        },
                  child: const Text("Book Now"),
                ),
              ],
            );
          },
        );
      },
    );
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
                Navigator.pop(context); // Close the dialog
                _showConfirmationPopup(context, isOffline: true);
              },
              child: const Text("Offline"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentGatewayPage()),
                );
              },
              child: const Text("Online"),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationPopup(BuildContext context, {required bool isOffline}) {
    String message = isOffline
        ? "Your slot has been booked successfully. Please pay at the station."
        : "Your payment was successful. Slot booked!";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Confirmed"),
          content: Text(message),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            "$label: $value",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LocationDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> chargingStations;

  const LocationDetailsPage({super.key, required this.chargingStations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pass chargingStations to MapScreen
          Positioned.fill(
            child: MapScreen(chargingStations: chargingStations),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
