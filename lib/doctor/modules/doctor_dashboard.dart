import 'package:flutter/material.dart';
import 'package:medcon30/doctor/modules/consultation/consultation_requests_screen.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medcon30/doctor/modules/patients_screen.dart';
import 'package:medcon30/doctor/modules/analytics_dashboard_screen.dart';
import 'package:medcon30/doctor/profile/profile_display.dart';
import 'package:medcon30/doctor/profile/profile_creation.dart';
import 'package:medcon30/services/auth_service.dart';
import 'package:medcon30/splash_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _currentIndex = 1;
  bool _isLoading = true;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _hasProfile = false;
        });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user.uid)
          .get();

      setState(() {
        _isLoading = false;
        _hasProfile = doc.exists && doc.data()?['fullName'] != null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasProfile = false;
      });
    }
  }

  Widget _getScreenForIndex(int index) {
    return _screens[index];
  }

  final List<Widget> _screens = const [
    _PatientsScreen(),
    _DashboardContent(),
    _ProfileScreen(),
  ];

  final List<String> _titles = ['Patients', 'Dashboard', 'Profile'];

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? Colors.grey[900] : const Color(0xFFF5F5F5),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor:
            isDarkMode ? Colors.grey[900] : const Color(0xFFF5F5F5),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exit App'),
                  content: const Text('Are you sure you want to exit?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (shouldPop ?? false) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
          title: Text(_titles[_currentIndex]),
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          surfaceTintColor: isDarkMode ? Colors.grey[850] : Colors.white,
          scrolledUnderElevation: 0,
          foregroundColor: const Color(0xFF0288D1),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: const Color(0xFF0288D1),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: const Color(0xFF0288D1),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              color: const Color(0xFF0288D1),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notifications coming soon!'),
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.white,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              color: const Color(0xFF0288D1),
              onPressed: () async {
                // Show confirmation dialog
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  try {
                    await AuthService().signOut(context);
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error logging out: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
        body: _getScreenForIndex(_currentIndex),
        bottomNavigationBar: AnimatedCurveNavBar(
          onTabChanged: _handleTabChange,
          initialIndex: _currentIndex,
          items: const [
            NavBarItem(
              icon: Icons.people_outline,
              label: "Patients",
              highlightColor: Color(0xFF0288D1),
            ),
            NavBarItem(
              icon: Icons.home_rounded,
              label: "Home",
              highlightColor: Color(0xFF0288D1),
            ),
            NavBarItem(
              icon: Icons.person_outline,
              label: "Profile",
              highlightColor: Color(0xFF0288D1),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0288D1), Color(0xFF01579B)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back, Doctor!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'How can we help you today?',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.medical_services, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Your patients are waiting',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Today's Schedule Card
            _TodaysScheduleCard(),
            const SizedBox(height: 24),
            _DashboardOption(
              title: 'Consultation Requests',
              description: '3 new requests pending',
              icon: Icons.chat_bubble_outline,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsultationRequestsScreen(),
                  ),
                );
              },
            ),
            _DashboardOption(
              title: 'Medical Analytics',
              description: 'View patient insights and trends',
              icon: Icons.bar_chart_outlined,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsDashboardScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _RecentPatientsCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _PatientsScreen extends StatelessWidget {
  const _PatientsScreen();

  @override
  Widget build(BuildContext context) {
    return const PatientsScreen();
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const _DoctorProfileGateScreen();
  }
}

class _DoctorProfileGateScreen extends StatefulWidget {
  const _DoctorProfileGateScreen({Key? key}) : super(key: key);

  @override
  State<_DoctorProfileGateScreen> createState() =>
      _DoctorProfileGateScreenState();
}

class _DoctorProfileGateScreenState extends State<_DoctorProfileGateScreen> {
  bool _isLoading = true;
  bool _hasProfile = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _hasProfile = false;
      });
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(user.uid)
        .get();
    final data = doc.data();
    bool hasProfile = false;
    if (doc.exists && data != null) {
      // Defensive: treat education and experience as lists
      final education = data['education'];
      final dob = data['dateOfBirth'] ?? '';
      final gender = data['gender'] ?? '';
      final hasEducation = education is List
          ? education.isNotEmpty
          : (education is String ? education.trim().isNotEmpty : false);
      if (hasEducation &&
          dob.toString().trim().isNotEmpty &&
          gender.toString().trim().isNotEmpty) {
        hasProfile = true;
      }
    }
    setState(() {
      _isLoading = false;
      _hasProfile = hasProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasProfile) {
      return const DoctorProfileDisplayScreen();
    } else {
      return const DoctorProfileCreationScreen();
    }
  }
}

class _DashboardOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const _DashboardOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.isDarkMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TodaysScheduleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final today = DateTime.now();
    final dateStr = "May 21, 2025"; // For demo, use static date
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.12)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: const Color(0xFF0288D1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ScheduleItem(
            name: 'Michael Rodriguez',
            time: '09:30 AM',
            type: 'Follow-up',
            iconColor: const Color(0xFF0288D1),
          ),
          const SizedBox(height: 10),
          _ScheduleItem(
            name: 'Emma Thompson',
            time: '11:15 AM',
            type: 'New Patient',
            iconColor: const Color(0xFF0288D1),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String name;
  final String time;
  final String type;
  final Color iconColor;

  const _ScheduleItem({
    required this.name,
    required this.time,
    required this.type,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(7),
            child: Icon(Icons.calendar_today, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDarkMode ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $type',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey[400]),
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

class _RecentPatientsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.12)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Patients",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF0288D1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _RecentPatientItem(
            name: 'Jennifer Wilson',
            age: 34,
            condition: 'Migraine',
            onView: () {},
          ),
          _RecentPatientItem(
            name: 'Robert Johnson',
            age: 56,
            condition: "Parkinson's",
            onView: () {},
          ),
          _RecentPatientItem(
            name: 'Sophia Martinez',
            age: 28,
            condition: 'Epilepsy',
            onView: () {},
          ),
        ],
      ),
    );
  }
}

class _RecentPatientItem extends StatelessWidget {
  final String name;
  final int age;
  final String condition;
  final VoidCallback onView;
  const _RecentPatientItem({
    required this.name,
    required this.age,
    required this.condition,
    required this.onView,
  });
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                isDarkMode ? Colors.grey[900] : const Color(0xFFE6F3FF),
            child: Icon(Icons.person,
                color: isDarkMode ? Colors.white : const Color(0xFF0288D1),
                size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDarkMode ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$age years • $condition',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onView,
            child: Text(
              'View',
              style: TextStyle(
                color: const Color(0xFF0288D1),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
