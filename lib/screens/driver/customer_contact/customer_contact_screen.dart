import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class CustomerContactScreen extends StatelessWidget {
  const CustomerContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Customer Contact\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
