import 'package:flutter/material.dart';
import 'package:medcon30/patient/modules/chatbot/chatbot.dart';
import 'package:medcon30/patient/modules/communities/community_groups.dart';
import 'package:medcon30/patient/modules/disease/disease_detection.dart';
import 'package:medcon30/patient/modules/heart/heart_disease.dart';
import 'package:medcon30/patient/modules/nutrition/nutrition_fitness.dart';
import 'package:medcon30/patient/profile/profile_display.dart';
import 'package:medcon30/patient/profile/profile_creation.dart';
import 'package:provider/provider.dart';
import 'package:medcon30/theme/theme_provider.dart';
import '../modules/stress/stress_monitoring.dart';
import 'package:medcon30/patient/modules/vaccine/vaccination_reminders.dart';
import 'package:medcon30/patient/modules/SOS/sos_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medcon30/patient/profile/profile_gate.dart';
import 'package:medcon30/services/auth_service.dart';
import 'package:medcon30/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1;
  bool _showChatbot = false;
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
          .collection('users')
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
    if (index == 2) {
      return const ProfileGateScreen();
    }
    return _screens[index];
  }

  final List<Widget> _screens = const [
    CommunityGroupsScreen(),
    _DashboardContent(),
    ProfileGateScreen(),
  ];

  final List<String> _titles = ['Community Groups', 'Dashboard', 'Profile'];

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
        // Show confirmation dialog
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
          title: Text(_titles[_currentIndex]),
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          foregroundColor: const Color(0xFF0288D1),
          elevation: 0.5,
          centerTitle: true,
          surfaceTintColor: isDarkMode ? Colors.grey[850] : Colors.white,
          scrolledUnderElevation: 0,
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
        body: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _getScreenForIndex(_currentIndex),
            ),
            if (_showChatbot)
              Positioned(
                bottom: 80,
                right: 20,
                child: ChatbotScreen(
                  onClose: () {
                    setState(() {
                      _showChatbot = false;
                    });
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: AnimatedCurveNavBar(
          onTabChanged: _handleTabChange,
          initialIndex: _currentIndex,
          items: const [
            NavBarItem(
              icon: Icons.group,
              label: "Groups",
              highlightColor: Color(0xFF0288D1),
            ),
            NavBarItem(
              icon: Icons.home,
              label: "Home",
              highlightColor: Color(0xFF0288D1),
            ),
            NavBarItem(
              icon: Icons.person,
              label: "Profile",
              highlightColor: Color(0xFF0288D1),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _showChatbot = true;
              });
            },
            backgroundColor: const Color(0xFF0288D1),
            tooltip: 'Open Chatbot',
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    'Welcome back!',
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
                          'Your health is our priority',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _DashboardOption(
              title: 'Disease Detection',
              description: 'Get instant analysis of your symptoms',
              icon: Icons.local_hospital,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DiseaseDetectionScreen(),
                  ),
                );
              },
            ),
            _DashboardOption(
              title: 'Stress Monitoring',
              description: 'Track and manage your stress levels',
              icon: Icons.accessibility_new,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const StressMonitoringScreen()),
                );
              },
            ),
            _DashboardOption(
              title: 'Vaccination Reminders',
              description: 'Never miss an important vaccination',
              icon: Icons.notifications,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const VaccinationReminder(),
                  ),
                );
              },
            ),
            _DashboardOption(
              title: 'Emergency SOS',
              description: 'Access emergency help and features',
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red,
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SosMessagingScreen(),
                  ),
                );
              },
            ),
            _DashboardOption(
              title: 'Heart Disease Detector',
              description: 'Monitor your heart health',
              icon: Icons.favorite,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HeartDiseaseDetectionScreen(),
                  ),
                );
              },
            ),
            _DashboardOption(
              title: 'Nutrition & Fitness Planning',
              description: 'Get personalized diet and exercise plans',
              icon: Icons.fitness_center,
              iconColor: const Color(0xFF0288D1),
              isDarkMode: isDarkMode,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NutritionFitnessScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(isDarkMode ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(isDarkMode ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, color: iconColor, size: 16),
        ),
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped: $title'),
                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                ),
              );
            },
      ),
    );
  }
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
