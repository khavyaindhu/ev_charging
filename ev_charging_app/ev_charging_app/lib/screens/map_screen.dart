import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chargingStations;

  const MapScreen({super.key, required this.chargingStations});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> defaultLocations = [
      // {
      //   'name': 'Salem EV Zone',
      //   'location': LatLng(11.6643, 78.1460),
      // },
      {
        'name': 'Madurai Charge Hub',
        'location': LatLng(9.9252, 78.1198),
      },
      {
        'name': 'Coimbatore Power Station',
        'location': LatLng(11.0168, 76.9558),
      },
      {
        'name': 'Tiruppur EV Point',
        'location': LatLng(11.1085, 77.3411),
      },
      {
        'name': 'Nagercoil Green Charge',
        'location': LatLng(8.1833, 77.4119),
      },
    ];

    // Debug: Log the charging stations passed to MapScreen
    print("Default Locations: $defaultLocations");
    print("Fetched Charging Stations: $chargingStations");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(10.7905, 78.1121), // Center of Tamil Nadu
          initialZoom: 7,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Add markers for default locations (green)
              ...defaultLocations.map((location) => Marker(
                    width: 200,
                    height: 70,
                    point: location['location'],
                    child: Column(
                      children: [
                        const Icon(
                          Icons.ev_station,
                          color: Colors.green,
                          size: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            location['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              // Add markers for fetched charging stations (blue)
              ...chargingStations.map((station) => Marker(
                    width: 200,
                    height: 70,
                    point: station['location'],
                    child: Column(
                      children: [
                        const Icon(
                          Icons.ev_station,
                          color: Colors.blue,
                          size: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            station['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> chargingStations;

//   const MapScreen({super.key, required this.chargingStations});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> defaultLocations = [
//       {
//         'name': 'Salem EV Zone',
//         'location': LatLng(11.6643, 78.1460),
//       },
//       {
//         'name': 'Madurai Charge Hub',
//         'location': LatLng(9.9252, 78.1198),
//       },
//       {
//         'name': 'Coimbatore Power Station',
//         'location': LatLng(11.0168, 76.9558),
//       },
//       {
//         'name': 'Tiruppur EV Point',
//         'location': LatLng(11.1085, 77.3411),
//       },
//       {
//         'name': 'Nagercoil Green Charge',
//         'location': LatLng(8.1833, 77.4119),
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Location"),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           initialCenter: LatLng(10.7905, 78.1121), // Center of Tamil Nadu
//           initialZoom: 7,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               // Add markers for default locations (green)
//               ...defaultLocations.map((location) => Marker(
//                     width: 200,
//                     height: 70,
//                     point: location['location'],
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.ev_station,
//                           color: Colors.green,
//                           size: 30,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             location['name'],
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )),
//               // Add markers for fetched charging stations (blue)
//               ...chargingStations.map((station) => Marker(
//                     width: 200,
//                     height: 70,
//                     point: station['location'],
//                     child: Column(
//                       children: [
//                         const Icon(
//                           Icons.ev_station,
//                           color: Colors.blue,
//                           size: 30,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             station['name'],
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
