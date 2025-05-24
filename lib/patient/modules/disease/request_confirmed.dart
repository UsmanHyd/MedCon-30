import 'package:flutter/material.dart';
import 'disease_detection.dart';

class RequestConfirmedScreen extends StatelessWidget {
  const RequestConfirmedScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
                        'Request Confirmed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 18.0),
                    child: Icon(Icons.help_outline,
                        color: Color(0xFF2196F3), size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E3EA)),
            Expanded(
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFE3F2FD),
                        radius: 32,
                        child: Icon(Icons.check,
                            color: Color(0xFF2196F3), size: 40),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Request Sent\nSuccessfully!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your consultation request has been sent to\nDr. Sarah Johnson. You will receive a\nconfirmation shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F7FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Date:',
                                    style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(width: 8),
                                const Text('Friday, May 9, 2025',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('Time:',
                                    style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(width: 8),
                                const Text('04:00 PM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiseaseDetectionScreen()),
                      (route) => false,
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
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
