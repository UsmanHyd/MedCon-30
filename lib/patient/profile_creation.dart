import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_dashboard.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  String _selectedGender = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _bloodGroupController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      final formatted =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      setState(() {
        _dobController.text = formatted;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profileData = {
        'fullName': _fullNameController.text,
        'dateOfBirth': _dobController.text,
        'phone': _phoneController.text,
        'gender': _selectedGender,
        'bloodGroup': _bloodGroupController.text,
        'email': user.email,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(profileData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Picture Placeholder
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF0288D1).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Full Name
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0288D1), width: 2),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Date of Birth
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: _pickDateOfBirth,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0288D1), width: 2),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today,
                          color: Color(0xFF0288D1)),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Phone Number
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0288D1), width: 2),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Gender Selection
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              color: Color(0xFF0288D1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Male'),
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value!);
                                },
                                activeColor: const Color(0xFF0288D1),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Female'),
                                value: 'Female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value!);
                                },
                                activeColor: const Color(0xFF0288D1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Blood Group
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: InputDecoration(
                      labelText: 'Blood Group',
                      labelStyle: const TextStyle(color: Color(0xFF0288D1)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0288D1), width: 2),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 32),
                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0288D1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Profile',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
