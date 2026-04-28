import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Delivery Tracking\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
      ),
    );
  }
}
