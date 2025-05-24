import 'package:flutter/material.dart';
import 'prescription_assistant_screen.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        foregroundColor: const Color(0xFF0288D1),
        elevation: 0.5,
        centerTitle: true,
        surfaceTintColor: isDarkMode ? Colors.grey[850] : Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF0288D1)),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient Card
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
                  child: const Text('HR',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF0288D1),
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harper Reynolds',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black)),
                      const SizedBox(height: 4),
                      Text('42 years • Female • Blood Type: O+',
                          style: TextStyle(
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.grey,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  foregroundColor: const Color(0xFF0288D1),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF0288D1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message, size: 18),
                label: const Text('Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
                  foregroundColor: const Color(0xFF0288D1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Consultation Request Card
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Consultation Request',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black)),
                    const Spacer(),
                    Text('Today, 08:45 AM',
                        style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey,
                            fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFFF6B6B), size: 18),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withOpacity(0.13),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Urgent Request',
                          style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Severe migraine with visual disturbances and nausea for the past 3 days. Previous history of similar episodes. Pain is concentrated on the right side of the head with pulsating sensation. Light and sound sensitivity has made it difficult to perform daily activities.',
                  style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[200] : Colors.black),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient notes:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isDarkMode ? Colors.white : Colors.black)),
                      const SizedBox(height: 4),
                      Text(
                        "This is the worst migraine I've experienced in years. The visual auras started 3 days ago, followed by intense pain. Over-the-counter medications haven't helped. I've had to miss work due to the severity.",
                        style: TextStyle(
                            fontSize: 13,
                            color:
                                isDarkMode ? Colors.grey[200] : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Medical History
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medical History',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 12),
                _HistoryItem(
                    icon: Icons.event_note,
                    title: 'Chronic Migraine',
                    subtitle: 'Diagnosed 8 years ago'),
                _HistoryItem(
                    icon: Icons.favorite_border,
                    title: 'Hypertension',
                    subtitle: 'Diagnosed 5 years ago'),
                _HistoryItem(
                    icon: Icons.medication_outlined,
                    title: 'Current Medications',
                    subtitle:
                        'Sumatriptan (as needed), Propranolol 40mg daily, Lisinopril 10mg daily'),
                _HistoryItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Allergies',
                    subtitle: 'Penicillin, Sulfa drugs'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Previous Consultations
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Previous Consultations',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 12),
                _ConsultationItem(
                    title: 'Migraine Follow-up',
                    doctor: 'Dr. Sarah Chen',
                    date: 'March 15, 2025'),
                _ConsultationItem(
                    title: 'Hypertension Check',
                    doctor: 'Dr. James Wilson',
                    date: 'February 2, 2025'),
                _ConsultationItem(
                    title: 'Annual Physical',
                    doctor: 'Dr. Emily Parker',
                    date: 'January 10, 2025'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PrescriptionAssistantScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Prescription Assistant'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0288D1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Color(0xFF0288D1)),
                  ),
                  child: const Text('Schedule Appointment'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _HistoryItem(
      {required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0288D1), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationItem extends StatelessWidget {
  final String title;
  final String doctor;
  final String date;
  const _ConsultationItem(
      {required this.title, required this.doctor, required this.date});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('$doctor • $date',
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0288D1),
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 30),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}
