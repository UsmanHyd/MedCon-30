import 'package:flutter/material.dart';
import '../../profile/patient_dashboard.dart';
import 'package:medcon30/patient/modules/nutrition/plan.dart';

class NutritionFitnessScreen extends StatelessWidget {
  const NutritionFitnessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0288D1)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Nutrition & Fitness',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Row
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, Sarah!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        SizedBox(height: 2),
                        Text("Let's achieve your goals today",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/44.jpg'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Progress Card
              _ProgressCard(),
              const SizedBox(height: 18),
              // Schedule
              _ScheduleCard(),
              const SizedBox(height: 18),
              // Quick Actions
              const Text('Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _QuickActionsGrid(),
              const SizedBox(height: 18),
              // Recent Activities
              const Text('Recent Activities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _RecentActivities(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F8CFF), Color(0xFF7B61FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Today\'s Progress',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: const Icon(Icons.emoji_events,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('75%',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32)),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ProgressStat(label: 'Calories', value: '1,200/1,800'),
              _ProgressStat(label: 'Steps', value: '8.5k/10k'),
              _ProgressStat(label: 'Water', value: '6/8 cups'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProgressStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFF4F8CFF)),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next up in 30 mins',
                    style: TextStyle(color: Colors.green, fontSize: 13)),
                SizedBox(height: 2),
                Text('Morning Workout',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 2),
                Text('30 min cardio session',
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F8CFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _QuickActionCard(
          color: const Color(0xFFFFE5E5),
          icon: Icons.favorite_border,
          title: 'Health Info',
          subtitle: 'Update metrics',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HealthInformationScreen()),
            );
          },
        ),
        _QuickActionCard(
          color: const Color(0xFFE5FFF3),
          icon: Icons.restaurant_menu,
          title: 'View Plan',
          subtitle: 'View & track',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlanScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _QuickActionCard(
      {required this.color,
      required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black54, size: 28),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class HealthInformationScreen extends StatelessWidget {
  const HealthInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0288D1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Health Information',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar and step
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF4F8CFF),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 10),
                const Text('1/2',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Personal Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Age',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your age',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Weight (kg)',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Weight',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Height (cm)',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Height',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Medical History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Medical Conditions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'List any medical conditions or allergies',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            const Text('Dietary Preferences',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Vegetarian'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Vegan'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Gluten-Free'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Dairy-Free'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetYourGoalsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2056F7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save & Continue',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit Later',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetYourGoalsScreen extends StatefulWidget {
  const SetYourGoalsScreen({Key? key}) : super(key: key);

  @override
  State<SetYourGoalsScreen> createState() => _SetYourGoalsScreenState();
}

class _SetYourGoalsScreenState extends State<SetYourGoalsScreen> {
  int selectedGoal = 0;
  int programWeeks = 8;
  final List<String> goals = ['Weight Loss', 'Muscle Gain', 'Healthy Eating'];
  final List<IconData> goalIcons = [
    Icons.fitness_center,
    Icons.add_box,
    Icons.restaurant_menu
  ];
  final DateTime startDate = DateTime(2025, 5, 10);
  final DateTime endDate = DateTime(2025, 7, 5);
  final TextEditingController targetWeightController = TextEditingController();
  final TextEditingController calorieTargetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0288D1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set Your Goals',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar and step
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF4F8CFF),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 10),
                const Text('2/2',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 18),
            const Text("What's your primary goal?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                goals.length,
                (i) => _GoalOption(
                  icon: goalIcons[i],
                  label: goals[i],
                  selected: selectedGoal == i,
                  onTap: () => setState(() => selectedGoal = i),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Timeline',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Text('Program Duration',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (programWeeks > 1) programWeeks--;
                      });
                    },
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6FD),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text('$programWeeks weeks',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        programWeeks++;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Start Date',
                    style: TextStyle(color: Colors.black54)),
                Text(_formatDate(startDate),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End Date', style: TextStyle(color: Colors.black54)),
                Text(_formatDate(endDate),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Target Metrics',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Target Weight (kg)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: targetWeightController,
              decoration: InputDecoration(
                hintText: 'Enter target weight',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text('Daily Calorie Target',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextField(
              controller: calorieTargetController,
              decoration: InputDecoration(
                hintText: 'Enter daily calorie target',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PlanScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2056F7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Generate My Plan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}

class _GoalOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GoalOption(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2056F7).withOpacity(0.08)
                : Colors.white,
            border: Border.all(
                color:
                    selected ? const Color(0xFF2056F7) : Colors.grey.shade300,
                width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF2056F7)
                      : const Color(0xFFF3F6FD),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon,
                    color: selected ? Colors.white : const Color(0xFF2056F7),
                    size: 28),
              ),
              const SizedBox(height: 10),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? const Color(0xFF2056F7) : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ActivityTile(
          icon: Icons.directions_run_rounded,
          color: Color(0xFF4F8CFF),
          title: 'Completed Morning Workout',
          subtitle: 'Today, 7:30 AM • 350 kcal burned',
        ),
        SizedBox(height: 8),
        _ActivityTile(
          icon: Icons.restaurant,
          color: Color(0xFF7B61FF),
          title: 'Logged Breakfast',
          subtitle: 'Today, 8:15 AM • 420 kcal',
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _ActivityTile(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
