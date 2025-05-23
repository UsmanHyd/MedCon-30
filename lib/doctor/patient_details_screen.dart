import 'package:flutter/material.dart';
import 'modules/prescription_assistant_screen.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient Card
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.pink.shade100,
                    child: const Text('HR',
                        style: TextStyle(fontSize: 22, color: Colors.black)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Harper Reynolds',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Text('42 years • Female • Blood Type: O+',
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
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
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF6750A4),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF6750A4)),
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
                  backgroundColor: Color(0xFFF3F0FF),
                  foregroundColor: Color(0xFF6750A4),
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
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Consultation Request',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Spacer(),
                      Text('Today, 08:45 AM',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
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
                          color: const Color(0xFFFF6B6B).withOpacity(0.1),
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
                  const Text(
                    'Severe migraine with visual disturbances and nausea for the past 3 days. Previous history of similar episodes. Pain is concentrated on the right side of the head with pulsating sensation. Light and sound sensitivity has made it difficult to perform daily activities.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Patient notes:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 4),
                        Text(
                          "This is the worst migraine I've experienced in years. The visual auras started 3 days ago, followed by intense pain. Over-the-counter medications haven't helped. I've had to miss work due to the severity.",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Medical History
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
          ),
          const SizedBox(height: 18),
          // Previous Consultations
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Previous Consultations',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
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
                    backgroundColor: const Color(0xFF6750A4),
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
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Color(0xFFDFDFDF)),
                  ),
                  child: const Text('Schedule Appointment'),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6750A4),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: "Patients"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
        currentIndex: 1,
        onTap: (index) {},
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
          Icon(icon, color: Color(0xFF6750A4), size: 20),
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
            child: const Text('View'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF6750A4),
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 30),
            ),
          ),
        ],
      ),
    );
  }
}
