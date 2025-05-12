import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'profile_creation.dart';
import '../services/auth_service.dart';
import 'patient_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String email = '';
  String password = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();

      if (isLogin) {
        // Handle login
        try {
          final userCredential =
              await authService.signInWithEmailAndPassword(email, password);
          if (userCredential != null) {
            _showMessage("Welcome to MedCon!");
          }
        } on FirebaseAuthException catch (e) {
          String message = "Authentication error";
          switch (e.code) {
            case 'user-not-found':
              message = "No account found with this email";
              break;
            case 'wrong-password':
              message = "Incorrect password";
              break;
            case 'invalid-email':
              message = "Invalid email address";
              break;
            case 'user-disabled':
              message = "This account has been disabled";
              break;
            default:
              message = e.message ?? "An error occurred during login";
          }
          _showMessage(message);
          return;
        }
      } else {
        // Handle registration
        try {
          final userCredential =
              await authService.createUserWithEmailAndPassword(email, password);
          if (userCredential == null) {
            _showMessage("Failed to create account. Please try again.");
            return;
          }
          _showMessage("Account created successfully!");
        } on FirebaseAuthException catch (e) {
          String message = "Authentication error";
          switch (e.code) {
            case 'email-already-in-use':
              message = "This email is already registered";
              break;
            case 'weak-password':
              message = "Password is too weak";
              break;
            case 'invalid-email':
              message = "Invalid email address";
              break;
            case 'operation-not-allowed':
              message = "Email/password accounts are not enabled";
              break;
            default:
              message = e.message ?? "An error occurred during registration";
          }
          _showMessage(message);
          return;
        }
      }

      // Check if user has profile data
      final hasProfile = await authService.hasUserProfile();

      if (mounted) {
        if (hasProfile) {
          // Navigate to dashboard if profile exists
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        } else {
          // Navigate to profile creation if no profile exists
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfileCreationScreen()),
          );
        }
      }
    } catch (e) {
      _showMessage("An unexpected error occurred. Please try again.");
      print('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and title section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              LucideIcons.heartPulse,
                              color: Color(0xFF0288D1),
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isLogin ? "Welcome Back" : "Create Account",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0288D1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Your health, our priority",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Form section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email field
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Color(0xFF0288D1),
                                  ),
                                  labelText: "Email",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF0288D1),
                                  ),
                                  hintText: "Enter your email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    (value == null || !value.contains('@'))
                                        ? "Enter a valid email"
                                        : null,
                                onSaved: (value) => email = value!.trim(),
                              ),
                              const SizedBox(height: 16),
                              // Password field
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFF0288D1),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  labelText: "Password",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF0288D1),
                                  ),
                                  hintText: "Enter your password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) =>
                                    (value == null || value.length < 6)
                                        ? "Min 6 characters"
                                        : null,
                                onSaved: (value) => password = value!,
                              ),
                              const SizedBox(height: 24),
                              // Submit button
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF0288D1),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF0288D1),
                                            Color(0xFF01579B),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF0288D1,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(
                                            double.infinity,
                                            60,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: _submit,
                                        child: Text(
                                          isLogin
                                              ? "Sign In"
                                              : "Create Account",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              // Toggle button
                              TextButton(
                                onPressed: () =>
                                    setState(() => isLogin = !isLogin),
                                child: Text(
                                  isLogin
                                      ? "Don't have an account? Sign Up"
                                      : "Already have an account? Sign In",
                                  style: const TextStyle(
                                    color: Color(0xFF0288D1),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
