import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(home: ControllerApp()));
}

class ControllerApp extends StatefulWidget {
  const ControllerApp({super.key});

  @override
  State<ControllerApp> createState() => _ControllerAppState();
}

class _ControllerAppState extends State<ControllerApp> {
  String _streamAddress = "192.168.0.21"; // Change to your stream IP
  String activeButton = ""; // Stores the active button

  void _sendCommand(String direction) async {
    setState(() {
      activeButton = direction;
    });

    // Reset glow effect after 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          activeButton = "";
        });
      }
    });

    print("Moving: $direction");

    // Send HTTP POST request to Flask server
    try {
      final uri = Uri.parse("http://$_streamAddress:5000/control");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"command": _mapDirectionToCommand(direction)}),
      );

      if (response.statusCode != 200) {
        print("Error: ${response.body}");
      } else {
        print("Command sent: ${_mapDirectionToCommand(direction)}");
      }
    } catch (e) {
      print("Failed to send command: $e");
    }
  }

  String _mapDirectionToCommand(String direction) {
    switch (direction) {
      case "Up":
        return "F";
      case "Down":
        return "B";
      case "Left":
        return "L";
      case "Right":
        return "R";
      default:
        return "S";
    }
  }

  void _showStreamAddressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newAddress = _streamAddress;
        return AlertDialog(
          title: const Text('Enter Stream Address'),
          content: TextField(
            onChanged: (value) {
              newAddress = value;
            },
            decoration: const InputDecoration(hintText: "Stream IP Address"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _streamAddress = newAddress;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Stream & Controller"),
        backgroundColor: const Color.fromARGB(255, 23, 97, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showStreamAddressDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Live Streaming Section
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Streaming from: $_streamAddress",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Mjpeg(
                    isLive: true,
                    stream: "http://$_streamAddress:5000/video",
                    error: (context, error, stack) {
                      return const Center(
                        child: Text(
                          'Stream failed. Check address.',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // D-Pad Controller at the Bottom
          Expanded(
            flex: 3,
            child: DPadController(
              onDirectionPressed: _sendCommand,
              activeButton: activeButton,
            ),
          ),
        ],
      ),
    );
  }
}

// D-Pad Controller Widget
class DPadController extends StatelessWidget {
  final Function(String) onDirectionPressed;
  final String activeButton;

  const DPadController({
    super.key,
    required this.onDirectionPressed,
    required this.activeButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Central circular logo
          Positioned(
            top: 65,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 247, 240, 240),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/aquadoc_logo.png', // Make sure this asset exists in your project
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Arrow buttons
          _buildButton(Icons.arrow_upward, "Up", 0, -70, 0),
          _buildButton(Icons.arrow_downward, "Down", 0, 70, 0),
          _buildButton(Icons.arrow_back, "Left", -70, 0, 0),
          _buildButton(Icons.arrow_forward, "Right", 70, 0, 0),
        ],
      ),
    );
  }

  Widget _buildButton(
      IconData icon, String direction, double dx, double dy, double rotation) {
    bool isActive = direction == activeButton;

    return Positioned(
      left: 75 + dx,
      top: 75 + dy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.8),
                    spreadRadius: 8,
                    blurRadius: 15,
                  ),
                ]
              : [],
        ),
        child: Transform.rotate(
          angle: rotation * 3.1416 / 180,
          child: ElevatedButton(
            onPressed: () => onDirectionPressed(direction),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.blue.shade700,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
