import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Assuming Firebase for real-time data
// For data visualization

class WaterQualityPage extends StatefulWidget {
  const WaterQualityPage({super.key});

  @override
  _WaterQualityPageState createState() => _WaterQualityPageState();
}

class _WaterQualityPageState extends State<WaterQualityPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Quality Monitoring', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('water_data').doc('sensor_values').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data();
          double pH = data?['pH'] ?? 7.0;
          double turbidity = data?['turbidity'] ?? 0.0;
          double temperature = data?['temperature'] ?? 25.0;
          double conductivity = data?['conductivity'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildParameterCard('pH Level', pH, getStatusColor(pH, 6.5, 8.5), Icons.water_drop),
                buildParameterCard('Turbidity (NTU)', turbidity, getStatusColor(turbidity, 0, 5), Icons.blur_on),
                buildParameterCard('Temperature (°C)', temperature, getStatusColor(temperature, 10, 35), Icons.thermostat),
                buildParameterCard('Conductivity (µS/cm)', conductivity, getStatusColor(conductivity, 50, 500), Icons.electrical_services),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildParameterCard(String title, double value, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }

  Color getStatusColor(double value, double min, double max) {
    if (value < min) return Colors.redAccent;
    if (value > max) return Colors.orangeAccent;
    return Colors.green;
  }
}
