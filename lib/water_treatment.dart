import 'package:flutter/material.dart';
void main() {
  runApp(const MaterialApp(home: WaterTreatmentMethodsPage()));
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

      if (phValue < 6.0) {
        potentialIssues += 'Low pH (acidic) detected. \n';
      } else if (phValue > 9.0) {
        potentialIssues += 'High pH (alkaline) detected. \n';
      }

      if (turbidityValue > 50) {
        potentialIssues += 'High turbidity detected. \n';
      }
      if (conductivityValue > 1500) {
        potentialIssues += 'High conductivity detected. \n';
      }
      if (tdsValue > 1000) {
        potentialIssues += 'High TDS detected. \n';
      }
      assessmentRecommendations =
          'A comprehensive water quality analysis by a certified laboratory is essential before any treatment decisions are made. The following are potential concerns indicated by the sensor readings:\n\n';

      if (potentialIssues.isNotEmpty) {
        assessmentRecommendations += potentialIssues;
      } else {
        assessmentRecommendations +=
            'The measured parameters are within generally acceptable ranges. However, continuous monitoring and regular testing for a broader range of contaminants are crucial for long-term water quality management.\n';
      }

      assessmentRecommendations += '\n*General Recommendations:*\n';

      treatmentMethods =
          'Note: These are general treatment approaches. The specific steps and methods will depend on a detailed water quality analysis and should be determined by a qualified water treatment professional.\n\n';

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
            '1. pH Adjustment: Add lime (calcium hydroxide) to raise pH if acidic or add acid (e.g., sulfuric acid) to lower pH if alkaline. Monitor pH closely.\n';
      }

      assessmentRecommendations +=
          '\n*Disclaimer:* This information is for educational purposes only and does not constitute professional advice. Consult with a water quality expert for accurate assessment and treatment recommendations.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Treatment Methods'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField('pH Value', Icons.science, (value) {
                setState(() => phValue = double.tryParse(value) ?? phValue);
              }),
              const SizedBox(height: 10),
              _buildInputField('Turbidity Value', Icons.water_drop, (value) {
                setState(() => turbidityValue = double.tryParse(value) ?? turbidityValue);
              }),
              const SizedBox(height: 10),
              _buildInputField('Conductivity Value', Icons.device_thermostat, (value) {
                setState(() => conductivityValue = double.tryParse(value) ?? conductivityValue);
              }),
              const SizedBox(height: 10),
              _buildInputField('TDS Value', Icons.analytics, (value) {
                setState(() => tdsValue = double.tryParse(value) ?? tdsValue);
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _determineTreatment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Assess Water Quality', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              _buildResultCard('Potential Issues', potentialIssues),
              _buildResultCard('Assessment & Recommendations', assessmentRecommendations),
              _buildResultCard('General Treatment Methods', treatmentMethods),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  Widget _buildResultCard(String title, String content) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
