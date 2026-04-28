import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../config/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          UserAccountsDrawerHeader(
            accountName: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () => Navigator.of(context).pop(),
                ),
                if (user.role == UserRole.admin) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.restaurant_menu),
                    title: const Text('Menu Management'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Order Management'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.inventory),
                    title: const Text('Inventory'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Staff Management'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Analytics'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
                if (user.role == UserRole.driver) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delivery_dining),
                    title: const Text('Delivery Tracking'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.navigation),
                    title: const Text('Navigation'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.contact_phone),
                    title: const Text('Customer Contact'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Logout
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pop();
              onLogout();
            },
          ),
        ],
      ),
    );
  }
}
