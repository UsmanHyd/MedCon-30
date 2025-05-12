import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'stress_detailed_insights.dart';
import 'package:fl_chart/fl_chart.dart';

class StressTrackScreen extends StatelessWidget {
  const StressTrackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Track'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Progress
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 8.0,
                        percent: 0.75,
                        center: const Text('75%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        progressColor: Colors.indigo,
                        backgroundColor: Colors.indigo.shade50,
                      ),
                      const SizedBox(width: 24),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Overall Progress',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _StatColumn(label: 'Time Spent', value: '12.5h'),
                              SizedBox(width: 16),
                              _StatColumn(label: 'Streak', value: '8 days'),
                              SizedBox(width: 16),
                              _StatColumn(label: 'Badges', value: '12'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Weekly Activity
              const Text('Weekly Activity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: SizedBox(
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 50,
                        minY: 0,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 28),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final days = [
                                  'Apr 25',
                                  'Apr 27',
                                  'Apr 29',
                                  'May 1'
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    days[value.toInt() % 4],
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                );
                              },
                              reservedSize: 28,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(x: 0, barsSpace: 4, barRods: [
                            BarChartRodData(
                                toY: 20,
                                color: Colors.blue,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 30,
                                color: Colors.indigo,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 50,
                                color: Colors.amber,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                          ]),
                          BarChartGroupData(x: 1, barsSpace: 4, barRods: [
                            BarChartRodData(
                                toY: 22,
                                color: Colors.blue,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 28,
                                color: Colors.indigo,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 48,
                                color: Colors.amber,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                          ]),
                          BarChartGroupData(x: 2, barsSpace: 4, barRods: [
                            BarChartRodData(
                                toY: 12,
                                color: Colors.blue,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 20,
                                color: Colors.indigo,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 28,
                                color: Colors.amber,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                          ]),
                          BarChartGroupData(x: 3, barsSpace: 4, barRods: [
                            BarChartRodData(
                                toY: 18,
                                color: Colors.blue,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 22,
                                color: Colors.indigo,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                            BarChartRodData(
                                toY: 40,
                                color: Colors.amber,
                                width: 10,
                                borderRadius: BorderRadius.circular(4)),
                          ]),
                        ],
                        gridData: const FlGridData(
                            show: true, drawVerticalLine: false),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Category Progress
              const Text('Category Progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _CategoryProgress(),
              const SizedBox(height: 16),
              // Recent Activity
              const Text('Recent Activity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _RecentActivity(),
              const SizedBox(height: 16),
              // Achievements
              const Text('Achievements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _Achievements(),
              const SizedBox(height: 16),
              // Insights
              const Text('Insights',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _Insights(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _CategoryTile(
          icon: Icons.spa_rounded,
          color: Colors.blue,
          title: 'Breathing Exercises',
          percent: 0.75,
          lastSession: 'Deep Breathing, 15 min (May 1, 2025)',
        ),
        _CategoryTile(
          icon: Icons.self_improvement_rounded,
          color: Colors.purple,
          title: 'Meditation',
          percent: 0.5,
          lastSession: 'Guided Meditation, 20 min (Apr 30, 2025)',
        ),
        _CategoryTile(
          icon: Icons.directions_run_rounded,
          color: Colors.green,
          title: 'Physical Activities',
          percent: 0.6,
          lastSession: 'Stretching, 10 min (Apr 29, 2025)',
        ),
        _CategoryTile(
          icon: Icons.nightlight_round,
          color: Colors.indigo,
          title: 'Sleep Improvement',
          percent: 0.2,
          lastSession: 'Bedtime Routine, 15 min (Apr 28, 2025)',
        ),
        _CategoryTile(
          icon: Icons.psychology_rounded,
          color: Colors.orange,
          title: 'Stress Education',
          percent: 0.8,
          lastSession: 'Understanding Stress, 25 min (May 1, 2025)',
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final double percent;
  final String lastSession;
  const _CategoryTile(
      {required this.icon,
      required this.color,
      required this.title,
      required this.percent,
      required this.lastSession});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const Spacer(),
                      Text('${(percent * 100).toInt()}%',
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: percent,
                    progressColor: color,
                    backgroundColor: color.withOpacity(0.1),
                    barRadius: const Radius.circular(8),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 4),
                  Text('Last session: $lastSession',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const _ActivityTile(
              icon: Icons.spa_rounded,
              color: Colors.blue,
              title: 'Deep Breathing',
              subtitle: '15 minutes session',
              time: 'Today 10:30 AM',
              status: 'Completed',
              statusColor: Colors.green,
            ),
            const _ActivityTile(
              icon: Icons.psychology_rounded,
              color: Colors.orange,
              title: 'Understanding Stress',
              subtitle: '25 minutes session',
              time: 'Today 8:15 AM',
              status: 'Completed',
              statusColor: Colors.green,
            ),
            const _ActivityTile(
              icon: Icons.self_improvement_rounded,
              color: Colors.purple,
              title: 'Guided Meditation',
              subtitle: '20 minutes session',
              time: 'Yesterday 9:45 PM',
              status: 'Completed',
              statusColor: Colors.green,
            ),
            const _ActivityTile(
              icon: Icons.directions_run_rounded,
              color: Colors.green,
              title: 'Stretching',
              subtitle: '10 minutes session',
              time: 'Apr 29 7:30 AM',
              status: 'Partial',
              statusColor: Colors.orange,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('View All Activity'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final String status;
  final Color statusColor;
  const _ActivityTile(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle,
      required this.time,
      required this.status,
      required this.statusColor});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(status,
              style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
    );
  }
}

class _Achievements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const _AchievementTile(
              icon: Icons.emoji_events_rounded,
              color: Colors.purple,
              title: '8-Day Streak',
              subtitle: 'Keep going! You\'re building a great habit.',
            ),
            const _AchievementTile(
              icon: Icons.emoji_events_rounded,
              color: Colors.orange,
              title: 'Stress Expert',
              subtitle: 'Completed 80% of Stress Education modules.',
            ),
            const _AchievementTile(
              icon: Icons.emoji_events_rounded,
              color: Colors.blue,
              title: 'Breathing Master',
              subtitle: 'Completed 75% of Breathing Exercises.',
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('View All Achievements'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _AchievementTile(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color)),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
    );
  }
}

class _Insights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Best Time',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
                'You tend to complete more exercises in the morning (8-11 AM). Consider scheduling important sessions during this time.',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            const Text('Most Practiced',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
                'Your most consistent practice is Deep Breathing. Great job maintaining this routine!',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            const Text('Suggested Focus',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
                'Your Sleep Improvement modules have the lowest completion rate. Consider focusing on these exercises next.',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StressDetailedInsightsScreen(),
                  ),
                );
              },
              child: const Text('View Detailed Insights'),
            ),
          ],
        ),
      ),
    );
  }
}
