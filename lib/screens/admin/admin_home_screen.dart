import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/custom/custom_app_bar.dart';
import '../../widgets/common/custom_drawer.dart';
import 'menu_management/menu_management_screen.dart';
import 'order_management/order_management_screen.dart';
import 'inventory/inventory_screen.dart';
import 'staff/staff_management_screen.dart';
import 'analytics/analytics_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MenuManagementScreen(),
    const OrderManagementScreen(),
    const InventoryScreen(),
    const StaffManagementScreen(),
    const AnalyticsScreen(),
  ];

  final List<String> _titles = [
    'Menu Management',
    'Order Management',
    'Inventory',
    'Staff Management',
    'Analytics',
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
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
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
