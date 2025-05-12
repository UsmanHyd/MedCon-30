import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class StressDetailedInsightsScreen extends StatefulWidget {
  const StressDetailedInsightsScreen({Key? key}) : super(key: key);

  @override
  State<StressDetailedInsightsScreen> createState() =>
      _StressDetailedInsightsScreenState();
}

class _StressDetailedInsightsScreenState
    extends State<StressDetailedInsightsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Overview', 'Patterns', 'Trends', 'Categories'];

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _patternsKey = GlobalKey();
  final GlobalKey _trendsKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();

  Future<void> _scrollToSection(int index) async {
    if (index == 0) {
      // Overview: scroll to top
      await _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      final contextMap = {
        1: _patternsKey,
        2: _trendsKey,
        3: _categoriesKey,
      };
      final key = contextMap[index];
      if (key != null && key.currentContext != null) {
        final box = key.currentContext!.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject());
        final scrollOffset = _scrollController.offset +
            offset.dy -
            100; // 100 for tab bar height
        await _scrollController.animateTo(scrollOffset,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut);
      }
    }
    setState(() => _selectedTab = index);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detailed Insights'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _TabBar(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onTabSelected: _scrollToSection,
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _WellnessScoreCard(),
                const SizedBox(height: 16),
                _SectionTitle('Activity Patterns', key: _patternsKey),
                _ActivityPatternsCard(),
                const SizedBox(height: 16),
                _SectionTitle('Progress Trends', key: _trendsKey),
                _TrendsChartCard(),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _TrendChip(
                            label: 'Most Improved',
                            value: 'Stress Education',
                            color: Color(0xFF4ADE80)),
                        SizedBox(width: 8),
                        _TrendChip(
                            label: 'Needs Attention',
                            value: 'Sleep Improvement',
                            color: Color(0xFFFFC107)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionTitle('Category Breakdown', key: _categoriesKey),
                _CategoryBreakdownCard(),
                const SizedBox(height: 16),
                const _SectionTitle('Performance Comparison'),
                _PerformanceComparisonCard(),
                const SizedBox(height: 16),
                const _SectionTitle('Personalized Recommendations'),
                _RecommendationsCard(),
                const SizedBox(height: 16),
                const _SectionTitle('Your Action Plan'),
                _ActionPlanCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  const _TabBar(
      {required this.tabs,
      required this.selectedIndex,
      required this.onTabSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(tabs.length, (i) {
            final selected = i == selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => onTabSelected(i),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        selected ? const Color(0xFF7B61FF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF7B61FF)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _WellnessScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Overall Wellness Score',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('May 2025',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B61FF),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 54.0,
                    lineWidth: 8.0,
                    percent: 0.75,
                    center: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('75%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        SizedBox(height: 2),
                        Text('Excellent',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7B61FF),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    progressColor: const Color(0xFF7B61FF),
                    backgroundColor: const Color(0xFF7B61FF).withOpacity(0.13),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 24),
                  const _StatCard(
                      title: 'Weekly Avg',
                      value: '72%',
                      change: '+3%',
                      color: Color(0xFF7B61FF),
                      width: 72),
                  const _StatCard(
                      title: 'Monthly Avg',
                      value: '68%',
                      change: '+7%',
                      color: Color(0xFF7B61FF),
                      width: 72),
                  const _StatCard(
                      title: 'YTD Avg',
                      value: '65%',
                      change: '+10%',
                      color: Color(0xFF7B61FF),
                      width: 72),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.emoji_events, color: Color(0xFFFFC107), size: 20),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Your wellness score is higher than 82% of users',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final Color color;
  final double width;
  const _StatCard(
      {required this.title,
      required this.value,
      required this.change,
      required this.color,
      this.width = 80});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          const SizedBox(height: 2),
          Text(change,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  @override
  final Key? key;
  const _SectionTitle(this.title, {this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}

class _ActivityPatternsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Time of Day Analysis',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Spacer(),
                _ChipToggle(options: ['Week', 'Month'], selected: 0),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: _HeatmapWidget(),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                _InfoCard(
                  icon: Icons.access_time,
                  title: 'Peak Activity Time',
                  value: '8:00 - 11:00 AM',
                  subtitle: 'Most productive in mornings',
                  color: Color(0xFF7B61FF),
                ),
                SizedBox(width: 12),
                _InfoCard(
                  icon: Icons.event_available,
                  title: 'Best Days',
                  value: 'Monday, Wednesday',
                  subtitle: 'Highest completion rate',
                  color: Color(0xFF7B61FF),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _PatternInsightsCard(),
          ],
        ),
      ),
    );
  }
}

class _ChipToggle extends StatelessWidget {
  final List<String> options;
  final int selected;
  const _ChipToggle({required this.options, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = i == selected;
        return Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF7B61FF)
                  : const Color(0xFFF3F1FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              options[i],
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF7B61FF),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  const _InfoCard(
      {required this.icon,
      required this.title,
      required this.value,
      required this.subtitle,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _PatternInsightsCard extends StatelessWidget {
  const _PatternInsightsCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF7B61FF), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "You're most consistent with morning activities, especially breathing exercises and stress education. Consider scheduling meditation sessions in the morning to improve completion rates. Your evening routine shows gaps that could be filled with sleep improvement activities.",
              style: TextStyle(fontSize: 13, color: Color(0xFF7B61FF)),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- HEATMAP WIDGET --------------------
class _HeatmapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data: 7 days x 5 time slots
    final data = [
      [2, 1, 0, 0, 0, 0, 0],
      [1, 2, 1, 0, 0, 0, 0],
      [0, 1, 2, 1, 0, 0, 0],
      [0, 0, 1, 2, 1, 0, 0],
      [0, 0, 0, 1, 2, 1, 0],
    ];
    final times = ['6', '8', '10', '12', '14'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 32),
            ...days.map((d) => Expanded(
                child: Center(
                    child: Text(d,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54))))),
          ],
        ),
        SizedBox(
          height: 60, // fixed height for the heatmap grid
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: times
                    .map((t) => SizedBox(
                        height: 12,
                        child: Text(t,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black54))))
                    .toList(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: List.generate(data.length, (i) {
                    return SizedBox(
                      height: 12, // fixed height for each row
                      child: Row(
                        children: List.generate(data[i].length, (j) {
                          final v = data[i][j];
                          final color = v == 0
                              ? Colors.transparent
                              : Color.lerp(
                                  const Color(0xFF7B61FF).withOpacity(0.1),
                                  const Color(0xFF7B61FF),
                                  v / 2)!;
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------- PATTERNS TAB --------------------

// -------------------- TRENDS TAB --------------------

class _TrendsChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Progress Trends',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Spacer(),
                _ChipToggle(options: ['Week', 'Month'], selected: 1),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData:
                      const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final weeks = ['W1', 'W2', 'W3', 'W4'];
                          return Text(weeks[value.toInt() % 4],
                              style: const TextStyle(fontSize: 11));
                        },
                        reservedSize: 24,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 3,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    _lineBar(
                        [60, 65, 70, 75], const Color(0xFF7B61FF)), // Breathing
                    _lineBar([40, 45, 50, 55],
                        const Color(0xFF7B9EFF)), // Meditation
                    _lineBar(
                        [50, 55, 60, 70], const Color(0xFF4ADE80)), // Physical
                    _lineBar(
                        [20, 20, 20, 20], const Color(0xFF0288D1)), // Sleep
                    _lineBar(
                        [60, 65, 70, 70], const Color(0xFFFFB74D)), // Stress Ed
                  ],
                  lineTouchData: const LineTouchData(enabled: true),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _LegendDot(color: Color(0xFF7B61FF), label: 'Breathing'),
                  _LegendDot(color: Color(0xFF7B9EFF), label: 'Meditation'),
                  _LegendDot(color: Color(0xFF4ADE80), label: 'Physical'),
                  _LegendDot(color: Color(0xFF0288D1), label: 'Sleep'),
                  _LegendDot(color: Color(0xFFFFB74D), label: 'Stress Ed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _lineBar(List<double> yVals, Color color) {
    return LineChartBarData(
      spots: List.generate(yVals.length, (i) => FlSpot(i.toDouble(), yVals[i])),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _TrendChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _TrendChip(
      {required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
              label == 'Most Improved'
                  ? Icons.trending_up
                  : Icons.warning_amber_rounded,
              color: color,
              size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// -------------------- CATEGORIES TAB --------------------

class _CategoryBreakdownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CategoryCard(
          icon: Icons.spa_rounded,
          color: Color(0xFF7B9EFF),
          title: 'Breathing Exercises',
          percent: 0.75,
          strengths: [
            'Consistent deep breathing practice',
            'Morning routine established'
          ],
          improve: ['Box breathing technique', 'Evening practice consistency'],
          recent: 'Deep Breathing\n15 min • May 1, 2025',
        ),
        const _CategoryCard(
          icon: Icons.self_improvement_rounded,
          color: Color(0xFF7B61FF),
          title: 'Meditation',
          percent: 0.5,
          strengths: [
            'Guided meditation completion',
            'Evening session consistency'
          ],
          improve: [
            'Morning meditation sessions',
            'Unguided meditation practice'
          ],
          recent: 'Guided Meditation\n20 min • April 30, 2025',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7B61FF),
                side: const BorderSide(color: Color(0xFF7B61FF)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: const Color(0xFFF3F1FF),
              ),
              child: const Text('View All Categories',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final double percent;
  final List<String> strengths;
  final List<String> improve;
  final String recent;
  const _CategoryCard(
      {required this.icon,
      required this.color,
      required this.title,
      required this.percent,
      required this.strengths,
      required this.improve,
      required this.recent});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.13),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text('${(percent * 100).toInt()}%',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: color.withOpacity(0.13),
              valueColor: AlwaysStoppedAnimation(color),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StrengthsAreasCard(
                    title: 'Strengths',
                    items: strengths,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StrengthsAreasCard(
                    title: 'Areas to Improve',
                    items: improve,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: color, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Recent Activity\n$recent',
                        style: const TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(width: 8),
                  const Text('Completed',
                      style: TextStyle(
                          color: Color(0xFF4ADE80),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrengthsAreasCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;
  const _StrengthsAreasCard(
      {required this.title, required this.items, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          const SizedBox(height: 4),
          ...items.map((e) => Row(
                children: [
                  Icon(Icons.circle, size: 7, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(e, style: const TextStyle(fontSize: 12))),
                ],
              )),
        ],
      ),
    );
  }
}

class _PerformanceComparisonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Current vs Previous Month',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Spacer(),
                _ChipToggle(options: ['May vs April'], selected: 0),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 180,
                width: 480,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    minY: 0,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 28),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final cats = [
                              'Stress Ed',
                              'Sleep',
                              'Physical',
                              'Meditation',
                              'Breathing'
                            ];
                            return Text(cats[value.toInt() % 5],
                                style: const TextStyle(fontSize: 11));
                          },
                          reservedSize: 32,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _barGroup(0, 80, 65),
                      _barGroup(1, 30, 20),
                      _barGroup(2, 60, 55),
                      _barGroup(3, 50, 40),
                      _barGroup(4, 70, 60),
                    ],
                    gridData:
                        const FlGridData(show: true, drawVerticalLine: false),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendDot(color: Color(0xFF7B61FF), label: 'May'),
                _LegendDot(color: Color(0xFF7B9EFF), label: 'April'),
              ],
            ),
            const SizedBox(height: 12),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TrendChip(
                      label: 'Improved',
                      value: 'Stress Education (+15%)',
                      color: Color(0xFF4ADE80)),
                  SizedBox(width: 8),
                  _TrendChip(
                      label: 'Improved',
                      value: 'Breathing Exercises (+5%)',
                      color: Color(0xFF4ADE80)),
                  SizedBox(width: 8),
                  _TrendChip(
                      label: 'Decreased',
                      value: 'Physical Activities (-5%)',
                      color: Color(0xFFFFC107)),
                  SizedBox(width: 8),
                  _TrendChip(
                      label: 'Decreased',
                      value: 'Sleep Improvement (-2%)',
                      color: Color(0xFFFFC107)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
            toY: y1,
            color: const Color(0xFF7B61FF),
            width: 14,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: y2,
            color: const Color(0xFF7B9EFF),
            width: 14,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 4,
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF7B61FF)),
                SizedBox(width: 8),
                Text('AI-Powered Suggestions',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Based on your activity patterns and progress',
                style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 16),
            const _RecommendationActionCard(
              icon: Icons.spa_rounded,
              title: 'Try Box Breathing',
              description:
                  'Your breathing exercises are consistent, but you haven\'t tried box breathing yet. This technique can help reduce stress and improve focus during busy workdays.',
              buttonText: 'Start Now',
            ),
            const _RecommendationActionCard(
              icon: Icons.nightlight_round,
              title: 'Focus on Sleep Routine',
              description:
                  'Your sleep improvement modules have the lowest completion rate. Try scheduling a 15-minute bedtime routine at 9:30 PM to improve sleep quality.',
              buttonText: 'Schedule',
            ),
            const _RecommendationActionCard(
              icon: Icons.self_improvement_rounded,
              title: 'Morning Meditation',
              description:
                  'You\'re most active in the mornings, but haven\'t tried morning meditation. Adding a 10-minute session at 8:00 AM could enhance your productivity throughout the day.',
              buttonText: 'Try It',
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View All Recommendations',
                    style: TextStyle(
                        color: Color(0xFF7B61FF), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  const _RecommendationActionCard(
      {required this.icon,
      required this.title,
      required this.description,
      required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7B61FF), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF7B61FF))),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7B61FF),
                    side: const BorderSide(color: Color(0xFF7B61FF)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Priority Tasks',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F1FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('May 1-7, 2025',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B61FF),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _TaskTile(
                title: 'Complete Sleep Improvement module',
                subtitle: '15 min • Highest priority'),
            const _TaskTile(
                title: 'Try morning meditation session',
                subtitle: '10 min • Medium priority'),
            const _TaskTile(
                title: 'Practice box breathing technique',
                subtitle: '5 min • Medium priority'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.schedule, color: Color(0xFF7B61FF), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Based on your activity patterns, we recommend scheduling sleep improvement activities between 9:00-10:00 PM, meditation at 8:00 AM, and breathing exercises at 12:00 PM for optimal results.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF7B61FF)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const _TaskTile({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (_) {}),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.black26),
      ],
    );
  }
}
