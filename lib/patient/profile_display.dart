import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import './edit_profile.dart';

class ProfileDisplayScreen extends StatefulWidget {
  const ProfileDisplayScreen({super.key});

  @override
  State<ProfileDisplayScreen> createState() => _ProfileDisplayScreenState();
}

class _ProfileDisplayScreenState extends State<ProfileDisplayScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? error;
  int? calculatedAge;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  int? _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return null;
    try {
      // Accepts formats like 'dd/MM/yyyy' or 'yyyy-MM-dd'
      DateTime birthDate;
      if (dob.contains('/')) {
        birthDate = DateFormat('dd/MM/yyyy').parse(dob);
      } else {
        birthDate = DateTime.parse(dob);
      }
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          error = 'User not logged in.';
          isLoading = false;
        });
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) {
        setState(() {
          error = 'Profile not found.';
          isLoading = false;
        });
        return;
      }
      final data = doc.data();
      setState(() {
        profileData = data;
        calculatedAge = _calculateAge(data?['dateOfBirth']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load profile: $e';
        isLoading = false;
      });
    }
  }

  Widget _topProfileSectionMobile() {
    if (profileData == null) return const SizedBox();
    final skipKeys = {
      'emergencyContacts',
      'createdAt',
      'updatedAt',
      'uid',
      'lastUpdated',
    };
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: const Color(0xFF0288D1).withOpacity(0.1),
              child: Text(
                (profileData?['fullName'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Color(0xFF0288D1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              profileData?['fullName'] ?? '-',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              profileData?['email'] ?? '-',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            if ((profileData?['phone'] ?? '').toString().isNotEmpty)
              Text(
                profileData?['phone'] ?? '-',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(profileData: profileData!),
                  ),
                );
                if (result == true) {
                  // Refresh profile data if changes were made
                  fetchProfile();
                }
              },
              icon: const Icon(Icons.edit, color: Color(0xFF0288D1)),
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Color(0xFF0288D1)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF0288D1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _infoRowMobile('Sex', profileData?['gender']),
            _infoRowMobile('Date of Birth', profileData?['dateOfBirth'] ?? '-'),
            _infoRowMobile('Age', calculatedAge?.toString() ?? '-'),
            _infoRowMobile('Blood', profileData?['bloodGroup']),
            _infoRowMobile('Status', 'Active'),
            _infoRowMobile('Address', profileData?['address'] ?? '-'),
            _infoRowMobile('Phone', profileData?['phone'] ?? '-'),
            // Show all other fields from the database
            ...profileData!.entries
                .where(
                  (e) =>
                      !skipKeys.contains(e.key) &&
                      e.key != 'fullName' &&
                      e.key != 'email' &&
                      e.key != 'phone' &&
                      e.key != 'gender' &&
                      e.key != 'bloodGroup' &&
                      e.key != 'address' &&
                      e.key != 'dateOfBirth' &&
                      e.key != 'smokes' &&
                      e.key != 'drinks' &&
                      e.key != 'medicalConditions' &&
                      e.key != 'medications' &&
                      e.key != 'pastSurgeries',
                )
                .map(
                  (e) =>
                      _infoRowMobile(_beautifyKey(e.key), e.value?.toString()),
                ),
            _infoRowMobile(
              'Chronic Conditions',
              profileData?['medicalConditions'],
            ),
            _infoRowMobile('Medications', profileData?['medications']),
            _infoRowMobile('Past Surgeries', profileData?['pastSurgeries']),
            _infoRowMobile(
              'Smoker',
              (profileData?['smokes'] == true) ? 'Yes' : 'No',
            ),
            _infoRowMobile(
              'Consumes Alcohol',
              (profileData?['drinks'] == true) ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }

  String _beautifyKey(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .replaceAll('_', ' ')
        .replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase());
  }

  Widget _infoRowMobile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF0288D1),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyContactsSectionMobile() {
    final contacts = profileData?['emergencyContacts'] as List?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
          child: Text(
            'Emergency Contact',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: contacts != null && contacts.isNotEmpty
                ? contacts
                    .map<Widget>(
                      (c) => _vitalCardMobile(
                        title: c['name'] ?? '-',
                        value: c['phone'] ?? '-',
                        subtitle: c['relation'] ?? '-',
                        color: const Color(0xFF0288D1),
                      ),
                    )
                    .toList()
                : [
                    _vitalCardMobile(
                      title: 'No Contacts',
                      value: '',
                      subtitle: '',
                      color: Colors.grey,
                    ),
                  ],
          ),
        ),
      ],
    );
  }

  Widget _vitalCardMobile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 150,
        minWidth: 120,
        minHeight: 90,
        maxHeight: 100,
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _patientHistorySectionMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
          child: Text(
            'Patient History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date Of Visit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Diagnosis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // Placeholder rows
                for (int i = 0; i < 3; i++)
                  const Row(
                    children: [
                      Expanded(child: Text('-')),
                      Expanded(child: Text('-')),
                    ],
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Patient history will appear here in the future.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0288D1)),
            )
          : error != null
              ? Center(
                  child:
                      Text(error!, style: const TextStyle(color: Colors.red)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _topProfileSectionMobile(),
                      const SizedBox(height: 10),
                      _emergencyContactsSectionMobile(),
                      const SizedBox(height: 18),
                      _patientHistorySectionMobile(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}
