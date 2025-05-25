import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';
import 'consultation_request.dart';

class DoctorProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? Colors.grey[900] : const Color(0xFFE0F7FA);
    final cardColor = isDarkMode ? Colors.grey[850] : const Color(0xFFE0F7FA);
    final textColor = isDarkMode ? Colors.white : Colors.blueGrey[900];
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.blueGrey[700];
    final iconBgColor = isDarkMode ? Colors.grey[800] : Colors.blue[50];
    final iconColor = isDarkMode ? Colors.grey[600] : Colors.blueGrey[200];

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
                        'Doctor Profile',
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Large doctor image
                  Container(
                    width: double.infinity,
                    height: 140,
                    color: iconBgColor,
                    child: Center(
                      child: Icon(Icons.account_circle,
                          size: 100, color: iconColor),
                    ),
                  ),
                  // Profile card
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    transform: Matrix4.translationValues(0, -32, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
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
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Container(
                                width: 56,
                                height: 56,
                                color: iconBgColor,
                                child: Icon(Icons.account_circle,
                                    size: 56, color: iconColor),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. Sarah Johnson',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    'General Physician',
                                    style: TextStyle(
                                      color: subTextColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Color(0xFFFFC107), size: 18),
                                      const SizedBox(width: 2),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '(124 reviews)',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.grey[500]
                                              : Colors.blueGrey[400],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('8+',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                const SizedBox(height: 2),
                                Text('Years Exp.',
                                    style: TextStyle(
                                        color: subTextColor, fontSize: 13)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('1500+',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                const SizedBox(height: 2),
                                Text('Patients',
                                    style: TextStyle(
                                        color: subTextColor, fontSize: 13)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('98%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                const SizedBox(height: 2),
                                Text('Satisfaction',
                                    style: TextStyle(
                                        color: subTextColor, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // About
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: textColor, fontSize: 14),
                        children: [
                          const TextSpan(
                              text: 'About',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  ' Dr. Sarah Johnson is a board-certified general physician with over 8 years of experience in treating various medical conditions. She specializes in preventive care and managing chronic conditions.'),
                        ],
                      ),
                    ),
                  ),
                  // Qualifications
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qualifications',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: textColor)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Icon(Icons.check,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : const Color(0xFF2196F3),
                              size: 18),
                          const SizedBox(width: 6),
                          Text('MD from Stanford University',
                              style: TextStyle(fontSize: 14, color: textColor))
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.check,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : const Color(0xFF2196F3),
                              size: 18),
                          const SizedBox(width: 6),
                          Text('Board Certified in Internal Medicine',
                              style: TextStyle(fontSize: 14, color: textColor))
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.check,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : const Color(0xFF2196F3),
                              size: 18),
                          const SizedBox(width: 6),
                          Text('Fellowship in Primary Care',
                              style: TextStyle(fontSize: 14, color: textColor))
                        ]),
                      ],
                    ),
                  ),
                  // Location
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : const Color(0xFF2196F3),
                                size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('125 Medical Plaza, Healthcare City',
                                  style: TextStyle(
                                      fontSize: 14, color: textColor)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text('1.2 km away',
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[500]
                                      : Colors.blueGrey[400],
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  // Reviews
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reviews',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: textColor)),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Michael R.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(width: 6),
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 16),
                            Text('5',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const Spacer(),
                            Text('May 2, 2025',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[500]
                                        : Colors.blueGrey[400],
                                    fontSize: 12)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, top: 2.0, bottom: 8.0),
                          child: Text(
                              'Dr. Johnson was very thorough and took the time to explain everything clearly. Highly recommend!',
                              style: TextStyle(fontSize: 13, color: textColor)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Emma T.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(width: 6),
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 16),
                            Text('4',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const Spacer(),
                            Text('April 28, 2025',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[500]
                                        : Colors.blueGrey[400],
                                    fontSize: 12)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, top: 2.0, bottom: 8.0),
                          child: Text(
                              'Professional and caring doctor. The wait time was a bit long though.',
                              style: TextStyle(fontSize: 13, color: textColor)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('See all reviews >',
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.blue[300]
                                      : const Color(0xFF2196F3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsultationRequestScreen(),
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
                          'Request Online Consultation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
