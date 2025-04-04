import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String _streamAddress = "192.168.0.21"; // Set your Pi IP here

  String temperature = "-";
  String humidity = "-";
  String turbidity = "-";
  bool loading = true;

  Timer? _timer;

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(
        Uri.parse("http://$_streamAddress:5000/sensor_data"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data["temperature"].toString();
          humidity = data["humidity"].toString();
          turbidity = data["turbidity"].toString();
          loading = false;
        });
      } else {
        setState(() => loading = false);
        print("Error: ${response.body}");
      }
    } catch (e) {
      setState(() => loading = false);
      print("Failed to load sensor data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSensorData(); // Initial load
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchSensorData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Data"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => loading = true);
              fetchSensorData();
            },
          )
        ],
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDataTile(
                      "Temperature", "$temperature °C", Icons.thermostat),
                  _buildDataTile("Humidity", "$humidity %", Icons.water_drop),
                  _buildDataTile("Turbidity", "$turbidity NTU", Icons.opacity),
                ],
              ),
      ),
    );
  }

  Widget _buildDataTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
