import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/custom/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';
import 'delivery_tracking/delivery_tracking_screen.dart';
import 'navigation/navigation_screen.dart';
import 'customer_contact/customer_contact_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DeliveryTrackingScreen(),
    const NavigationScreen(),
    const CustomerContactScreen(),
  ];

  final List<String> _titles = [
    'Delivery Tracking',
    'Navigation',
    'Customer Contact',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_selectedIndex],
        showBackButton: false,
      ),
      drawer: CustomDrawer(
        user: authProvider.currentUser!,
        onLogout: () => _handleLogout(context, authProvider),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Handle logout and navigate to authentication page
  ///
  /// This method:
  /// - Calls logout on auth provider
  /// - Closes the drawer
  /// - Navigates back to login screen
  Future<void> _handleLogout(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    // Close the drawer
    Navigator.of(context).pop();

    // Show loading indicator while logging out
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // Perform logout
      await authProvider.logout();

      // Dismiss loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login screen
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      // Dismiss loading indicator on error
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
