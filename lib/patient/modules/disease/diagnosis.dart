import 'package:flutter/material.dart';
import 'search_doctor.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';

class DiagnosisScreen extends StatelessWidget {
  final List<Map<String, dynamic>> diagnoses = [
    {
      'name': 'Common Cold',
      'dotColor': const Color(0xFF4CAF50),
      'percent': 85,
      'desc':
          'A viral infection of the upper respiratory tract. Rest, fluids, and over-the-counter medications can help alleviate symptoms.',
      'status': 'Monitor symptoms',
      'statusColor': const Color(0xFF4CAF50),
    },
    {
      'name': 'Seasonal Allergies',
      'dotColor': const Color(0xFF4CAF50),
      'percent': 72,
      'desc':
          'An immune system response to allergens like pollen or dust. Antihistamines and avoiding triggers can help manage symptoms.',
      'status': 'Monitor symptoms',
      'statusColor': const Color(0xFF4CAF50),
    },
    {
      'name': 'Influenza',
      'dotColor': const Color(0xFFFF9800),
      'percent': 64,
      'desc':
          'A viral infection that attacks your respiratory system. Antiviral medications may be prescribed if diagnosed early.',
      'status': 'Seek medical advice soon',
      'statusColor': const Color(0xFFFF9800),
    },
    {
      'name': 'Strep Throat',
      'dotColor': const Color(0xFFFF9800),
      'percent': 45,
      'desc':
          'A bacterial infection requiring antibiotics. If left untreated, it can lead to more serious conditions.',
      'status': 'Seek medical advice soon',
      'statusColor': const Color(0xFFFF9800),
    },
    {
      'name': 'COVID-19',
      'dotColor': const Color(0xFFF44336),
      'percent': 38,
      'desc':
          'A respiratory illness caused by the SARS-CoV-2 virus. Testing is recommended to confirm diagnosis.',
      'status': 'Urgent attention needed',
      'statusColor': const Color(0xFFF44336),
    },
  ];

  DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFE0F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: isDarkMode ? Colors.grey[850] : const Color(0xFFE0F7FA),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 20,
                        color:
                            isDarkMode ? Colors.white : Colors.blueGrey[900]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Potential Diagnoses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color:
                              isDarkMode ? Colors.white : Colors.blueGrey[900],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Icon(Icons.help_outline,
                        color: isDarkMode
                            ? Colors.blue[300]
                            : const Color(0xFF2196F3),
                        size: 20),
                  ),
                ],
              ),
            ),
            Divider(
                height: 1,
                thickness: 1,
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFE0E3EA)),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Based on your symptoms:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...diagnoses.map((diag) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  diag['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.blueGrey[900],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  margin: const EdgeInsets.only(top: 7),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: diag['dotColor'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${diag['percent']}%',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.blue[300]
                                          : const Color(0xFF2196F3),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              diag['desc'],
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.blueGrey[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                diag['status'],
                                style: TextStyle(
                                  color: diag['statusColor'],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[700]!
                              : const Color(0xFFB0BEC5),
                          width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: isDarkMode
                                ? Colors.blue[300]
                                : const Color(0xFF2196F3),
                            size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This is not a medical diagnosis. Please consult with a healthcare professional.',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.blueGrey[700],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchDoctorScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Search for Doctor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
