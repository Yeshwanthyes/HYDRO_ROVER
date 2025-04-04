import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gps_track.dart';
import 'controller_stream.dart';
import 'ip_stream.dart';
import 'sensor_page.dart';
import 'water_treatment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaDoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0288D1), // Soft Blue Color
        scaffoldBackgroundColor: Colors.white, // Clean White Background
        fontFamily: GoogleFonts.nunito()
            .fontFamily, // Using Nunito for better legibility
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0288D1), // Headline Blue
          ),
          bodyLarge: GoogleFonts.nunito(
            fontSize: 18,
            color: Colors.black87, // Standard text color
          ),
          bodyMedium: GoogleFonts.nunito(
            fontSize: 16,
            color: const Color.fromARGB(
                255, 96, 26, 26), // Slightly lighter text for subtitles
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                const Color(0xFF0288D1), // Matching blue for buttons
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Rounded corners for modern look
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0288D1), // Consistent color with the app
          foregroundColor: Colors.white,
          elevation: 4, // Slight elevation for AppBar
          toolbarHeight: 70, // Make AppBar taller for better spacing
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0288D1),
          unselectedItemColor: Colors.grey,
          elevation: 8,
        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }), // Adds smooth page transition animations
      ),
      home: const MyHomePage(),
      routes: {
        '/second': (context) => const SecondPage(),
        '/live_streaming': (context) => const IpStreamApp(),
        '/controller': (context) => const ControllerApp(),
        '/gps_tracking': (context) => const GpsTracking_Page(),
        '/water_treatment_methods': (context) =>
            const WaterTreatmentMethodsPage(),
        '/water_quality_measurement': (context) => SensorPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = 'AquaDoc'});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/aquadoc_logo.png',
                height: 150,
                width: 150, // Make the logo width and height consistent
              ),
              const SizedBox(height: 30),
              Text(
                'Water Monitoring & Trash Collection',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                child: const Text('Get Started ->'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
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

class ControllerPage extends StatelessWidget {
  const ControllerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Controller')),
        body: const Center(child: Text('Controller Content')));
  }
}

class GpsTrackingPage extends StatelessWidget {
  const GpsTrackingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Gps Tracker')),
        body: const Center(child: Text('Gps Tracker Content')));
  }
}
