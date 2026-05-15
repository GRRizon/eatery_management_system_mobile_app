import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/custom/custom_button.dart';
import '../../widgets/custom/user_type_dropdown.dart';
import '../../utils/validators.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';
import '../admin/admin_home_screen.dart';
import '../delivery_man/driver_home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

/// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  UserRole _selectedUserType = UserRole.user;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      role: _selectedUserType,
    );

    if (!mounted) return;

    if (success) {
      // Navigate based on user role
      final currentUser = authProvider.currentUser;
      Widget homeScreen;

      switch (currentUser?.role) {
        case UserRole.admin:
          homeScreen = const AdminHomeScreen();
          break;
        case UserRole.driver:
          homeScreen = const DriverHomeScreen();
          break;
        case UserRole.user:
        default:
          homeScreen = const HomeScreen();
          break;
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => homeScreen));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text('🍔', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simplifying great dining, effortlessly.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 40),
                // Form Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // User Type Dropdown
                        UserTypeDropdown(
                          value: _selectedUserType,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedUserType = value;
                              });
                            }
                          },
                          label: 'Login as',
                          hint: 'Select user type',
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a user type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Username Field
                        CustomTextField(
                          label: 'Username',
                          hint: 'Enter your username',
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              Validators.validateNotEmpty(value, 'Username'),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              Validators.validatePassword(value),
                          prefixIcon: const Icon(Icons.lock),
                          onSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 12),
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Login Button
                        Consumer<AuthProvider>(
                          builder: (_, authProvider, _) {
                            return CustomButton(
                              label: 'Login',
                              onPressed: _handleLogin,
                              isLoading: authProvider.isLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.borderColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'or',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.borderColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Test Credentials Info
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials:',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildDemoCredential('Customer', 'Rabbani', 'golam1234'),
                      const SizedBox(height: 4),
                      _buildDemoCredential('Admin', 'Admin', 'tasmin1234'),
                      const SizedBox(height: 4),
                      _buildDemoCredential(
                        'Delivery Man',
                        'Mikail',
                        'mikail1234',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredential(String role, String username, String password) {
    return Row(
      children: [
        Icon(
          Icons.person,
          size: 16,
          color: AppColors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$role: $username / $password',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}
