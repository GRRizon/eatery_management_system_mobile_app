import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../widgets/hover_button.dart';

class AuthSignupScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const AuthSignupScreen({super.key, required this.onBackToLogin});

  @override
  State<AuthSignupScreen> createState() => _AuthSignupScreenState();
}

class _AuthSignupScreenState extends State<AuthSignupScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool agreedToTerms = false;

  final Color textColor = const Color(0xFF2D3748);
  final Color subTextColor = const Color(0xFF718096);
  final Color buttonColor = const Color(0xFF111827);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'John Doe',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.person_outline, color: subTextColor),
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
          const SizedBox(height: 16),
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
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                letterSpacing: 2,
              ),
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
          Text(
            'Confirm Password',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                letterSpacing: 2,
              ),
              prefixIcon: Icon(Icons.lock_outline, color: subTextColor),
              suffixIcon: GestureDetector(
                onTap: () => setState(
                  () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
                ),
                child: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
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
          Row(
            children: [
              Checkbox(
                value: agreedToTerms,
                onChanged: (value) =>
                    setState(() => agreedToTerms = value ?? false),
              ),
              Expanded(
                child: Text(
                  'I agree to the Terms & Conditions',
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          HoverButton(
            text: 'Create Account',
            onTap: () {
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty) {
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
              if (passwordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password must be at least 6 characters'),
                  ),
                );
                return;
              }
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              if (!agreedToTerms) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please agree to the Terms & Conditions'),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account created for ${nameController.text}!'),
                  duration: const Duration(seconds: 2),
                ),
              );

              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  widget.onBackToLogin();
                  nameController.clear();
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                  setState(() => agreedToTerms = false);
                }
              });
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                  TextSpan(
                    text: 'Login',
                    style: TextStyle(
                      color: buttonColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onBackToLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }
}
