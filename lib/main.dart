import 'package:flutter/material.dart';

void main() {
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🚗 Parking Sign AI"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
  child: ElevatedButton(
    onPressed: () {
      print("Scan button pressed");
    },
    child: Text("Scan Parking Sign 📷"),
  ),
),
    );
  }
}