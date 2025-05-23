import 'package:flutter/material.dart';
import 'package:medcon30/doctor/modules/consultation_requests_screen.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors
    const primaryColor = Color(0xFF6750A4);
    const cardBg = Color(0xFFF7F7FB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Header
            const Text(
              "Welcome, Dr. Sarah Chen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Neurologist • Memorial Hospital",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Today's Schedule Card
            Card(
              color: cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Today's Schedule",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View All"),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "May 21, 2025",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    // Appointment 1
                    _ScheduleItem(
                      name: "Michael Rodriguez",
                      time: "09:30 AM",
                      type: "Follow-up",
                    ),
                    const SizedBox(height: 8),
                    // Appointment 2
                    _ScheduleItem(
                      name: "Emma Thompson",
                      time: "11:15 AM",
                      type: "New Patient",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Grid
            const Text(
              "Quick Actions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _QuickActionButton(
                  icon: Icons.chat_bubble_outline,
                  title: "Consultations",
                  subtitle: "3 new requests",
                  iconBg: Color(0xFFF3F0FF),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ConsultationRequestsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _QuickActionButton(
                  icon: Icons.people_outline,
                  title: "My Patients",
                  subtitle: "View records",
                  iconBg: Color(0xFFF3F0FF),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                _QuickActionButton(
                  icon: Icons.bar_chart_outlined,
                  title: "Analytics",
                  subtitle: "View insights",
                  iconBg: Color(0xFFF8F0FF),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Patients Card
            Card(
              color: cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Recent Patients",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View All"),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RecentPatientItem(
                      name: "Jennifer Wilson",
                      age: 34,
                      condition: "Migraine",
                    ),
                    const SizedBox(height: 8),
                    _RecentPatientItem(
                      name: "Robert Johnson",
                      age: 56,
                      condition: "Parkinson's",
                    ),
                    const SizedBox(height: 8),
                    _RecentPatientItem(
                      name: "Sophia Martinez",
                      age: 28,
                      condition: "Epilepsy",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
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
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String name;
  final String time;
  final String type;

  const _ScheduleItem({
    required this.name,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.calendar_today,
                color: Color(0xFF6750A4), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  "$time • $type",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7F7FB),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: const Color(0xFF6750A4), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}

class _RecentPatientItem extends StatelessWidget {
  final String name;
  final int age;
  final String condition;

  const _RecentPatientItem({
    required this.name,
    required this.age,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.person, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                "$age years • $condition",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("View"),
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF6750A4),
            padding: EdgeInsets.zero,
            minimumSize: Size(40, 30),
          ),
        ),
      ],
    );
  }
}
