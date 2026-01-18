import 'package:flutter/material.dart';
import 'package:film_ticket_booking_app/config/theme_config.dart';
import 'register_screen.dart';
import 'package:film_ticket_booking_app/screens/home/home_screen.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showCustomSnackBar('Please enter email and password', isError: true);
      return;
    }

    bool success = await AuthService.login(email, password);

    if (success) {
      _showCustomSnackBar('Welcome back!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      _showCustomSnackBar('Authentication failed', isError: true);
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: isError ? primaryRed : const Color(0xFF09FBD3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF09FBD3);

    return Scaffold(
      backgroundColor: backgroundBlack,
      body: Stack(
        children: [
          //Background 
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryRed.withOpacity(0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryRed.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.movie_creation_outlined, color: primaryRed, size: 40),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'CINEMA NEXUS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white,
                      letterSpacing: 6.0,
                    ),
                  ),
                  Text(
                    'LOGIN TO YOUR ACCOUNT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white.withOpacity(0.3),
                      letterSpacing: 2.0,
                    ),
                  ),
                  
                  const SizedBox(height: 60),

                  //Input 
                  _buildTextField(
                    controller: emailController,
                    label: 'EMAIL ADDRESS',
                    icon: Icons.alternate_email_rounded,
                    neonColor: neonCyan,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: passwordController,
                    label: 'PASSWORD',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    neonColor: primaryRed,
                  ),
                  
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Login 
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryRed.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w900, 
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  //Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to CINEMA NEXUS? ",
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'REGISTER NOW',
                          style: TextStyle(
                            color: accentYellow,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required Color neonColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            cursorColor: neonColor,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: neonColor.withOpacity(0.7), size: 20),
              suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white24,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}