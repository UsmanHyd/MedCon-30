import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SosMessagingScreen extends StatefulWidget {
  const SosMessagingScreen({Key? key}) : super(key: key);

  @override
  State<SosMessagingScreen> createState() => _SosMessagingScreenState();
}

class _SosMessagingScreenState extends State<SosMessagingScreen> {
  List<Map<String, dynamic>> _emergencyContacts = [];
  bool _loadingContacts = true;
  String? _contactsError;

  // Location sharing switches
  bool _shareLocation = true;
  bool _locationHistory = false;
  bool _continuousUpdates = true;

  String _emergencyMessage =
      'EMERGENCY! I need help. This is an automated alert sent through the Emergency SOS app.';

  @override
  void initState() {
    super.initState();
    _fetchEmergencyContacts();
  }

  Future<void> _fetchEmergencyContacts() async {
    setState(() {
      _loadingContacts = true;
      _contactsError = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      final contacts = (data?['emergencyContacts'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [];
      setState(() {
        _emergencyContacts = contacts;
        _loadingContacts = false;
      });
    } catch (e) {
      print('Error fetching contacts: $e');
      setState(() {
        _contactsError = 'Failed to load contacts';
        _loadingContacts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0288D1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Emergency SOS Help',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF0288D1)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // SOS Button
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Press for Emergency',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Activates emergency protocol and alerts your contacts',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Emergency Features
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Emergency Features',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // How SOS Works Expansion
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.15),
                  child: const Icon(Icons.info, color: Colors.blue),
                ),
                title: const Text('How SOS Works',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    const Text('Learn about the emergency response system'),
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Text('1',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('Press the SOS Button'),
                    subtitle: const Text(
                        'In an emergency, press and hold the red SOS button for 3 seconds'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Text('2',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('Confirmation'),
                    subtitle: const Text(
                        'Confirm the emergency alert or cancel if pressed by mistake'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Text('3',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('Alert Sent'),
                    subtitle: const Text(
                        'Your emergency contacts will receive your location and alert message'),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Text('4',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    title: const Text('Emergency Services'),
                    subtitle: const Text(
                        'Option to directly call emergency services will appear'),
                  ),
                ],
              ),
            ),
            // Emergency Contacts Expansion
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.15),
                  child: const Icon(Icons.contacts, color: Colors.green),
                ),
                title: const Text('Emergency Contacts',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Manage your emergency contact list'),
                children: [
                  if (_loadingContacts)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_contactsError != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_contactsError!,
                          style: const TextStyle(color: Colors.red)),
                    )
                  else if (_emergencyContacts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No emergency contacts found.'),
                    )
                  else ...[
                    for (final contact in _emergencyContacts)
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(contact['name'] ?? '-',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((contact['relation'] ?? '')
                                  .toString()
                                  .isNotEmpty)
                                Text(contact['relation'] ?? '',
                                    style: const TextStyle(fontSize: 13)),
                              if ((contact['phone'] ?? '')
                                  .toString()
                                  .isNotEmpty)
                                Text(contact['phone'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.blue)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {}, // TODO: Implement edit
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {}, // TODO: Implement delete
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {}, // TODO: Implement add
                          label: const Text('Add Emergency Contact',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Quick Services Expansion
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.15),
                  child: const Icon(Icons.phone_in_talk, color: Colors.orange),
                ),
                title: const Text('Quick Services',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Direct access to emergency numbers'),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _quickServiceCard(
                                icon: Icons.call,
                                color: Colors.red,
                                label: 'Emergency',
                                number: '911',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _quickServiceCard(
                                icon: Icons.local_police,
                                color: Colors.blue,
                                label: 'Police',
                                number: '999',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _quickServiceCard(
                                icon: Icons.local_hospital,
                                color: Colors.green,
                                label: 'Ambulance',
                                number: '998',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _quickServiceCard(
                                icon: Icons.local_fire_department,
                                color: Colors.orange,
                                label: 'Fire Dept',
                                number: '997',
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
            const SizedBox(height: 18),
            // Setup Instructions
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Setup Instructions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Location Sharing Expansion
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.withOpacity(0.15),
                  child: const Icon(Icons.location_on, color: Colors.purple),
                ),
                title: const Text('Location Sharing',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Configure location sharing settings'),
                children: [
                  SwitchListTile(
                    title: const Text('Share Location During Emergency'),
                    subtitle: const Text(
                        'Send your precise location to emergency contacts'),
                    value: _shareLocation,
                    activeColor: Color(0xFF0288D1),
                    onChanged: (val) {
                      setState(() {
                        _shareLocation = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Location History'),
                    subtitle: const Text(
                        'Share recent location history (last 30 minutes)'),
                    value: _locationHistory,
                    activeColor: Color(0xFF0288D1),
                    onChanged: (val) {
                      setState(() {
                        _locationHistory = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Continuous Updates'),
                    subtitle:
                        const Text('Send location updates every 2 minutes'),
                    value: _continuousUpdates,
                    activeColor: Color(0xFF0288D1),
                    onChanged: (val) {
                      setState(() {
                        _continuousUpdates = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Emergency Message Expansion
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.cyan.withOpacity(0.15),
                  child: const Icon(Icons.message, color: Colors.cyan),
                ),
                title: const Text('Emergency Message',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Customize your emergency alert message'),
                children: [
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Message:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(_emergencyMessage,
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03B6E8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final newMsg = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              final controller = TextEditingController(
                                  text: _emergencyMessage);
                              return AlertDialog(
                                title: const Text('Edit Emergency Message'),
                                content: TextField(
                                  controller: controller,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Emergency Message',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, controller.text),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF03B6E8)),
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newMsg != null && newMsg.trim().isNotEmpty) {
                            setState(() {
                              _emergencyMessage = newMsg.trim();
                            });
                          }
                        },
                        label: const Text('Edit Emergency Message',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Safety Tips
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Safety Tips',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _tipCard(
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              title: 'When to Use SOS',
              description:
                  'Only use the SOS feature in genuine emergencies when you need immediate assistance',
            ),
            _tipCard(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: 'Stay Calm',
              description:
                  'Try to remain calm and provide clear information about your situation when possible',
            ),
            _tipCard(
              icon: Icons.cancel,
              iconColor: Colors.red,
              title: 'Avoid False Alarms',
              description:
                  'False alarms can divert resources from real emergencies and cause unnecessary concern',
            ),
            const SizedBox(height: 18),
            // Additional Resources
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Resources',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _resourceButton(
                  icon: Icons.local_hospital,
                  color: Colors.red,
                  label: 'Nearby Hospitals',
                ),
                _resourceButton(
                  icon: Icons.medical_services,
                  color: Colors.green,
                  label: 'First Aid Guide',
                ),
                _resourceButton(
                  icon: Icons.send,
                  color: Colors.orange,
                  label: 'Emergency Plan',
                ),
                _resourceButton(
                  icon: Icons.help_outline,
                  color: Colors.blue,
                  label: 'FAQ',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Test SOS Feature Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0288D1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                label: const Text(
                  'Test SOS Feature',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _tipCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  Widget _resourceButton({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return SizedBox(
      width: 160,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _quickServiceCard({
    required IconData icon,
    required Color color,
    required String label,
    required String number,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.13),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(number,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 16),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
