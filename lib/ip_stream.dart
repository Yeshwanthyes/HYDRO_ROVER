import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IpStreamApp extends StatefulWidget {
  const IpStreamApp({super.key});

  @override
  State<IpStreamApp> createState() => _IpStreamAppState();
}

class _IpStreamAppState extends State<IpStreamApp> {
  late TextEditingController _tController;
  String _streamAddress = "192.168.236.77"; // Default IP
  String? _errorText;
  bool isR = true;
  bool _isLoading = false; // Track loading state

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
      _isLoading = true; // Show loader
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isR = true;
        _isLoading = false; // Hide loader
      });
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Soft background
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        title: Text(
          "AquaDoc Live Stream",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: openDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Streaming from: $_streamAddress",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blue.shade900),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : Card(
                    elevation: 5,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Mjpeg(
                        isLive: isR,
                        stream: "http://$_streamAddress:5000/video",
                        error: (context, error, stack) {
                          _showToast("Failed to load stream. Check the address.");
                          return const Center(
                            child: Text(
                              'Stream Unavailable',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _refreshStream,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                elevation: 3,
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text("Refresh Stream", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future openDialog() {
    _errorText = null;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Enter IP Address or Hostname", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.blueAccent)),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter IP or Hostname",
              errorText: _errorText,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _tController.clear();
                  setState(() => _errorText = null);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 16),
            controller: _tController,
          ),
          actions: [
            TextButton(
              onPressed: () => submit(setState),
              child: Text("Submit", style: GoogleFonts.poppins(color: Colors.blueAccent, fontWeight: FontWeight.w500)),
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
        _errorText = "Invalid IP or hostname";
      });
    }
  }
}
