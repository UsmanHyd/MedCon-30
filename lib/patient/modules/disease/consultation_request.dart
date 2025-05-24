import 'package:flutter/material.dart';
import 'request_confirmed.dart';

class ConsultationRequestScreen extends StatefulWidget {
  const ConsultationRequestScreen({super.key});

  @override
  State<ConsultationRequestScreen> createState() =>
      _ConsultationRequestScreenState();
}

class _ConsultationRequestScreenState extends State<ConsultationRequestScreen> {
  final TextEditingController _symptomController = TextEditingController();
  int selectedDate = -1;
  int selectedTime = -1;
  bool agreed = false;

  final List<Map<String, String>> dates = [
    {'label': 'Today', 'date': 'May 8'},
    {'label': 'Fri', 'date': 'May 9'},
    {'label': 'Sat', 'date': 'May 10'},
    {'label': 'Sun', 'date': 'May 11'},
    {'label': 'Mon', 'date': 'May 12'},
  ];
  final List<String> times = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  bool get canSend =>
      _symptomController.text.trim().isNotEmpty &&
      selectedDate != -1 &&
      selectedTime != -1 &&
      agreed;

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
                        'Online Consultation',
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
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Doctor card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 48,
                            height: 48,
                            color: Colors.blue[50],
                            child: Icon(Icons.account_circle,
                                size: 48, color: Colors.blueGrey[200]),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dr. Sarah Johnson',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('General Physician',
                                style: TextStyle(
                                    color: Colors.blueGrey[700], fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Symptom description
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Describe your symptoms',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _symptomController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                'Please describe your symptoms in detail...',
                            hintStyle: TextStyle(color: Colors.blueGrey[300]),
                            filled: true,
                            fillColor: const Color(0xFFF4F9FD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  // Select Date
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(dates.length, (i) {
                              final selected = selectedDate == i;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedDate = i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF2196F3)
                                          : const Color(0xFFF4F9FD),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          dates[i]['label']!,
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Colors.blueGrey[900],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          dates[i]['date']!,
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Colors.blueGrey[400],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Select Time Slot
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Time Slot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(times.length, (i) {
                            final selected = selectedTime == i;
                            return GestureDetector(
                              onTap: () => setState(() => selectedTime = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFF2196F3)
                                      : const Color(0xFFF4F9FD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  times[i],
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.blueGrey[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Terms checkbox
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: agreed,
                          onChanged: (v) => setState(() => agreed = v ?? false),
                          activeColor: const Color(0xFF2196F3),
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to the terms and conditions for online consultation',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Send Request button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canSend
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RequestConfirmedScreen(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canSend
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFB0BEC5),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Send Request',
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
