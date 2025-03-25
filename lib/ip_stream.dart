import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class IpStreamApp extends StatefulWidget {
  const IpStreamApp({super.key});

  @override
  State<IpStreamApp> createState() => _IpStreamAppState();
}

class _IpStreamAppState extends State<IpStreamApp> {
  late TextEditingController _tController;
  String _streamAddress = "192.168.236.77"; // Supports both IP & Hostname
  String? _errorText;
  bool isR = true;

  @override
  void initState() {
    super.initState();
    _tController = TextEditingController();
  }

  @override
  void dispose() {
    _tController.dispose();
    super.dispose();
  }

  bool _isValidInput(String input) {
    final RegExp ipRegex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    final RegExp hostnameRegex = RegExp(r'^[a-zA-Z0-9.-]+$');

    return ipRegex.hasMatch(input) || hostnameRegex.hasMatch(input);
  }

  void _refreshStream() {
    setState(() {
      isR = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isR = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 151, 198, 237), // Set background to blue
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Dark blue AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "AquaDoc Stream App",
              style: TextStyle(color: Colors.white), // Ensure visibility
            ),
            ElevatedButton(
              onPressed: openDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Blue button
              ),
              child: const Icon(Icons.add, color: Colors.white), // White icon
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              "Streaming from: $_streamAddress",
              style: const TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          Center(
            child: Mjpeg(
              isLive: isR,
              stream: "http://$_streamAddress:5000/video",
              error: (context, error, stack) {
                return const Center(
                  child: Text(
                    'Failed to load stream. Please check the address and try again.',
                    style: TextStyle(fontSize:17,color: Color.fromARGB(255, 1, 12, 6)),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _refreshStream,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 61, 174), // Blue refresh button
            ),
            child: const Text("Refresh Stream", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future openDialog() {
    _errorText = null;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 0, 61, 174), // Blue dialog background
          title: const Text("Enter IP Address or Hostname", style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter IP or Hostname",
              errorText: _errorText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: _errorText != null
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    )
                  : const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
            ),
            style: const TextStyle(color: Colors.white),
            controller: _tController,
          ),
          actions: [
            TextButton(
              onPressed: () => submit(setState),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  void submit(void Function(void Function()) setDialogState) {
    if (_isValidInput(_tController.text)) {
      setState(() {
        _streamAddress = _tController.text;
        _refreshStream();
      });
      Navigator.of(context).pop();
    } else {
      setDialogState(() {
        _errorText = "Enter a valid IP address or hostname";
      });
    }
  }
}