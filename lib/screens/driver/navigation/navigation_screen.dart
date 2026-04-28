import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Navigation\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
