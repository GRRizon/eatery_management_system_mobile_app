import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../widgets/hover_button.dart';

class AuthForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const AuthForgotPasswordScreen({super.key, required this.onBackToLogin});

  @override
  State<AuthForgotPasswordScreen> createState() =>
      _AuthForgotPasswordScreenState();
}

class _AuthForgotPasswordScreenState extends State<AuthForgotPasswordScreen> {
  late TextEditingController emailController;
  bool emailSent = false;
  bool isLoading = false;

  final Color textColor = const Color(0xFF2D3748);
  final Color subTextColor = const Color(0xFF718096);
  final Color buttonColor = const Color(0xFF111827);
  final Color successColor = const Color(0xFF00C853);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!emailSent) ...[
            Text(
              'Reset Your Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your email address and we\'ll send you a secure link to reset your password.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: subTextColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
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
              enabled: !isLoading,
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
            const SizedBox(height: 28),
            HoverButton(
              text: isLoading ? 'Sending Reset Link...' : 'Send Reset Link',
              onTap: isLoading
                  ? null
                  : () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your email address'),
                          ),
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

                      setState(() => isLoading = true);

                      // Simulate sending reset link
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final email = emailController.text;
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                            emailSent = true;
                          });
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password reset link sent to $email',
                              ),
                              backgroundColor: successColor,
                              duration: const Duration(seconds: 3),
                            ),
                          );
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
                      text: 'Remember your password? ',
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                    TextSpan(
                      text: 'Back to Login',
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _resetForm();
                          widget.onBackToLogin();
                        },
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Success state
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: successColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Reset Link Sent!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ve sent a password reset link to:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      emailController.text,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please check your email and click the link to reset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: subTextColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'The link will expire in 24 hours.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  HoverButton(
                    text: 'Back to Login',
                    onTap: () {
                      _resetForm();
                      widget.onBackToLogin();
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Didn\'t receive the email? ',
                            style: TextStyle(color: subTextColor, fontSize: 13),
                          ),
                          TextSpan(
                            text: 'Try again',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _resetForm();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  void _resetForm() {
    if (mounted) {
      setState(() {
        emailSent = false;
        isLoading = false;
        emailController.clear();
      });
    }
  }
}
