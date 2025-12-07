import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PhoneTrackerApp());
}

class PhoneTrackerApp extends StatelessWidget {
  const PhoneTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TrackerHome(),
    );
  }
}

class TrackerHome extends StatefulWidget {
  const TrackerHome({super.key});

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> {
  String status = "Idle";

  Future<void> uploadLocation() async {
    try {
      var pos = await Geolocator.getCurrentPosition();
      await FirebaseFirestore.instance.collection("device").doc("myphone").set({
        "lat": pos.latitude,
        "lng": pos.longitude,
        "time": DateTime.now().toString()
      });
      setState(() => status = "Location uploaded");
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: uploadLocation,
              child: const Text("Upload My Location"),
            ),
            const SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}
