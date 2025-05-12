import 'package:flutter/material.dart';
import 'package:medcon30/patient/patient_dashboard.dart';
import 'diagnosis.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final List<String> allSymptoms = [
    'Headache',
    'Fever',
    'Cough',
    'Sore Throat',
    'Fatigue',
    'Nausea',
    'Dizziness',
    'Shortness of Breath',
    'Chest Pain',
    'Back Pain',
    'Joint Pain',
    'Rash',
    'Abdominal Pain',
  ];
  List<String> filteredSymptoms = [];
  List<String> selectedSymptoms = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSymptoms = List.from(allSymptoms);
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      filteredSymptoms = allSymptoms
          .where((symptom) => symptom
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  void _removeSymptom(String symptom) {
    setState(() {
      selectedSymptoms.remove(symptom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blueGrey[900]),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Icon(Icons.help_outline, color: Color(0xFF2196F3), size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Enter your symptoms to get potential diagnoses',
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 18),
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xFF2196F3)),
                            hintText: 'Type your symptoms...',
                            hintStyle: TextStyle(color: Colors.blueGrey[300]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE0E3EA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE0E3EA)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 8),
                          ),
                        ),
                        SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: filteredSymptoms.map((symptom) {
                            final isSelected =
                                selectedSymptoms.contains(symptom);
                            return GestureDetector(
                              onTap: () => _toggleSymptom(symptom),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF2196F3)
                                      : Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xFF2196F3)
                                        : Color(0xFFE0E3EA),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  symptom,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.blueGrey[900],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (selectedSymptoms.isNotEmpty) ...[
                          SizedBox(height: 22),
                          Text(
                            'Selected Symptoms:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: selectedSymptoms
                                .map((symptom) => Chip(
                                      label: Text(symptom),
                                      deleteIcon: Icon(Icons.close,
                                          size: 18, color: Color(0xFF2196F3)),
                                      onDeleted: () => _removeSymptom(symptom),
                                      backgroundColor: Color(0xFFE3F2FD),
                                      labelStyle: TextStyle(
                                          color: Color(0xFF2196F3),
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedSymptoms.isNotEmpty
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DiagnosisScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedSymptoms.isNotEmpty
                                  ? Color(0xFF2196F3)
                                  : Color(0xFFB0BEC5),
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Check for Potential Diagnoses',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
