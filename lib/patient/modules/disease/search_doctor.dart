import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';
import 'doctor_profile.dart';

class SearchDoctorScreen extends StatefulWidget {
  const SearchDoctorScreen({super.key});

  @override
  State<SearchDoctorScreen> createState() => _SearchDoctorScreenState();
}

class _SearchDoctorScreenState extends State<SearchDoctorScreen> {
  final List<String> filters = [
    'All',
    'General Physician',
    'Pulmonologist',
    'Cardiologist',
  ];
  int selectedFilter = 0;

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'General Physician',
      'rating': 4.8,
      'reviews': 124,
      'distance': 1.2,
      'available': 'Available today',
      'avatar': 'assets/images/doctor1.png',
      'nextAvailable': '',
    },
    {
      'name': 'Dr. David Chen',
      'specialty': 'Pulmonologist',
      'rating': 4.9,
      'reviews': 98,
      'distance': 2.5,
      'available': '',
      'avatar': 'assets/images/doctor2.png',
      'nextAvailable': 'Next available: Tomorrow',
    },
    {
      'name': 'Dr. Maria Rodriguez',
      'specialty': 'ENT Specialist',
      'rating': 4.7,
      'reviews': 87,
      'distance': 3.1,
      'available': 'Available today',
      'avatar': 'assets/images/doctor3.png',
      'nextAvailable': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? Colors.grey[900] : const Color(0xFFE0F7FA);
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.blueGrey[900];
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.blueGrey[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 20, color: textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Search for Doctors',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: textColor,
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
            // Filters
            Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(filters.length, (i) {
                    final selected = selectedFilter == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(filters[i]),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedFilter = i),
                        selectedColor: const Color(0xFF2196F3),
                        backgroundColor:
                            isDarkMode ? Colors.grey[800] : Colors.white,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selected
                                ? const Color(0xFF2196F3)
                                : isDarkMode
                                    ? Colors.grey[700]!
                                    : const Color(0xFFE0E3EA),
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Doctor cards
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                itemCount: doctors.length,
                itemBuilder: (context, i) {
                  final doc = doctors[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            width: 48,
                            height: 48,
                            color:
                                isDarkMode ? Colors.grey[800] : Colors.blue[50],
                            child: Icon(
                              Icons.account_circle,
                              size: 48,
                              color: isDarkMode
                                  ? Colors.grey[600]
                                  : Colors.blueGrey[200],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                doc['specialty'],
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Color(0xFFFFC107), size: 18),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${doc['rating']}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '(${doc['reviews']})',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey[500]
                                          : Colors.blueGrey[400],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              if (doc['available'] != '')
                                Row(
                                  children: [
                                    const Icon(Icons.circle,
                                        color: Color(0xFF4CAF50), size: 10),
                                    const SizedBox(width: 4),
                                    Text(
                                      doc['available'],
                                      style: const TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (doc['nextAvailable'] != '')
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Color(0xFFFF9800), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      doc['nextAvailable'],
                                      style: const TextStyle(
                                        color: Color(0xFFFF9800),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 34),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorProfileScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                minimumSize: const Size(60, 32),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
