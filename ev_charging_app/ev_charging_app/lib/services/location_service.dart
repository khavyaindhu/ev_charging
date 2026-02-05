import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // Save location information
  static Future<void> saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
  }

  // Retrieve location information
  static Future<String?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('location');
  }
}

// import 'package:shared_preferences/shared_preferences.dart';

// class LocationService {
//   Future<void> saveLocation(double lat, double lng) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setDouble("latitude", lat);
//     prefs.setDouble("longitude", lng);
//   }

//   Future<Map<String, double>> getLocation() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       "latitude": prefs.getDouble("latitude") ?? 0.0,
//       "longitude": prefs.getDouble("longitude") ?? 0.0,
//     };
//   }
// }
