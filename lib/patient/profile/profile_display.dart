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
import '../../services/cloudinary_service.dart';

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
  bool _showFullscreenCover = false;
  double _dragStartY = 0.0;
  double _fullscreenDragStartY = 0.0;
  double _fullscreenDragDelta = 0.0;

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

  Future<void> _pickAndConfirmImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      final tempImage = File(pickedFile.path);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Profile Picture'),
          content:
              Image.file(tempImage, width: 120, height: 120, fit: BoxFit.cover),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, Save'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final url = await CloudinaryService.uploadImage(tempImage);
          if (url != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'profilePic': url});
            setState(() {
              _profileImage = null;
              if (_profileData != null) {
                _profileData!['profilePic'] = url;
              }
            });
          }
        }
      }
    }
  }

  void _showProfilePictureOptions() {
    if (_profileImage == null) {
      _pickAndConfirmImage();
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
                  _pickAndConfirmImage();
                },
              ),
            ],
          ),
        );
      },
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
    final profileImageUrl = _profileImage != null
        ? _profileImage!.path
        : (_profileData!['profilePic'] ?? null);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    _dragStartY = details.localPosition.dy;
                  },
                  onVerticalDragUpdate: (details) {
                    final dragDistance = details.localPosition.dy - _dragStartY;
                    if (dragDistance > 80 && !_showFullscreenCover) {
                      setState(() {
                        _showFullscreenCover = true;
                      });
                    }
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: Container(
                      height: 260,
                      width: double.infinity,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF23272F)
                          : Colors.blue[50],
                      child: profileImageUrl != null
                          ? Image(
                              image: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : NetworkImage(profileImageUrl)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                              alignment: const Alignment(0, -0.3),
                            )
                          : Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 120,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white24
                                    : Colors.blue[100],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  // Main info card
                  Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23272F)
                        : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _showProfilePictureOptions,
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.white,
                              backgroundImage: profileImageUrl != null
                                  ? (_profileImage != null
                                          ? FileImage(_profileImage!)
                                          : NetworkImage(profileImageUrl))
                                      as ImageProvider
                                  : null,
                              child: profileImageUrl == null
                                  ? const Icon(Icons.account_circle,
                                      size: 48, color: Color(0xFF0288D1))
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _profileData!['name'] ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.lightBlue[200]
                                        : const Color(0xFF2196F3),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _profileData!['email'] ?? 'No Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Personal Information Card
                  Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23272F)
                        : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Information',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.lightBlue[200]
                                      : const Color(0xFF2196F3))),
                          const SizedBox(height: 10),
                          _InfoRow(
                              label: 'Phone Number',
                              value: _profileData!['phoneNumber'] ??
                                  'Not provided'),
                          _InfoRow(
                              label: 'Address',
                              value:
                                  _profileData!['address'] ?? 'Not provided'),
                          _InfoRow(
                              label: 'Date of Birth',
                              value: _profileData!['dateOfBirth'] ??
                                  'Not provided'),
                          if (age != null)
                            _InfoRow(label: 'Age', value: age.toString()),
                          _InfoRow(
                              label: 'Gender',
                              value: _profileData!['gender'] ?? 'Not provided'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Medical Information Card
                  Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF23272F)
                        : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medical Information',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.lightBlue[200]
                                      : const Color(0xFF2196F3))),
                          const SizedBox(height: 10),
                          _MedicalConditionsDisplay(profileData: _profileData),
                        ],
                      ),
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
                                  _profileData!['medicalConditions']
                                          ?.join(', ') ??
                                      '',
                              'additionalConditions':
                                  _profileData!['additionalConditions'] ?? '',
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      minimumSize: const Size(200, 40),
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(200, 40),
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
                ]),
              ),
            ],
          ),
          // Fullscreen cover image overlay
          if (_showFullscreenCover && profileImageUrl != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  _fullscreenDragStartY = details.localPosition.dy;
                  _fullscreenDragDelta = 0.0;
                },
                onVerticalDragUpdate: (details) {
                  _fullscreenDragDelta =
                      details.localPosition.dy - _fullscreenDragStartY;
                },
                onVerticalDragEnd: (_) {
                  if (_fullscreenDragDelta < -60) {
                    setState(() {
                      _showFullscreenCover = false;
                    });
                  }
                },
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4,
                        child: Center(
                          child: Image(
                            image: _profileImage != null
                                ? FileImage(_profileImage!)
                                : NetworkImage(profileImageUrl)
                                    as ImageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 24,
                        right: 24,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _showFullscreenCover = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.lightBlue[100] : Colors.black87;
    final valueColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$label:',
              style: TextStyle(fontWeight: FontWeight.w600, color: labelColor)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(color: valueColor))),
        ],
      ),
    );
  }
}

class _MedicalConditionsDisplay extends StatelessWidget {
  final Map<String, dynamic>? profileData;
  const _MedicalConditionsDisplay({required this.profileData});
  @override
  Widget build(BuildContext context) {
    final conditions =
        profileData?['medicalConditions'] as List<dynamic>? ?? [];
    final additionalConditions =
        profileData?['additionalConditions'] as String? ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (conditions.isNotEmpty) ...[
          Text(
            'Selected Conditions',
            style: TextStyle(
              color: isDark ? Colors.lightBlue[200] : const Color(0xFF2196F3),
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
                  color: isDark ? const Color(0xFF23272F) : Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: Text(
                  condition.toString(),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        if (additionalConditions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Additional Conditions',
            style: TextStyle(
              color: isDark ? Colors.lightBlue[200] : const Color(0xFF2196F3),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23272F) : Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              additionalConditions,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
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
    );
  }
}
