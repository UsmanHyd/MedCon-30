import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'patient_dashboard.dart';
import '../services/firestore_service.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _pastSurgeriesController =
      TextEditingController();

  final List<TextEditingController> _emergencyNameControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _emergencyPhoneControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _emergencyRelationControllers =
      List.generate(3, (_) => TextEditingController());

  String gender = '';
  bool smokes = false;
  bool drinks = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _medicationsController.dispose();
    _pastSurgeriesController.dispose();
    for (int i = 0; i < 3; i++) {
      _emergencyNameControllers[i].dispose();
      _emergencyPhoneControllers[i].dispose();
      _emergencyRelationControllers[i].dispose();
    }
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

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep += 1);
      } else {
        _formKey.currentState!.save();
        _submitForm();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitForm() async {
    try {
      final firestoreService = FirestoreService();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Prepare emergency contacts data
      List<Map<String, String>> emergencyContacts = [];
      for (int i = 0; i < 3; i++) {
        if (_emergencyNameControllers[i].text.isNotEmpty) {
          emergencyContacts.add({
            'name': _emergencyNameControllers[i].text,
            'phone': _emergencyPhoneControllers[i].text,
            'relation': _emergencyRelationControllers[i].text,
          });
        }
      }

      // Prepare profile data
      final profileData = {
        'fullName': _fullNameController.text,
        'dateOfBirth': _dobController.text,
        'email': currentUser.email,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'gender': gender,
        'bloodGroup': _bloodGroupController.text,
        'allergies': _allergiesController.text,
        'medicalConditions': _conditionsController.text,
        'medications': _medicationsController.text,
        'pastSurgeries': _pastSurgeriesController.text,
        'smokes': smokes,
        'drinks': drinks,
        'emergencyContacts': emergencyContacts,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save profile data
      await firestoreService.saveUserProfile(profileData: profileData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully!')),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating profile: $e')));
    }
  }

  Widget _buildStepIndicator() {
    List<String> labels = [
      'Personal Info',
      'Health Info',
      'Emergency Contacts',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              bool isCompleted = index < _currentStep;
              bool isCurrent = index == _currentStep;

              return Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent
                          ? const Color(0xFF0288D1)
                          : isCompleted
                              ? Colors.green
                              : Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                          color: isCurrent
                              ? const Color(0xFF0288D1).withOpacity(0.3)
                              : Colors.transparent,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent || isCompleted
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  if (index != 2)
                    Container(
                      width: 60,
                      height: 2,
                      color: isCompleted ? Colors.green : Colors.grey.shade200,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              bool isCurrent = index == _currentStep;
              return Text(
                labels[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? const Color(0xFF0288D1) : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    bool isRequired = true,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF0288D1)),
          hintText: 'Enter your $label',
          filled: true,
          fillColor: Colors.grey.shade50,
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
            borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: isRequired ? (v) => v!.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        _buildFormField(controller: _fullNameController, label: 'Full Name'),
        _buildFormField(
          controller: _dobController,
          label: 'Date of Birth',
          onTap: _pickDateOfBirth,
          readOnly: true,
        ),
        _buildFormField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
        _buildFormField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        _buildFormField(controller: _addressController, label: 'Address'),
        const SizedBox(height: 16),
        // Gender Selection
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                color: Color(0xFF0288D1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                    activeColor: const Color(0xFF0288D1),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                    activeColor: const Color(0xFF0288D1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0288D1)),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_currentStep == 0) ...[_buildPersonalInfoStep()],
                      if (_currentStep == 1) ...[
                        _buildFormField(
                          controller: _bloodGroupController,
                          label: 'Blood Group',
                        ),
                        _buildFormField(
                          controller: _allergiesController,
                          label: 'Allergies',
                        ),
                        _buildFormField(
                          controller: _conditionsController,
                          label: 'Chronic Conditions',
                        ),
                        _buildFormField(
                          controller: _medicationsController,
                          label: 'Current Medications',
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text(
                                  'Smoker',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: smokes,
                                onChanged: (v) => setState(() => smokes = v),
                                activeColor: const Color(0xFF0288D1),
                              ),
                              SwitchListTile(
                                title: const Text(
                                  'Consumes Alcohol',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: drinks,
                                onChanged: (v) => setState(() => drinks = v),
                                activeColor: const Color(0xFF0288D1),
                              ),
                            ],
                          ),
                        ),
                        _buildFormField(
                          controller: _pastSurgeriesController,
                          label: 'Past Surgeries or Illnesses',
                        ),
                      ],
                      if (_currentStep == 2) ...[
                        for (int i = 0; i < 3; i++) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Emergency Contact ${i + 1}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        controller:
                                            _emergencyNameControllers[i],
                                        label: 'Name',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        controller:
                                            _emergencyRelationControllers[i],
                                        label: 'Relation',
                                      ),
                                    ),
                                  ],
                                ),
                                _buildFormField(
                                  controller: _emergencyPhoneControllers[i],
                                  label: 'Phone',
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            ElevatedButton(
                              onPressed: _prevStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Back'),
                            ),
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
