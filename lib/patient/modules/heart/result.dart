import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HeartAnalysisResultScreen extends StatelessWidget {
  const HeartAnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Analysis Results',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F8FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heart Health Risk Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 38,
                    lineWidth: 8,
                    percent: 0.24,
                    center: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('24%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text('Risk',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                    progressColor: const Color(0xFF22C55E),
                    backgroundColor: const Color(0xFFE5F9ED),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FADF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Low Risk',
                              style: TextStyle(
                                  color: Color(0xFF12B76A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            'Based on your medical report from May 8, 2025',
                            style:
                                TextStyle(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Key Findings Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Key Findings',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _findingRow(
                    icon: Icons.favorite,
                    iconColor: const Color(0xFF7B9EFF),
                    title: 'Blood Pressure',
                    value: '120/80 mmHg - Within normal range',
                  ),
                  const SizedBox(height: 12),
                  _findingRow(
                    icon: Icons.monitor_heart,
                    iconColor: const Color(0xFF4ADE80),
                    title: 'Heart Rate',
                    value: '72 BPM - Normal resting heart rate',
                  ),
                  const SizedBox(height: 12),
                  _findingRow(
                    icon: Icons.egg_alt,
                    iconColor: const Color(0xFFFFE066),
                    title: 'Cholesterol Levels',
                    value: 'Total: 210 mg/dL - Slightly elevated',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Recommendations Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recommendations',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _recommendationRow(
                    icon: Icons.restaurant,
                    iconColor: const Color(0xFF22C55E),
                    title: 'Diet',
                    description:
                        'Consider reducing saturated fats to help manage cholesterol levels',
                  ),
                  const SizedBox(height: 12),
                  _recommendationRow(
                    icon: Icons.directions_run,
                    iconColor: const Color(0xFF7B61FF),
                    title: 'Exercise',
                    description:
                        'Maintain your current exercise routine of 150 minutes per week',
                  ),
                  const SizedBox(height: 12),
                  _recommendationRow(
                    icon: Icons.calendar_today,
                    iconColor: const Color(0xFF0288D1),
                    title: 'Follow-up',
                    description: 'Schedule your next check-up in 6 months',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Consult Doctor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _findingRow(
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.13),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recommendationRow(
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.13),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}
