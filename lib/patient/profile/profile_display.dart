import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_creation.dart';
import '../../services/auth_service.dart';
import 'patient_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_dashboard.dart';

class ProfileDisplayScreen extends StatefulWidget {
  const ProfileDisplayScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDisplayScreen> createState() => _ProfileDisplayScreenState();
}

class _ProfileDisplayScreenState extends State<ProfileDisplayScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _profileData = doc.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _profileData = null;
      });
    }
  }

  int? _calculateAge(String dob) {
    try {
      if (dob.isEmpty) return null;
      final parts = dob.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showProfilePictureOptions() {
    if (_profileImage == null) {
      _pickImage();
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Profile Picture'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_profileImage!),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Profile Picture',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  setState(() {
                    _profileImage = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_a_photo),
                title: const Text('Add New Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showProfilePictureOptions,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : const Color(0xFFE3F2FD),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]!
                : const Color(0xFF0288D1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _profileImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.file(
                  _profileImage!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_a_photo,
                    size: 40,
                    color: Color(0xFF0288D1),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      color: Color(0xFF0288D1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).cardColor
                : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).iconTheme.color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalConditionsDisplay() {
    final conditions =
        _profileData?['medicalConditions'] as List<dynamic>? ?? [];
    final additionalConditions =
        _profileData?['additionalConditions'] as String? ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conditions.isNotEmpty) ...[
            const Text(
              'Selected Conditions',
              style: TextStyle(
                color: Color(0xFF0288D1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: conditions.map((condition) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).cardColor
                        : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Text(
                    condition.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ],
          if (additionalConditions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Additional Conditions',
              style: TextStyle(
                color: Color(0xFF0288D1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).cardColor
                    : const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Text(
                additionalConditions,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          if (conditions.isEmpty && additionalConditions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No medical conditions recorded',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_profileData == null) {
      return const Center(child: Text('No profile data found'));
    }
    final age = _calculateAge(_profileData!['dateOfBirth'] ?? '');
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color(0xFFE3F2FD),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 24),
              Text(
                _profileData!['name'] ?? 'No Name',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0288D1),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _profileData!['email'] ?? 'No Email',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).cardColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Phone Number',
                      value: _profileData!['phoneNumber'] ?? 'Not provided',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: _profileData!['address'] ?? 'Not provided',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Date of Birth',
                      value: _profileData!['dateOfBirth'] ?? 'Not provided',
                    ),
                    if (age != null) ...[
                      const Divider(height: 24),
                      _buildInfoRow(
                        icon: Icons.cake,
                        label: 'Age',
                        value: age.toString(),
                      ),
                    ],
                    const Divider(height: 24),
                    _buildInfoRow(
                      icon: Icons.person,
                      label: 'Gender',
                      value: _profileData!['gender'] ?? 'Not provided',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).cardColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMedicalConditionsDisplay(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        profileData: {
                          'fullName': _profileData!['name'],
                          'email': _profileData!['email'],
                          'phoneNumber': _profileData!['phoneNumber'],
                          'address': _profileData!['address'],
                          'dateOfBirth': _profileData!['dateOfBirth'],
                          'gender': _profileData!['gender'],
                          'medicalConditions':
                              _profileData!['medicalConditions'].join(', '),
                          'additionalConditions':
                              _profileData!['additionalConditions'],
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[850]
                          : const Color(0xFF0288D1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await AuthService().signOut(context);
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const PatientLoginScreen()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error signing out: $e')),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
