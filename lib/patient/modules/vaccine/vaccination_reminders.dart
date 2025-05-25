import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medcon30/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';

class VaccinationReminder extends StatefulWidget {
  const VaccinationReminder({Key? key}) : super(key: key);

  @override
  State<VaccinationReminder> createState() => _VaccinationReminderState();
}

class _VaccinationReminderState extends State<VaccinationReminder> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _updateExistingReminders();
  }

  Future<void> _updateExistingReminders() async {
    try {
      await _firestoreService.updateExistingVaccinationReminders();
    } catch (e) {
      print('Error updating existing reminders: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating reminders: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Missed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddVaccinationDialog(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey;
    final borderColor =
        isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200;

    final formKey = GlobalKey<FormState>();
    String name = '';
    String dateGiven = '';
    String nextDoseDate = '';
    String notes = '';
    TimeOfDay reminderTime = TimeOfDay.now();

    Future<void> pickDate(
        BuildContext context, Function(String) onPicked) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        onPicked(picked.toIso8601String().substring(0, 10));
      }
    }

    Future<void> pickTime(BuildContext context) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: reminderTime,
      );
      if (picked != null) {
        setState(() {
          reminderTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add New Vaccination',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textColor)),
                    const SizedBox(height: 20),
                    Text('Vaccine Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    TextFormField(
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Enter vaccine name',
                        hintStyle: TextStyle(color: subTextColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF7B61FF))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter vaccine name'
                          : null,
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    Text('Date Given',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(text: dateGiven),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          onTap: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              size: 20, color: subTextColor),
                          onPressed: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Next Dose Date *',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(text: nextDoseDate),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Next dose date is required'
                              : null,
                          onTap: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              size: 20, color: subTextColor),
                          onPressed: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Reminder Time *',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(
                            text: reminderTime.format(context),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Select reminder time',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Reminder time is required'
                              : null,
                          onTap: () => pickTime(context),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time,
                              size: 20, color: subTextColor),
                          onPressed: () => pickTime(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Setting reminder is required for tracking',
                      style: TextStyle(
                          fontSize: 12, color: const Color(0xFF7B61FF)),
                    ),
                    const SizedBox(height: 16),
                    Text('Notes',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    TextFormField(
                      style: TextStyle(color: textColor),
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Add any additional notes',
                        hintStyle: TextStyle(color: subTextColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF7B61FF))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      onChanged: (value) => notes = value,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(color: borderColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textColor)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B61FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  print(
                                      'Debug - Current user when adding reminder: ${currentUser?.uid}');

                                  final reminderData = {
                                    'name': name,
                                    'dates': [dateGiven, nextDoseDate],
                                    'status': 'Pending',
                                    'notes': notes,
                                    'userId': currentUser?.uid,
                                    'reminderTime':
                                        '${reminderTime.hour}:${reminderTime.minute}',
                                  };
                                  print(
                                      'Debug - Reminder data being sent: $reminderData');

                                  await FirestoreService()
                                      .addVaccinationReminder(reminderData);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Vaccination reminder added successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditVaccinationDialog(
      BuildContext context, Map<String, dynamic> rec) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey;
    final borderColor =
        isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200;

    final formKey = GlobalKey<FormState>();
    String name = rec['name'] ?? '';
    String dateGiven = (rec['dates'] != null && rec['dates'].isNotEmpty)
        ? rec['dates'][0]
        : '';
    String nextDoseDate = (rec['dates'] != null && rec['dates'].length > 1)
        ? rec['dates'][1]
        : '';
    String notes = rec['notes'] ?? '';
    String status = rec['status'] ?? 'Pending';
    TimeOfDay reminderTime = TimeOfDay.now();
    if (rec['reminderTime'] != null) {
      final timeParts = rec['reminderTime'].split(':');
      reminderTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    Future<void> pickDate(
        BuildContext context, Function(String) onPicked, String initial) async {
      final picked = await showDatePicker(
        context: context,
        initialDate:
            initial.isNotEmpty ? DateTime.parse(initial) : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        onPicked(picked.toIso8601String().substring(0, 10));
      }
    }

    Future<void> pickTime(BuildContext context) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: reminderTime,
      );
      if (picked != null) {
        setState(() {
          reminderTime = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Vaccination',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textColor)),
                    const SizedBox(height: 20),
                    Text('Vaccine Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: name,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Enter vaccine name',
                        hintStyle: TextStyle(color: subTextColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF7B61FF))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter vaccine name'
                          : null,
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    Text('Date Given',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(text: dateGiven),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          onTap: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }, dateGiven),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              size: 20, color: subTextColor),
                          onPressed: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }, dateGiven),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Next Dose Date *',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(text: nextDoseDate),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Next dose date is required'
                              : null,
                          onTap: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }, nextDoseDate),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today,
                              size: 20, color: subTextColor),
                          onPressed: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }, nextDoseDate),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Reminder Time *',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          style: TextStyle(color: textColor),
                          readOnly: true,
                          controller: TextEditingController(
                            text: reminderTime.format(context),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Select reminder time',
                            hintStyle: TextStyle(color: subTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: borderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFF7B61FF))),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Reminder time is required'
                              : null,
                          onTap: () => pickTime(context),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time,
                              size: 20, color: subTextColor),
                          onPressed: () => pickTime(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Setting reminder is required for tracking',
                      style: TextStyle(
                          fontSize: 12, color: const Color(0xFF7B61FF)),
                    ),
                    const SizedBox(height: 16),
                    Text('Notes',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: notes,
                      style: TextStyle(color: textColor),
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Add any additional notes',
                        hintStyle: TextStyle(color: subTextColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: borderColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF7B61FF))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                      onChanged: (value) => notes = value,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(color: borderColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textColor)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B61FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await FirestoreService()
                                    .updateVaccinationReminder(
                                  rec['id'],
                                  {
                                    'name': name,
                                    'dates': [dateGiven, nextDoseDate],
                                    'status': status,
                                    'notes': notes,
                                    'reminderTime':
                                        '${reminderTime.hour}:${reminderTime.minute}',
                                  },
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVaccinationDetailsDialog(
      BuildContext context, Map<String, dynamic> rec) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey;
    final borderColor =
        isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('Vaccination Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: textColor)),
                ),
                const SizedBox(height: 18),
                Text('Vaccine Name',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Text(rec['name'] ?? '',
                    style: TextStyle(fontSize: 15, color: textColor)),
                const SizedBox(height: 10),
                Text('Date Given',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Text(
                    (rec['dates'] != null && rec['dates'].isNotEmpty)
                        ? rec['dates'][0]
                        : '',
                    style: TextStyle(fontSize: 15, color: textColor)),
                const SizedBox(height: 10),
                Text('Next Dose Date',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Text(
                    (rec['dates'] != null && rec['dates'].length > 1)
                        ? rec['dates'][1]
                        : '-',
                    style: TextStyle(fontSize: 15, color: textColor)),
                const SizedBox(height: 10),
                Text('Reminder Time',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Text(rec['reminderTime'] ?? '-',
                    style: TextStyle(fontSize: 15, color: textColor)),
                const SizedBox(height: 10),
                Text('Status',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor(rec['status'] ?? ''),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rec['status'] ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Notes',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: textColor)),
                Text(rec['notes'] ?? '-',
                    style: TextStyle(fontSize: 15, color: textColor)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          try {
                            await FirestoreService().updateVaccinationReminder(
                              rec['id'],
                              {
                                'status': 'Completed',
                              },
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Vaccination marked as completed'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Mark as Completed',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          try {
                            await FirestoreService().updateVaccinationReminder(
                              rec['id'],
                              {
                                'status': 'Missed',
                              },
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vaccination marked as missed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Missed',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B61FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Edit',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showEditVaccinationDialog(context, rec);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: borderColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: textColor)),
                      ),
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
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey;
    final borderColor =
        isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination Reminder',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      backgroundColor: bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B61FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _showAddVaccinationDialog(context),
                    child: const Text(
                      "+ Add New Vaccination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your Vaccination Records",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('vaccination_reminders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF7B61FF),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No vaccination records found.',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }
                final records = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: records.length,
                  itemBuilder: (context, idx) {
                    final rec = records[idx].data() as Map<String, dynamic>;
                    rec['id'] = records[idx].id;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showVaccinationDetailsDialog(context, rec),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: borderColor),
                        ),
                        color: cardColor,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec["name"] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (rec["dates"] != null)
                                      ...List.generate(
                                        (rec["dates"] as List).length,
                                        (i) => Text(
                                          "• ${rec["dates"][i]}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: subTextColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor(rec["status"] ?? ''),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  rec["status"] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ℹ️ How to Use Vaccination Records",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Keep track of your immunization history and upcoming vaccination schedules. Tap on any record to view details or make updates.",
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
                const SizedBox(height: 6),
                Text(
                  "• Green badge indicates completed vaccinations",
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
                Text(
                  "• Yellow badge shows pending vaccinations",
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
                Text(
                  "• Red badge indicates missed appointments",
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
