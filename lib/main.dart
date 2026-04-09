import 'package:flutter/material.dart';
import 'camera_screen.dart';

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
      Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CameraScreen()),
  );
    },
    child: Text("Scan Parking Sign 📷"),
  ),
),
    );
  }
}