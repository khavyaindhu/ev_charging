import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  LatLng _currentCenter = LatLng(12.9715987, 77.5945627);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: _currentZoom,
              minZoom: 5.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                Navigator.pop(context, point); // Return selected location
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Positioned(
            right: 10,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () {
                    setState(() {
                      _currentZoom += 1;
                    });
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () {
                    setState(() {
                      _currentZoom -= 1;
                    });
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  LatLng? _selectedLocation;
  String? _stationName;
  final TextEditingController _stationNameController = TextEditingController();
  final List<String> _services = [
    "Charging Port 1",
    "Charging Port 2",
    "Fast Charging",
    "Parking Service",
    "Car Wash",
    "Beverage",
    "Mechanic Support",
  ];
  final List<bool> _selectedServices = List.generate(7, (index) => false);

  /// Show a dialog to add the name of the EV charging port and select services.
  void _showStationDetailsDialog(LatLng location) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Configure EV Charging Station"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _stationNameController,
                      decoration: const InputDecoration(
                        hintText: "Enter station name",
                        labelText: "Station Name",
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Select Services:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._services.asMap().entries.map((entry) {
                      int index = entry.key;
                      String service = entry.value;
                      return CheckboxListTile(
                        value: _selectedServices[index],
                        onChanged: (value) {
                          setState(() {
                            _selectedServices[index] = value!;
                          });
                        },
                        title: Row(
                          children: [
                            Icon(
                              _getServiceIcon(service),
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(service),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_stationNameController.text.isNotEmpty) {
                      setState(() {
                        _stationName = _stationNameController.text;
                        _selectedLocation = location;
                      });
                      _stationNameController.clear();

                      // Close the dialog and show confirmation
                      Navigator.pop(context);
                      _showConfirmationDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a station name")),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show confirmation popup
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Location details saved successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// Function to open the map screen and get the location
  Future<void> _selectLocation() async {
    try {
      final selectedLocation = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );

      if (selectedLocation != null && selectedLocation is LatLng) {
        _showStationDetailsDialog(selectedLocation);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No location selected.")),
        );
      }
    } catch (e) {
      print('Error selecting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("An error occurred while selecting location.")),
      );
    }
  }

  /// Returns appropriate icon for each service
  IconData _getServiceIcon(String service) {
    switch (service) {
      case "Charging Port 1":
      case "Charging Port 2":
        return Icons.ev_station;
      case "Fast Charging":
        return Icons.bolt;
      case "Parking Service":
        return Icons.local_parking;
      case "Car Wash":
        return Icons.cleaning_services;
      case "Beverage":
        return Icons.local_cafe;
      case "Mechanic Support":
        return Icons.build;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _selectLocation,
              icon: const Icon(Icons.add_location_alt),
              label: const Text("Add Station Location"),
            ),
            if (_selectedLocation != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Station Name: $_stationName',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Selected Services:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ..._services
                          .asMap()
                          .entries
                          .where((entry) => _selectedServices[entry.key])
                          .map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                _getServiceIcon(entry.value),
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(entry.value),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stationNameController.dispose();
    super.dispose();
  }
}
