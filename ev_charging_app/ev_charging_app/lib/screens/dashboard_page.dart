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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final vehicleType = args?['vehicleType'] ?? 'car';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[50]!,
              Colors.teal[50]!,
              Colors.blue[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, vehicleType),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Services',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildServiceGrid(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String vehicleType) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.teal[600]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back! ⚡',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your ${vehicleType == 'car' ? 'Car' : 'Two Wheeler'} Dashboard',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  vehicleType == 'car' ? Icons.directions_car : Icons.two_wheeler,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildModernServiceCard(
          context: context,
          icon: Icons.ev_station,
          title: "Charging\nPort 1",
          description: "240V Fast Charge",
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[600]!],
          ),
          iconBackground: Colors.blue[100]!,
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
        _buildModernServiceCard(
          context: context,
          icon: Icons.ev_station,
          title: "Charging\nPort 2",
          description: "480V Super Fast",
          gradient: LinearGradient(
            colors: [Colors.purple[400]!, Colors.purple[600]!],
          ),
          iconBackground: Colors.purple[100]!,
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
        _buildModernServiceCard(
          context: context,
          icon: Icons.bolt,
          title: "Fast\nCharging",
          description: "Ultra Quick Charge",
          gradient: LinearGradient(
            colors: [Colors.orange[400]!, Colors.orange[600]!],
          ),
          iconBackground: Colors.orange[100]!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FastChargingPage()),
          ),
        ),
        _buildModernServiceCard(
          context: context,
          icon: Icons.local_parking,
          title: "Parking\nService",
          description: "Secure Parking",
          gradient: LinearGradient(
            colors: [Colors.indigo[400]!, Colors.indigo[600]!],
          ),
          iconBackground: Colors.indigo[100]!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParkingServicePage()),
          ),
        ),
        _buildModernServiceCard(
          context: context,
          icon: Icons.cleaning_services,
          title: "Car\nWash",
          description: "Premium Cleaning",
          gradient: LinearGradient(
            colors: [Colors.teal[400]!, Colors.teal[600]!],
          ),
          iconBackground: Colors.teal[100]!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarWashPage()),
          ),
        ),
        _buildModernServiceCard(
          context: context,
          icon: Icons.location_on,
          title: "Find\nStations",
          description: "Nearby Locations",
          gradient: LinearGradient(
            colors: [Colors.red[400]!, Colors.red[600]!],
          ),
          iconBackground: Colors.red[100]!,
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );

            try {
              const String apiUrl = "http://127.0.0.1:5000/charging-stations";
              final response = await http.get(Uri.parse(apiUrl));
              if (response.statusCode == 200) {
                final List<dynamic> data = jsonDecode(response.body);
                List<Map<String, dynamic>> chargingStations = data.map((station) {
                  return {
                    'name': station['station_name'],
                    'location': LatLng(
                      station['latitude'],
                      station['longitude'],
                    ),
                  };
                }).toList();

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationDetailsPage(
                      chargingStations: chargingStations,
                    ),
                  ),
                );
              } else {
                throw Exception("Failed to fetch stations");
              }
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        _buildModernServiceCard(
          context: context,
          icon: Icons.build_circle,
          title: "Mechanic\nSupport",
          description: "24/7 Assistance",
          gradient: LinearGradient(
            colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
          ),
          iconBackground: Colors.deepPurple[100]!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MechanicSupportPage()),
          ),
        ),
        _buildModernServiceCard(
          context: context,
          icon: Icons.local_drink,
          title: "Refreshments",
          description: "Drinks & Snacks",
          gradient: LinearGradient(
            colors: [Colors.pink[400]!, Colors.pink[600]!],
          ),
          iconBackground: Colors.pink[100]!,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BeverageAndStorePage()),
          ),
        ),
      ],
    );
  }

  Widget _buildModernServiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
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
                    child: Icon(
                      icon,
                      size: 36,
                      color: gradient.colors.first,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    selectedPort = evPorts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.portName),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details for ${widget.portName}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Select EV Port",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Book Your Slot Now",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
                  const Text("Select Time Slot:", style: TextStyle(fontSize: 16)),
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
                Navigator.pop(context);
                _showConfirmationPopup(context, isOffline: true);
              },
              child: const Text("Offline"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentGatewayPage()),
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