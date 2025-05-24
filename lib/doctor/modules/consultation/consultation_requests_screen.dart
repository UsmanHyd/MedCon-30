import 'package:flutter/material.dart';
import 'patient_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';

class ConsultationRequestsScreen extends StatefulWidget {
  const ConsultationRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ConsultationRequestsScreen> createState() =>
      _ConsultationRequestsScreenState();
}

class _ConsultationRequestsScreenState
    extends State<ConsultationRequestsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _allRequests = [
    {
      'initials': 'HR',
      'name': 'Harper Reynolds',
      'age': 42,
      'gender': 'Female',
      'summary':
          'Severe migraine with visual disturbances and nausea for the past 3 days. Previous history ...',
      'time': 'Today, 08:45 AM',
      'status': 'Urgent',
      'statusColor': const Color(0xFFFF6B6B),
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
      'statusColor': const Color(0xFFFFD600),
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
      'statusColor': const Color(0xFF4CAF50),
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
      'statusColor': const Color(0xFFFFD600),
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
      'statusColor': const Color(0xFF4CAF50),
    },
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    if (_selectedFilter == 'All') return _allRequests;
    return _allRequests
        .where((req) => req['status'] == _selectedFilter)
        .toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Status',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _selectedFilter == 'All',
                      onTap: () {
                        setState(() => _selectedFilter = 'All');
                        Navigator.pop(context);
                      },
                    ),
                    _FilterChip(
                      label: 'Urgent',
                      color: const Color(0xFFFF6B6B),
                      selected: _selectedFilter == 'Urgent',
                      onTap: () {
                        setState(() => _selectedFilter = 'Urgent');
                        Navigator.pop(context);
                      },
                    ),
                    _FilterChip(
                      label: 'Medium',
                      color: const Color(0xFFFFD600),
                      selected: _selectedFilter == 'Medium',
                      onTap: () {
                        setState(() => _selectedFilter = 'Medium');
                        Navigator.pop(context);
                      },
                    ),
                    _FilterChip(
                      label: 'Regular',
                      color: const Color(0xFF4CAF50),
                      selected: _selectedFilter == 'Regular',
                      onTap: () {
                        setState(() => _selectedFilter = 'Regular');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Requests'),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        foregroundColor: const Color(0xFF0288D1),
        elevation: 0.5,
        centerTitle: true,
        surfaceTintColor: isDarkMode ? Colors.grey[850] : Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF0288D1)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF0288D1)),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredRequests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final req = _filteredRequests[i];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
                    child: Text(req['initials'] as String,
                        style: const TextStyle(
                            color: Color(0xFF0288D1),
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(req['name'] as String,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: (req['statusColor'] as Color)
                                    .withOpacity(0.13),
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
                          style: TextStyle(
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.grey,
                              fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          req['summary'] as String,
                          style: TextStyle(
                              fontSize: 13,
                              color:
                                  isDarkMode ? Colors.grey[200] : Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req['time'] as String,
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey,
                                    fontSize: 12)),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
            color: selected ? Colors.white : (color ?? const Color(0xFF0288D1)),
            fontWeight: FontWeight.w600,
          )),
      selected: selected,
      selectedColor: color ?? const Color(0xFF0288D1),
      backgroundColor: (color ?? const Color(0xFF0288D1)).withOpacity(0.13),
      onSelected: (_) => onTap(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: selected ? 2 : 0,
      pressElevation: 2,
    );
  }
}
