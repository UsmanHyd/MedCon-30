import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../modules/doctor_dashboard.dart';

class DoctorProfileDisplayScreen extends StatefulWidget {
  const DoctorProfileDisplayScreen({super.key});

  @override
  State<DoctorProfileDisplayScreen> createState() =>
      _DoctorProfileDisplayScreenState();
}

class _DoctorProfileDisplayScreenState
    extends State<DoctorProfileDisplayScreen> {
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
          .collection('doctors')
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0288D1),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_profileData == null) {
      return const Center(child: Text('No profile data found'));
    }
    // Defensive: ensure education and experience are always lists
    if (_profileData!['education'] is! List) {
      _profileData!['education'] = <Map<String, dynamic>>[];
    }
    if (_profileData!['experience'] is! List) {
      _profileData!['experience'] = <Map<String, dynamic>>[];
    }
    final age = _calculateAge(_profileData!['dateOfBirth'] ?? '');
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileImage(),
            const SizedBox(height: 24),
            // Personal Information Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Personal Information'),
                  _buildInfoRow(
                    label: 'Name',
                    value: _profileData!['name'] ?? 'Not provided',
                  ),
                  _buildInfoRow(
                    label: 'Email',
                    value: _profileData!['email'] ?? 'Not provided',
                  ),
                  _buildInfoRow(
                    label: 'Phone Number',
                    value: _profileData!['phoneNumber'] ?? 'Not provided',
                  ),
                  _buildInfoRow(
                    label: 'Date of Birth',
                    value: _profileData!['dateOfBirth'] ?? 'Not provided',
                  ),
                  if (age != null)
                    _buildInfoRow(
                      label: 'Age',
                      value: age.toString(),
                    ),
                  _buildInfoRow(
                    label: 'Gender',
                    value: _profileData!['gender'] ?? 'Not provided',
                  ),
                ],
              ),
            ),
            // Doctor Description Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Doctor Description'),
                  Text(
                    _profileData!['description'] != null &&
                            (_profileData!['description'] as String)
                                .trim()
                                .isNotEmpty
                        ? _profileData!['description']
                        : 'Not provided',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Professional Information Card with 3 sub-boxes
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Professional Information'),
                  // License & Specializations sub-box
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.12)
                              : Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('License & Specializations',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0288D1))),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          label: 'License Number',
                          value:
                              _profileData!['licenseNumber'] ?? 'Not provided',
                        ),
                        _buildInfoRow(
                          label: 'Specializations',
                          value: (_profileData!['specializations'] is List &&
                                  (_profileData!['specializations'] as List)
                                      .isNotEmpty)
                              ? (_profileData!['specializations'] as List)
                                  .join(', ')
                              : 'Not provided',
                        ),
                      ],
                    ),
                  ),
                  // Education sub-box
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.12)
                              : Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Education',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0288D1))),
                        const SizedBox(height: 8),
                        if ((_profileData!['education'] as List).isEmpty)
                          _buildInfoRow(label: '', value: 'Not provided'),
                        ...(_profileData!['education'] as List)
                            .map<Widget>((e) {
                          final degree = e['degree'] ?? '';
                          final institute = e['institute'] ?? '';
                          final start = e['startDate'] ?? '';
                          final end = e['endDate'] ?? '';
                          final tenure = (start.isNotEmpty && end.isNotEmpty)
                              ? '$start - $end'
                              : '';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  degree.isNotEmpty ? degree : 'Degree',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                if (institute.isNotEmpty)
                                  Text(institute,
                                      style: const TextStyle(fontSize: 15)),
                                if (tenure.isNotEmpty)
                                  Text(tenure,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  // Experience sub-box
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.12)
                              : Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Experience',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0288D1))),
                        const SizedBox(height: 8),
                        if ((_profileData!['experience'] as List).isEmpty)
                          _buildInfoRow(label: '', value: 'Not provided'),
                        ...(_profileData!['experience'] as List)
                            .map<Widget>((e) {
                          final role = e['role'] ?? '';
                          final location = e['location'] ?? '';
                          final start = e['startDate'] ?? '';
                          final end = e['endDate'] ?? '';
                          final tenure = (start.isNotEmpty && end.isNotEmpty)
                              ? '$start - $end'
                              : '';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  role.isNotEmpty ? role : 'Role',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                if (location.isNotEmpty)
                                  Text(location,
                                      style: const TextStyle(fontSize: 15)),
                                if (tenure.isNotEmpty)
                                  Text(tenure,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorEditProfileScreen(
                      profileData: _profileData!,
                    ),
                  ),
                ).then((_) => _loadProfileData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
