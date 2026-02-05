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
  final TextEditingController _searchController = TextEditingController();
  double _currentZoom = 13.0;
  LatLng _currentCenter = LatLng(12.9715987, 77.5945627); // Bangalore default
  bool _isSearching = false;

  // Predefined locations database for search
  final Map<String, LatLng> _locations = {
    // Major Cities in Tamil Nadu
    'chennai': LatLng(13.0827, 80.2707),
    'coimbatore': LatLng(11.0168, 76.9558),
    'madurai': LatLng(9.9252, 78.1198),
    'salem': LatLng(11.6643, 78.1460),
    'tiruchirappalli': LatLng(10.7905, 78.7047),
    'trichy': LatLng(10.7905, 78.7047),
    'tiruppur': LatLng(11.1085, 77.3411),
    'erode': LatLng(11.3410, 77.7172),
    'vellore': LatLng(12.9165, 79.1325),
    'thoothukudi': LatLng(8.7642, 78.1348),
    'tuticorin': LatLng(8.7642, 78.1348),
    'nagercoil': LatLng(8.1833, 77.4119),
    'thanjavur': LatLng(10.7870, 79.1378),
    'dindigul': LatLng(10.3673, 77.9803),
    'kanchipuram': LatLng(12.8342, 79.7036),
    'karur': LatLng(10.9601, 78.0766),
    'rajapalayam': LatLng(9.4518, 77.5536),
    'sivakasi': LatLng(9.4559, 77.7881),
    'tirunelveli': LatLng(8.7139, 77.7567),
    'tiruvannamalai': LatLng(12.2253, 79.0747),
    'pollachi': LatLng(10.6581, 77.0081),
    'kumbakonam': LatLng(10.9617, 79.3881),
    'ooty': LatLng(11.4102, 76.6950),
    'kodaikanal': LatLng(10.2381, 77.4892),
    
    // Major Cities in Karnataka
    'bangalore': LatLng(12.9716, 77.5946),
    'bengaluru': LatLng(12.9716, 77.5946),
    'mysore': LatLng(12.2958, 76.6394),
    'mysuru': LatLng(12.2958, 76.6394),
    'mangalore': LatLng(12.9141, 74.8560),
    'hubli': LatLng(15.3647, 75.1240),
    'belgaum': LatLng(15.8497, 74.4977),
    
    // Major Cities in Kerala
    'kochi': LatLng(9.9312, 76.2673),
    'cochin': LatLng(9.9312, 76.2673),
    'thiruvananthapuram': LatLng(8.5241, 76.9366),
    'trivandrum': LatLng(8.5241, 76.9366),
    'kozhikode': LatLng(11.2588, 75.7804),
    'calicut': LatLng(11.2588, 75.7804),
    'thrissur': LatLng(10.5276, 76.2144),
    'kollam': LatLng(8.8932, 76.6141),
    
    // Major Cities in Other States
    'hyderabad': LatLng(17.3850, 78.4867),
    'mumbai': LatLng(19.0760, 72.8777),
    'delhi': LatLng(28.7041, 77.1025),
    'pune': LatLng(18.5204, 73.8567),
    'ahmedabad': LatLng(23.0225, 72.5714),
    'jaipur': LatLng(26.9124, 75.7873),
    'kolkata': LatLng(22.5726, 88.3639),
  };

  List<String> _searchResults = [];

  void _searchLocation(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _locations.keys
          .where((location) => location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectLocation(String locationName) {
    final LatLng? location = _locations[locationName.toLowerCase()];
    if (location != null) {
      setState(() {
        _currentCenter = location;
        _currentZoom = 13.0;
        _searchController.text = locationName;
        _searchResults = [];
        _isSearching = false;
      });
      _mapController.move(location, _currentZoom);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: Colors.teal[700],
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map
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
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentCenter,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search Bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchLocation,
                      decoration: InputDecoration(
                        hintText: 'Search location...',
                        prefixIcon: const Icon(Icons.search, color: Colors.teal),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                    _isSearching = false;
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                // Search Results Dropdown
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.teal),
                          title: Text(
                            _searchResults[index].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onTap: () => _selectLocation(_searchResults[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Zoom Controls
          Positioned(
            right: 10,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _currentZoom += 1;
                    });
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_in, color: Colors.teal),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _currentZoom -= 1;
                    });
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.zoom_out, color: Colors.teal),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'myLocation',
                  backgroundColor: Colors.white,
                  onPressed: () {
                    // Reset to default location
                    setState(() {
                      _currentCenter = LatLng(12.9715987, 77.5945627);
                      _currentZoom = 13.0;
                    });
                    _mapController.move(_currentCenter, _currentZoom);
                  },
                  child: const Icon(Icons.my_location, color: Colors.teal),
                ),
              ],
            ),
          ),

          // Instruction Card
          Positioned(
            bottom: 20,
            left: 10,
            right: 80,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.touch_app, color: Colors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap on the map to select location',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.ev_station,
                                color: Colors.teal,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Configure EV Station",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Station Name Input
                        TextField(
                          controller: _stationNameController,
                          decoration: InputDecoration(
                            hintText: "Enter station name",
                            labelText: "Station Name",
                            prefixIcon: const Icon(Icons.label, color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Location Info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.teal, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Lat: ${location.latitude.toStringAsFixed(4)}, Long: ${location.longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        const Text(
                          "Select Services:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Services Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _services.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedServices[index] = !_selectedServices[index];
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedServices[index]
                                      ? Colors.teal.withOpacity(0.1)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedServices[index]
                                        ? Colors.teal
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getServiceIcon(_services[index]),
                                      color: _selectedServices[index]
                                          ? Colors.teal
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        _services[index],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: _selectedServices[index]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _selectedServices[index]
                                              ? Colors.teal
                                              : Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_stationNameController.text.isNotEmpty) {
                                  setState(() {
                                    _stationName = _stationNameController.text;
                                    _selectedLocation = location;
                                  });
                                  _stationNameController.clear();
                                  Navigator.pop(context);
                                  _showConfirmationDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter a station name"),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Save Station",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text("Success"),
            ],
          ),
          content: const Text("Location details saved successfully."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
      }
    } catch (e) {
      print('Error selecting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while selecting location."),
          backgroundColor: Colors.red,
        ),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[700]!, Colors.teal[500]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EV Charging Station",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Manage your charging network",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add Station Button
                  ElevatedButton(
                    onPressed: _selectLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_location_alt, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Add New Station Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Station Details Card
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.teal[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.ev_station,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Station Details",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          _stationName ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.teal),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Coordinates",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              const Text(
                                "Available Services",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _services
                                    .asMap()
                                    .entries
                                    .where((entry) => _selectedServices[entry.key])
                                    .map((entry) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.teal),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getServiceIcon(entry.value),
                                          color: Colors.teal,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          entry.value,
                                          style: const TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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