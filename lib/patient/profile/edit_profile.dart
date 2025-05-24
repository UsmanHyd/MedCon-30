import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const EditProfileScreen({super.key, required this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _medicalConditionsController;
  String? _selectedGender;
  bool _isLoading = false;
  final Set<String> _selectedConditions = {};

  // Predefined medical conditions
  final List<Map<String, dynamic>> _commonConditions = [
    {'name': 'Diabetes', 'category': 'Chronic'},
    {'name': 'Hypertension', 'category': 'Chronic'},
    {'name': 'Asthma', 'category': 'Respiratory'},
    {'name': 'Heart Disease', 'category': 'Cardiac'},
    {'name': 'Arthritis', 'category': 'Musculoskeletal'},
    {'name': 'Thyroid Disorder', 'category': 'Endocrine'},
    {'name': 'Anxiety', 'category': 'Mental Health'},
    {'name': 'Depression', 'category': 'Mental Health'},
    {'name': 'Migraine', 'category': 'Neurological'},
    {'name': 'Epilepsy', 'category': 'Neurological'},
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.profileData['fullName']);
    _emailController = TextEditingController(text: widget.profileData['email']);
    _phoneController =
        TextEditingController(text: widget.profileData['phoneNumber']);
    _addressController =
        TextEditingController(text: widget.profileData['address']);
    _dateOfBirthController =
        TextEditingController(text: widget.profileData['dateOfBirth']);
    _medicalConditionsController =
        TextEditingController(text: widget.profileData['additionalConditions']);
    _selectedGender = widget.profileData['gender'];

    // Initialize selected conditions
    if (widget.profileData['medicalConditions'] != null) {
      _selectedConditions.addAll(
          (widget.profileData['medicalConditions'] as String).split(', '));
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _medicalConditionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'dateOfBirth': _dateOfBirthController.text.trim(),
        'gender': _selectedGender,
        'medicalConditions': _selectedConditions.toList(),
        'additionalConditions': _medicalConditionsController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildMedicalConditions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).cardColor
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Conditions',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonConditions.map((condition) {
              final isSelected =
                  _selectedConditions.contains(condition['name']);
              return FilterChip(
                label: Text(condition['name']),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedConditions.add(condition['name']);
                    } else {
                      _selectedConditions.remove(condition['name']);
                    }
                  });
                },
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).cardColor
                    : Colors.white,
                selectedColor: const Color(0xFF0288D1).withOpacity(0.2),
                checkmarkColor: const Color(0xFF0288D1),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF0288D1) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF0288D1)
                        : Colors.grey.shade300,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Additional Conditions',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _medicalConditionsController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter any other medical conditions...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).cardColor
                  : Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xFF0288D1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).cardColor
                                : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFF0288D1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).cardColor
                                : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        prefixIcon:
                            const Icon(Icons.phone, color: Color(0xFF0288D1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).cardColor
                                : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: const Icon(Icons.location_on,
                            color: Color(0xFF0288D1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).cardColor
                                : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: const Icon(Icons.calendar_today,
                            color: Color(0xFF0288D1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).cardColor
                                : Colors.grey.shade50,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Color(0xFF0288D1)),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).cardColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
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
                                    setState(() => _selectedGender = value);
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
                                    setState(() => _selectedGender = value);
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
                    _buildMedicalConditions(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
