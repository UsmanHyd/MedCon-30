import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';
import 'stress_module.dart';
import 'stress_track.dart';
import 'stress_detailed_insights.dart';
import 'stress_survey.dart';

class StressMonitoringScreen extends StatefulWidget {
  const StressMonitoringScreen({super.key});

  @override
  State<StressMonitoringScreen> createState() => _StressMonitoringScreenState();
}

class _StressMonitoringScreenState extends State<StressMonitoringScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeContent() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor =
        isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF757575);
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.2)
        : Colors.grey.withOpacity(0.08);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Cards
            _mainCard(
              icon: Icons.assignment,
              iconColor: const Color(0xFF7B61FF),
              title: 'Take Stress Survey',
              description: 'Assess your current stress levels',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SurveyScreen(),
                  ),
                );
              },
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 12),
            _mainCard(
              icon: Icons.psychology,
              iconColor: const Color(0xFF7B9EFF),
              title: 'Relief Strategies',
              description: 'Discover techniques to reduce stress',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Stress Modules'),
                        backgroundColor: cardColor,
                        foregroundColor: textColor,
                        elevation: 0,
                      ),
                      body: const StressModulesScreen(),
                    ),
                  ),
                );
              },
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 12),
            _mainCard(
              icon: Icons.show_chart,
              iconColor: const Color(0xFF4ADE80),
              title: 'Track Progress',
              description: 'Monitor your improvement over time',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StressDetailedInsightsScreen(),
                  ),
                );
              },
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 24),
            Text('Recent Activity',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor)),
            const SizedBox(height: 12),
            _activityCard(
              icon: Icons.self_improvement,
              iconColor: const Color(0xFF7B9EFF),
              title: '5-min Breathing Exercise',
              subtitle: 'Completed yesterday',
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 8),
            _activityCard(
              icon: Icons.assignment,
              iconColor: const Color(0xFF7B61FF),
              title: 'Stress Survey',
              subtitle: 'Completed 3 days ago',
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 16),
            _dailyTipCard(
              cardColor: cardColor,
              textColor: textColor,
              subTextColor: subTextColor,
              shadowColor: shadowColor,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Stress Management'
              : _currentIndex == 1
                  ? 'Stress Modules'
                  : 'Progress Tracking',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline,
                color: isDarkMode
                    ? const Color(0xFFB0B0B0)
                    : const Color(0xFF757575)),
            onPressed: () {},
          ),
        ],
      ),
      body: _currentIndex == 1
          ? const StressModulesScreen()
          : _currentIndex == 2
              ? const StressTrackScreen()
              : _buildHomeContent(),
      bottomNavigationBar: AnimatedCurveNavBar(
        onTabChanged: _onTabChanged,
        initialIndex: _currentIndex,
        items: const [
          NavBarItem(
            icon: Icons.home,
            label: "Home",
            highlightColor: Color(0xFF0288D1),
          ),
          NavBarItem(
            icon: Icons.view_module,
            label: "Modules",
            highlightColor: Color(0xFF0288D1),
          ),
          NavBarItem(
            icon: Icons.show_chart,
            label: "Track",
            highlightColor: Color(0xFF0288D1),
          ),
        ],
      ),
    );
  }

  Widget _mainCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color shadowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: TextStyle(fontSize: 13, color: subTextColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color shadowColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 13, color: subTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyTipCard({
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color shadowColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: const Color(0xFF7B61FF), size: 24),
              const SizedBox(width: 8),
              Text('Daily Tip',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Take a 5-minute break every hour to stretch and breathe deeply. This helps reduce stress and improve focus.',
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
        ],
      ),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  final Color highlightColor;

  const NavBarItem({
    required this.icon,
    required this.label,
    required this.highlightColor,
  });
}

class AnimatedCurveNavBar extends StatefulWidget {
  final Function(int) onTabChanged;
  final int initialIndex;
  final List<NavBarItem> items;

  const AnimatedCurveNavBar({
    super.key,
    required this.onTabChanged,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<AnimatedCurveNavBar> createState() => _AnimatedCurveNavBarState();
}

class _AnimatedCurveNavBarState extends State<AnimatedCurveNavBar>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _positionAnimation = Tween<double>(
      begin: _getPositionForIndex(_selectedIndex),
      end: _getPositionForIndex(_selectedIndex),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getPositionForIndex(int index) {
    final count = widget.items.length;
    const width = 1.0;
    final itemWidth = width / count;
    return itemWidth * (index + 0.5);
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    _positionAnimation = Tween<double>(
      begin: _positionAnimation.value,
      end: _getPositionForIndex(index),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward(from: 0.0);

    setState(() {
      _selectedIndex = index;
    });

    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (context, _) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background with curve
              Positioned.fill(
                child: CustomPaint(
                  painter: CurveNavBarPainter(
                    position: _positionAnimation.value,
                    backgroundColor: const Color(0xFF0288D1),
                  ),
                ),
              ),

              // Tab items (with selected item hidden)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.items.length, (index) {
                    final item = widget.items[index];
                    final isSelected = index == _selectedIndex;

                    return SizedBox(
                      width: 80,
                      child: !isSelected
                          ? GestureDetector(
                              onTap: () => _onTabTapped(index),
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.icon,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 24,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(height: 24),
                    );
                  }),
                ),
              ),

              // Floating selected item button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment(2 * _positionAnimation.value - 1, 0),
                  child: GestureDetector(
                    onTap: () => _onTabTapped(_selectedIndex),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.items[_selectedIndex].icon,
                        color: const Color(0xFF0288D1),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CurveNavBarPainter extends CustomPainter {
  final double position;
  final Color backgroundColor;

  CurveNavBarPainter({required this.position, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final centerX = size.width * position;
    const curveWidth = 70.0;
    const curveHeight = 20.0;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(centerX - curveWidth / 2, 0);
    path.quadraticBezierTo(centerX, curveHeight, centerX + curveWidth / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurveNavBarPainter oldDelegate) {
    return position != oldDelegate.position ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
