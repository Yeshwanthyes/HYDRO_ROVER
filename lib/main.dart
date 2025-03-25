import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: unused_import
import 'controller_stream.dart';
import 'ip_stream.dart';
import 'water_quality.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aquadoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 12, 0, 245),
                ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 84, 229),
          
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Aquadoc'),
      routes: {
        '/second': (context) => const SecondPage(),
        // '/live_streaming': (context) => const LiveStreamingPage(),
        '/live_streaming': (context) => const IpStreamApp(),
        '/controller': (context) => const ControllerApp(),
        '/gps_tracking': (context) => const GpsTrackingPage(),
        '/water_treatment_methods': (context) =>
            const WaterTreatmentMethodsPage(),
        '/water_quality_measurement': (context) =>
            WaterQualityPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'aquadoc_logo.png',
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Water Monitoring & Trash Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Get Started ->'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aquadoc App"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4,
          ),
          padding: const EdgeInsets.all(16.0),
          itemCount: 5,
          itemBuilder: (context, index) {
            final titles = [
              'Live Streaming',
              'Controller',
              'GPS Tracking',
              'Water Treatment Methods',
              'Water Quality Measurement',
            ];
            return _buildBox(titles[index], context);
          },
        ),
      ),
    );
  }

  Widget _buildBox(String title, BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
          if (title == 'Live Streaming') {
            Navigator.pushNamed(context, '/live_streaming');
          } else if (title == 'Controller') {
            Navigator.pushNamed(context, '/controller');
          } else if (title == 'GPS Tracking') {
            Navigator.pushNamed(context, '/gps_tracking');
          } else if (title == 'Water Treatment Methods') {
            Navigator.pushNamed(context, '/water_treatment_methods');
          } else if (title == 'Water Quality Measurement') {
            Navigator.pushNamed(context, '/water_quality_measurement');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 0, 3, 4), Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder Pages:
class LiveStreamingPage extends StatelessWidget {
  const LiveStreamingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Live Streaming')),
        body: const Center(child: Text('Live Streaming Content')));
  }
}

class ControllerPage extends StatelessWidget {
  const ControllerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Controller')),
        body: const Center(child: Text('Controller Content')));
  }
}

class GpsTrackingPage extends StatefulWidget {
  const GpsTrackingPage({super.key});

  @override
  State<GpsTrackingPage> createState() => _GpsTrackingPageState();
}

class _GpsTrackingPageState extends State<GpsTrackingPage> {
  GoogleMapController? _controller; // Nullable controller
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied.")),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Location permissions are permanently denied. Enable them in settings."),
          ),
        );
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();

      setState(() {
        _isLoading = false;
        if (_currentPosition != null) {
          LatLng position =
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
          _markers.clear();
          _markers.add(Marker(
            markerId: const MarkerId('current_location'),
            position: position,
            infoWindow: const InfoWindow(title: 'Current Location'),
          ));

          // Move camera only after map is created and location is available
          if (_controller != null) {
            _controller!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: position, zoom: 14.0),
            ));
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Tracking')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? const Center(child: Text("Could not get location."))
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude)
                        : const LatLng(0, 0),
                    zoom: _currentPosition != null ? 14.0 : 1.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    if (_currentPosition != null) {
                      LatLng position = LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude);
                      _controller!.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: position, zoom: 14.0),
                      ));
                    }
                  },
                  markers: _markers,
                ),
    );
  }
}


class WaterTreatmentMethodsPage extends StatefulWidget {
  const WaterTreatmentMethodsPage({super.key});

  @override
  State<WaterTreatmentMethodsPage> createState() =>
      _WaterTreatmentMethodsPageState();
}

class _WaterTreatmentMethodsPageState extends State<WaterTreatmentMethodsPage> {
  double phValue = 7.0;
  double turbidityValue = 0.0;
  double conductivityValue = 0.0;
  double tdsValue = 0.0;

  String potentialIssues = '';
  String assessmentRecommendations = '';
  String treatmentMethods = '';

  void _determineTreatment() {
    setState(() {
      potentialIssues = '';
      assessmentRecommendations = '';
      treatmentMethods = '';

      // pH Assessment
      if (phValue < 6.0) {
        potentialIssues += 'Low pH (acidic) detected.  \n';
      } else if (phValue > 9.0) {
        potentialIssues += 'High pH (alkaline) detected. \n';
      }

      // Turbidity Assessment
      if (turbidityValue > 50) {
        potentialIssues += 'High turbidity (cloudiness) detected. \n';
      }

      // Conductivity Assessment
      if (conductivityValue > 1500) {
        potentialIssues += 'High conductivity (dissolved ions) detected. \n';
      }

      // TDS Assessment
      if (tdsValue > 1000) {
        potentialIssues += 'High Total Dissolved Solids (TDS) detected. \n';
      }

      // Recommendations based on combined assessment
      assessmentRecommendations +=
          'A comprehensive water quality analysis by a certified laboratory is essential before any treatment decisions are made.  The following are potential concerns indicated by the sensor readings:\n\n';

      if (potentialIssues.isNotEmpty) {
        assessmentRecommendations += potentialIssues;
      } else {
        assessmentRecommendations +=
            'The measured parameters are within generally acceptable ranges. However, continuous monitoring and regular testing for a broader range of contaminants are crucial for long-term water quality management.\n';
      }

      assessmentRecommendations += '\n*General Recommendations:*\n';

      // Treatment Methods (Illustrative)
      treatmentMethods +=
          'Note: These are general treatment approaches.  The specific steps and methods will depend on a detailed water quality analysis and should be determined by a qualified water treatment professional.\n\n';

      if (turbidityValue > 50) {
        assessmentRecommendations +=
            '- High turbidity suggests the presence of suspended particles (sediment, algae, etc.). \n';
        treatmentMethods += 'Turbidity Reduction (Example Steps):\n'
            '1. Coagulation/Flocculation: Add a coagulant (e.g., alum, ferric chloride) to clump particles together.\n'
            '2. Flocculation: Gently mix the water to encourage the formation of larger flocs (clumps).\n'
            '3. Sedimentation: Allow the flocs to settle out.\n'
            '4. Filtration: Filter the water through sand, gravel, or membranes to remove remaining particles.\n';
      }

      if (conductivityValue > 1500 || tdsValue > 1000) {
        assessmentRecommendations +=
            '- High conductivity and/or TDS indicate elevated levels of dissolved substances (salts, minerals, etc.). \n';
        treatmentMethods += 'TDS/Conductivity Reduction (Example Steps):\n'
            '1. Reverse Osmosis (RO): Force water through a semi-permeable membrane to remove dissolved minerals and salts.\n'
            '2. Ion Exchange: Use resins to exchange unwanted ions for more acceptable ones.\n'
            '3. Distillation: Boil water and collect the steam, leaving minerals and salts behind.\n';
      }

      if (phValue < 6.0 || phValue > 9.0) {
        assessmentRecommendations +=
            '- pH outside the acceptable range can be harmful to aquatic life and may require adjustment. \n';
        treatmentMethods += 'pH Adjustment (Example Steps):\n'
            '1. pH Adjustment: Add lime (calcium hydroxide) to raise pH if acidic or add acid (e.g., sulfuric acid) to lower pH if alkaline.  Monitor pH closely.\n';
      }

      assessmentRecommendations +=
          '\n*Disclaimer:* This information is for educational purposes only and does not constitute professional advice.  Consult with a water quality expert for accurate assessment and treatment recommendations.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waste Water Treatment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'pH Value'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    phValue = double.tryParse(value) ?? phValue;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Turbidity Value'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    turbidityValue = double.tryParse(value) ?? turbidityValue;
                  });
                },
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Conductivity Value'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    conductivityValue =
                        double.tryParse(value) ?? conductivityValue;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'TDS Value'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    tdsValue = double.tryParse(value) ?? tdsValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _determineTreatment,
                child: const Text('Assess Water Quality'),
              ),
              const SizedBox(height: 20),
              Text(
                'Potential Issues:',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                potentialIssues,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'Assessment and Recommendations:',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                assessmentRecommendations,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                'General Treatment Methods:',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                treatmentMethods,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaterQualityMeasurementPage extends StatelessWidget {
  const WaterQualityMeasurementPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Water Quality Measurement')),
        body: const Center(child: Text('Water Quality Measurement Content')));
  }
}