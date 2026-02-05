import 'package:flutter/material.dart';

class ToiletFacilityPage extends StatelessWidget {
  const ToiletFacilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toilet Facility"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "Toilet Facility Details Coming Soon!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
