import 'package:flutter/material.dart';
import '/doctor/modules/doctor_dashboard.dart';

class PrescriptionAssistantScreen extends StatefulWidget {
  const PrescriptionAssistantScreen({Key? key}) : super(key: key);

  @override
  State<PrescriptionAssistantScreen> createState() =>
      _PrescriptionAssistantScreenState();
}

class _PrescriptionAssistantScreenState
    extends State<PrescriptionAssistantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommendedMeds = [
      {
        'name': 'Sumatriptan',
        'dose': '100mg tablet',
        'desc':
            'For acute migraine attacks. Take at onset of symptoms. Max 200mg per day.'
      },
      {
        'name': 'Rizatriptan',
        'dose': '10mg tablet',
        'desc':
            'For acute migraine attacks. Take at onset of symptoms. Max 30mg per day.'
      },
      {
        'name': 'Topiramate',
        'dose': '25mg tablet',
        'desc':
            'For migraine prevention. Start with 25mg daily, increase gradually. Max 100mg per day.'
      },
    ];
    final recentlyPrescribed = [
      {
        'name': 'Propranolol',
        'dose': '40mg tablet',
        'desc': 'For migraine prevention and hypertension. Take once daily.'
      },
      {
        'name': 'Metoclopramide',
        'dose': '10mg tablet',
        'desc': 'For nausea associated with migraine. Take as needed.'
      },
      {
        'name': 'Amitriptyline',
        'dose': '25mg tablet',
        'desc': 'For migraine prevention. Take at bedtime.'
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Assistant'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Patient header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child:
                      const Text('HR', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Harper Reynolds',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 2),
                      Text('42 years • Female • Migraine',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrescriptionDraftScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('View Draft'),
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6750A4),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF6750A4),
              tabs: const [
                Tab(text: 'Medicines'),
                Tab(text: 'Lab Tests'),
                Tab(text: 'Guidelines'),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Medicines Tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search medications...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Recommended for Migraine',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    ...recommendedMeds.map((med) => _MedCard(
                          name: med['name']!,
                          dose: med['dose']!,
                          desc: med['desc']!,
                        )),
                    const SizedBox(height: 18),
                    const Text('Recently Prescribed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    ...recentlyPrescribed.map((med) => _MedCard(
                          name: med['name']!,
                          dose: med['dose']!,
                          desc: med['desc']!,
                        )),
                  ],
                ),
                // Lab Tests Tab
                Center(child: Text('Lab Tests (UI to be implemented)')),
                // Guidelines Tab
                Center(child: Text('Guidelines (UI to be implemented)')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6750A4),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline), label: "Patients"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

class _MedCard extends StatelessWidget {
  final String name;
  final String dose;
  final String desc;
  const _MedCard({required this.name, required this.dose, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF7F7FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dose,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 2),
            Text(desc, style: const TextStyle(fontSize: 13)),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF6750A4)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class PrescriptionDraftScreen extends StatelessWidget {
  const PrescriptionDraftScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicines = [
      {
        'name': 'Sumatriptan',
        'dose': '100mg tablet',
        'desc':
            'Take 1 tablet at onset of migraine. May repeat after 2 hours if needed. Maximum 2 tablets per 24 hours.',
        'qty': '6 tablets',
        'refills': '1',
      },
      {
        'name': 'Metoclopramide',
        'dose': '10mg tablet',
        'desc':
            'Take 1 tablet as needed for nausea, up to 3 times per day. Take 30 minutes before meals.',
        'qty': '30 tablets',
        'refills': '2',
      },
      {
        'name': 'Propranolol',
        'dose': '40mg tablet',
        'desc':
            'Take 1 tablet twice daily. Continue current regimen for hypertension and migraine prevention.',
        'qty': '60 tablets',
        'refills': '3',
      },
    ];
    final labTests = [
      {
        'name': 'Complete Blood Count (CBC)',
        'desc': 'Routine monitoring for medication effects',
      },
      {
        'name': 'Basic Metabolic Panel',
        'desc': 'To monitor kidney function and electrolytes',
      },
    ];
    final notes =
        "Patient should avoid triggers such as bright lights, loud noises, and alcohol during migraine episodes. Stay hydrated and maintain regular sleep.";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Draft'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Patient header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink.shade100,
                  child:
                      const Text('HR', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Harper Reynolds',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 2),
                      Text('42 years • Female • Migraine',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Medications
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Medications',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ...medicines.map((med) => _DraftMedItem(
                        name: med['name']!,
                        dose: med['dose']!,
                        desc: med['desc']!,
                        qty: med['qty']!,
                        refills: med['refills']!,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Lab Tests
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lab Tests',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ...labTests.map((test) => _DraftLabItem(
                        name: test['name']!,
                        desc: test['desc']!,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Notes & Instructions
          Card(
            color: const Color(0xFFF7F7FB),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes & Instructions',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(notes, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrescriptionSummaryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Finalize Prescription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Color(0xFFDFDFDF)),
                  ),
                  child: const Text('+ Add More'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DraftMedItem extends StatelessWidget {
  final String name;
  final String dose;
  final String desc;
  final String qty;
  final String refills;
  const _DraftMedItem(
      {required this.name,
      required this.dose,
      required this.desc,
      required this.qty,
      required this.refills});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dose,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Text('Quantity: $qty   Refills: $refills',
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF757575)),
                onPressed: () {},
              ),
              IconButton(
                icon:
                    const Icon(Icons.delete_outline, color: Color(0xFF757575)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DraftLabItem extends StatelessWidget {
  final String name;
  final String desc;
  const _DraftLabItem({required this.name, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF757575)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class PrescriptionSummaryScreen extends StatelessWidget {
  const PrescriptionSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicines = [
      {
        'name': 'Sumatriptan',
        'dose': '100mg tablet',
        'desc':
            'Take 1 tablet at onset of migraine. May repeat after 2 hours if needed. Maximum 2 tablets per 24 hours.',
        'qty': '6 tablets',
        'refills': '1',
      },
      {
        'name': 'Metoclopramide',
        'dose': '10mg tablet',
        'desc':
            'Take 1 tablet as needed for nausea, up to 3 times per day. Take 30 minutes before meals.',
        'qty': '30 tablets',
        'refills': '2',
      },
      {
        'name': 'Propranolol',
        'dose': '40mg tablet',
        'desc':
            'Take 1 tablet twice daily. Continue current regimen for hypertension and migraine prevention.',
        'qty': '60 tablets',
        'refills': '3',
      },
    ];
    final labTests = [
      'Complete Blood Count (CBC)',
      'Basic Metabolic Panel',
    ];
    final instructions =
        "Patient should avoid triggers such as bright lights, loud noises, and alcohol during migraine episodes. Stay hydrated and maintain regular sleep schedule. Schedule follow-up appointment in 2 weeks to assess medication efficacy.";
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('MedCon',
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              color: Color(0xFF6750A4),
                              fontSize: 26)),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('Dr. Sarah Chen',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Neurologist', style: TextStyle(fontSize: 13)),
                          Text('License #: NY12345678',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    children: const [
                      Expanded(
                          child: Text('Patient:\nHarper Reynolds',
                              style: TextStyle(fontSize: 14))),
                      Expanded(
                          child: Text('Date:\nMay 21, 2025',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Expanded(
                          child: Text('DOB:\nMarch 15, 1983',
                              style: TextStyle(fontSize: 14))),
                      Expanded(
                          child: Text('Diagnosis:\nChronic Migraine',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14))),
                    ],
                  ),
                  const Divider(height: 28),
                  const Text('Rx',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...List.generate(medicines.length, (i) {
                    final med = medicines[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}. ${med['name']} ${med['dose']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Sig: ${med['desc']}',
                              style: const TextStyle(fontSize: 13)),
                          Text('Disp: ${med['qty']}',
                              style: const TextStyle(fontSize: 13)),
                          Text('Refills: ${med['refills']}',
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  const Text('Laboratory Tests',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ...labTests.map((test) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Row(
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 16)),
                            Text(test, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  const Text('Special Instructions',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                    child: Text(instructions,
                        style: const TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Electronically signed by',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Row(
                    children: [
                      const Text('Dr. Sarah Chen, MD',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const Spacer(),
                      Image.asset('assets/signature.png',
                          height: 32,
                          width: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 10),
                            Text('Sent to patient'),
                          ],
                        ),
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 6,
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => DoctorDashboard()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send to Patient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Color(0xFFDFDFDF)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
