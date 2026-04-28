import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/constants.dart';
import 'utils/logger.dart';
import 'services/auth_service.dart';
import 'services/menu_service.dart';
import 'services/order_service.dart';
import 'providers/auth_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/order_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();
  AppLogger.info('===== EATERY MANAGEMENT SYSTEM STARTING =====');
  AppLogger.info('App Name: ${AppConstants.appName}');
  AppLogger.info('App Version: ${AppConstants.appVersion}');

  // Initialize services
  final authService = AuthService();
  await authService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => authService),
        Provider<MenuService>(create: (_) => MenuService()),
        Provider<OrderService>(create: (_) => OrderService()),

        // Providers
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => MenuProvider(MenuService())),
        ChangeNotifierProvider(create: (_) => OrderProvider(OrderService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
