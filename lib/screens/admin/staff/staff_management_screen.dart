import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Staff Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
