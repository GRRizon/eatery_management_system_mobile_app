import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../utils/logger.dart';
import '../../utils/image_assets.dart';
import '../home/home_screen.dart';
import '../admin/admin_home_screen.dart';
import '../delivery_man/driver_home_screen.dart';
import 'login_screen.dart';

/// Splash Screen shown on app startup
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  /// Check if user is authenticated
  Future<void> _checkAuthentication() async {
    AppLogger.info('Checking authentication status');

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    if (authProvider.isAuthenticated) {
      AppLogger.info('User is authenticated, navigating based on role');
      final user = authProvider.currentUser!;
      Widget homeScreen;

      switch (user.role) {
        case UserRole.admin:
          homeScreen = const AdminHomeScreen();
          break;
        case UserRole.driver:
          homeScreen = const DriverHomeScreen();
          break;
        case UserRole.user:
          homeScreen = const HomeScreen();
          break;
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => homeScreen));
    } else {
      AppLogger.info('User is not authenticated, navigating to login');
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    ImageAssets.eateryLogo,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        const Text('🍔', style: TextStyle(fontSize: 60)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Tagline
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
