import 'package:flutter/material.dart';
import '../patient_details_screen.dart';

class ConsultationRequestsScreen extends StatelessWidget {
  const ConsultationRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requests = [
      {
        'initials': 'HR',
        'name': 'Harper Reynolds',
        'age': 42,
        'gender': 'Female',
        'summary':
            'Severe migraine with visual disturbances and nausea for the past 3 days. Previous history ...',
        'time': 'Today, 08:45 AM',
        'status': 'Urgent',
        'statusColor': Color(0xFFFF6B6B),
      },
      {
        'initials': 'JL',
        'name': 'James Liu',
        'age': 65,
        'gender': 'Male',
        'summary':
            'Tremors in right hand, progressively worsening over the past 6 months. Family ...',
        'time': 'Today, 10:12 AM',
        'status': 'Medium',
        'statusColor': Color(0xFFFFD600),
      },
      {
        'initials': 'AP',
        'name': 'Aisha Patel',
        'age': 29,
        'gender': 'Female',
        'summary':
            'Experiencing frequent episodes of dizziness and lightheadedness, especially when...',
        'time': 'Today, 11:30 AM',
        'status': 'Regular',
        'statusColor': Color(0xFF4CAF50),
      },
      {
        'initials': 'EM',
        'name': 'Ethan Morgan',
        'age': 37,
        'gender': 'Male',
        'summary':
            'Recurring headaches with sensitivity to light and sound. Symptoms worsen during stress...',
        'time': 'Today, 01:15 PM',
        'status': 'Medium',
        'statusColor': Color(0xFFFFD600),
      },
      {
        'initials': 'SN',
        'name': 'Sofia Nguyen',
        'age': 52,
        'gender': 'Female',
        'summary':
            'Memory lapses and confusion, particularly with names and recent events. Family ...',
        'time': 'Today, 02:45 PM',
        'status': 'Regular',
        'statusColor': Color(0xFF4CAF50),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Requests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final req = requests[i];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PatientDetailsScreen()),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF7F7FB),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Text(req['initials'] as String,
                        style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(req['name'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (req['statusColor'] as Color)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                req['status'] as String,
                                style: TextStyle(
                                  color: req['statusColor'] as Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${req['age']} years • ${req['gender']}",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          req['summary'] as String,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req['time'] as String,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
