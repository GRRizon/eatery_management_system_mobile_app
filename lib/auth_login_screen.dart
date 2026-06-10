import 'package:flutter/material.dart';
import '../../consumer/ai_scanning_screen.dart';
import '../../industrial_client/industrial_input_screen.dart';
import '../../widgets/hover_button.dart';

class AuthLoginScreen extends StatefulWidget {
  final String selectedRole;
  final VoidCallback onForgotPassword;

  const AuthLoginScreen({
    super.key,
    required this.selectedRole,
    required this.onForgotPassword,
  });

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordVisible = false;

  final Color textColor = const Color(0xFF2D3748);
  final Color subTextColor = const Color(0xFF718096);
  final Color buttonColor = const Color(0xFF111827);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'your@email.com',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.mail_outline, color: subTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
            prefixIcon: Icon(Icons.lock_outline, color: subTextColor),
            suffixIcon: GestureDetector(
              onTap: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: subTextColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: textColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.onForgotPassword,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        HoverButton(
          text: 'Continue as ${widget.selectedRole.split(" ").first}',
          onTap: () {
            if (emailController.text.isEmpty ||
                passwordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in all fields')),
              );
              return;
            }
            if (!_isValidEmail(emailController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid email address'),
                ),
              );
              return;
            }

            if (widget.selectedRole == 'Consumer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AiScanningScreen(),
                ),
              );
            } else if (widget.selectedRole == 'Industrial Client') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IndustrialInputScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logging in as ${widget.selectedRole}...'),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }
}
