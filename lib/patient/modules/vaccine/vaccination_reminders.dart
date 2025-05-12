import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medcon30/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final formKey = GlobalKey<FormState>();
    String name = '';
    String dateGiven = '';
    String nextDoseDate = '';
    String notes = '';

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

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    const Text('Add New Vaccination',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 20),
                    const Text('Vaccine Name',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter vaccine name',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter vaccine name'
                          : null,
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Date Given',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: dateGiven),
                          decoration: const InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          onTap: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              size: 20, color: Colors.blueGrey),
                          onPressed: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Next Dose Date *',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: nextDoseDate),
                          decoration: const InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(
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
                          icon: const Icon(Icons.calendar_today,
                              size: 20, color: Colors.blueGrey),
                          onPressed: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Setting reminder is required for tracking',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const SizedBox(height: 16),
                    const Text('Notes',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add any additional notes',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
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
                                  };
                                  print(
                                      'Debug - Reminder data being sent: $reminderData');

                                  await FirestoreService()
                                      .addVaccinationReminder(reminderData);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Vaccination reminder added successfully'),
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
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                    const Text('Edit Vaccination',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 20),
                    const Text('Vaccine Name',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        hintText: 'Enter vaccine name',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter vaccine name'
                          : null,
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    const Text('Date Given',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: dateGiven),
                          decoration: const InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          onTap: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }, dateGiven),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              size: 20, color: Colors.blueGrey),
                          onPressed: () => pickDate(context, (val) {
                            dateGiven = val;
                            (context as Element).markNeedsBuild();
                          }, dateGiven),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Next Dose Date *',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(text: nextDoseDate),
                          decoration: const InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            contentPadding: EdgeInsets.symmetric(
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
                          icon: const Icon(Icons.calendar_today,
                              size: 20, color: Colors.blueGrey),
                          onPressed: () => pickDate(context, (val) {
                            nextDoseDate = val;
                            (context as Element).markNeedsBuild();
                          }, nextDoseDate),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Setting reminder is required for tracking',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const SizedBox(height: 16),
                    const Text('Notes',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: notes,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add any additional notes',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
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
                                  },
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('Vaccination Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(height: 18),
                const Text('Vaccine Name',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(rec['name'] ?? '', style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                const Text('Date Given',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                    (rec['dates'] != null && rec['dates'].isNotEmpty)
                        ? rec['dates'][0]
                        : '',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                const Text('Next Dose Date',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                    (rec['dates'] != null && rec['dates'].length > 1)
                        ? rec['dates'][1]
                        : '-',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                const Text('Notes',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(rec['notes'] ?? '—', style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                const Text('Status',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: statusColor(rec['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rec['status'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(height: 18),
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
                        child: const Text('Completed',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
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
                          backgroundColor: Colors.blue[400],
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
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Delete',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          await FirestoreService()
                              .deleteVaccinationReminder(rec['id']);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close',
                            style: TextStyle(fontWeight: FontWeight.w500)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccination Reminder',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
                      backgroundColor: Colors.lightBlue[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _showAddVaccinationDialog(context),
                    child: const Text(
                      "+ Add New Vaccination",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your Vaccination Records",
                  style: TextStyle(fontWeight: FontWeight.w600),
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No vaccination records found.'),
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
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    if (rec["dates"] != null)
                                      ...List.generate(
                                        (rec["dates"] as List).length,
                                        (i) => Text(
                                          "• ${rec["dates"][i]}",
                                          style: const TextStyle(
                                              fontSize: 13, color: Colors.grey),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ℹ️ How to Use Vaccination Records",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Keep track of your immunization history and upcoming vaccination schedules. Tap on any record to view details or make updates.",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 6),
                  Text("• Green badge indicates completed vaccinations",
                      style: TextStyle(fontSize: 13)),
                  Text("• Yellow badge shows pending vaccinations",
                      style: TextStyle(fontSize: 13)),
                  Text("• Red badge indicates missed appointments",
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
