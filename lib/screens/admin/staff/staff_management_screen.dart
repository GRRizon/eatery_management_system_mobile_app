import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final List<Map<String, dynamic>> _staffMembers = [
    {
      'name': 'Ahmed Hassan',
      'position': 'Delivery Driver',
      'status': 'Active',
      'phone': '+1-234-567-8901',
    },
    {
      'name': 'Fatima Khan',
      'position': 'Chef',
      'status': 'Active',
      'phone': '+1-234-567-8902',
    },
    {
      'name': 'Omar Ali',
      'position': 'Delivery Driver',
      'status': 'On Leave',
      'phone': '+1-234-567-8903',
    },
    {
      'name': 'Zainab Ahmed',
      'position': 'Kitchen Assistant',
      'status': 'Active',
      'phone': '+1-234-567-8904',
    },
    {
      'name': 'Hassan Mohamed',
      'position': 'Delivery Driver',
      'status': 'Active',
      'phone': '+1-234-567-8905',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _staffMembers.length,
        itemBuilder: (context, index) {
          final staff = _staffMembers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  staff['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                staff['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(staff['position']), Text(staff['phone'])],
              ),
              trailing: Chip(
                label: Text(staff['status']),
                backgroundColor: staff['status'] == 'Active'
                    ? Colors.green
                    : Colors.orange,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
