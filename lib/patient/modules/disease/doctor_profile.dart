import 'package:flutter/material.dart';
import 'consultation_request.dart';

class DoctorProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              color: const Color(0xFFE0F7FA),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 20, color: Colors.blueGrey[900]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Doctor Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Icon(Icons.help_outline,
                        color: Color(0xFF2196F3), size: 20),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Color(0xFFE0E3EA)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Large doctor image
                  Container(
                    width: double.infinity,
                    height: 140,
                    color: Colors.blue[50],
                    child: Center(
                      child: Icon(Icons.account_circle,
                          size: 100, color: Colors.blueGrey[200]),
                    ),
                  ),
                  // Profile card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    transform: Matrix4.translationValues(0, -32, 0),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
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
                                color: Colors.blue[50],
                                child: Icon(Icons.account_circle,
                                    size: 56, color: Colors.blueGrey[200]),
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. Sarah Johnson',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.blueGrey[900],
                                    ),
                                  ),
                                  Text(
                                    'General Physician',
                                    style: TextStyle(
                                      color: Colors.blueGrey[700],
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Color(0xFFFFC107), size: 18),
                                      SizedBox(width: 2),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          color: Colors.blueGrey[900],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '(124 reviews)',
                                        style: TextStyle(
                                          color: Colors.blueGrey[400],
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
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('8+',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                SizedBox(height: 2),
                                Text('Years Exp.',
                                    style: TextStyle(
                                        color: Colors.blueGrey[500],
                                        fontSize: 13)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('1500+',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                SizedBox(height: 2),
                                Text('Patients',
                                    style: TextStyle(
                                        color: Colors.blueGrey[500],
                                        fontSize: 13)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('98%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2196F3))),
                                SizedBox(height: 2),
                                Text('Satisfaction',
                                    style: TextStyle(
                                        color: Colors.blueGrey[500],
                                        fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // About
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.blueGrey[800], fontSize: 14),
                        children: [
                          TextSpan(
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
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qualifications',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 8),
                        Row(children: [
                          Icon(Icons.check, color: Color(0xFF2196F3), size: 18),
                          SizedBox(width: 6),
                          Text('MD from Stanford University',
                              style: TextStyle(fontSize: 14))
                        ]),
                        SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.check, color: Color(0xFF2196F3), size: 18),
                          SizedBox(width: 6),
                          Text('Board Certified in Internal Medicine',
                              style: TextStyle(fontSize: 14))
                        ]),
                        SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.check, color: Color(0xFF2196F3), size: 18),
                          SizedBox(width: 6),
                          Text('Fellowship in Primary Care',
                              style: TextStyle(fontSize: 14))
                        ]),
                      ],
                    ),
                  ),
                  // Location
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Color(0xFF2196F3), size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('125 Medical Plaza, Healthcare City',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text('1.2 km away',
                              style: TextStyle(
                                  color: Colors.blueGrey[400], fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  // Reviews
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reviews',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Michael R.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 16),
                            Text('5',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text('May 2, 2025',
                                style: TextStyle(
                                    color: Colors.blueGrey[400], fontSize: 12)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, top: 2.0, bottom: 8.0),
                          child: Text(
                              'Dr. Johnson was very thorough and took the time to explain everything clearly. Highly recommend!',
                              style: TextStyle(fontSize: 13)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Emma T.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 16),
                            Text('4',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text('April 28, 2025',
                                style: TextStyle(
                                    color: Colors.blueGrey[400], fontSize: 12)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, top: 2.0, bottom: 8.0),
                          child: Text(
                              'Professional and caring doctor. The wait time was a bit long though.',
                              style: TextStyle(fontSize: 13)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('See all reviews >',
                              style: TextStyle(
                                  color: Color(0xFF2196F3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
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
                          backgroundColor: Color(0xFF2196F3),
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
