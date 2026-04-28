import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';

/// About Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Name and Version
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text('🍔', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'v${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // About Section
            Text('About', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              'Eatery Management System is a modern food ordering and management application designed to simplify the dining experience.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Features Section
            Text('Features', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _buildFeatureItem('📱', 'Easy Order Placement'),
            _buildFeatureItem('🎯', 'Real-time Order Tracking'),
            _buildFeatureItem('💰', 'Special Offers & Discounts'),
            _buildFeatureItem('👤', 'User Profile Management'),
            _buildFeatureItem('🔒', 'Secure Authentication'),
            _buildFeatureItem('⚡', 'Fast & Reliable Service'),
            const SizedBox(height: 24),
            // Contact Section
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildContactItem('📧', 'Email', AppConstants.contactEmail),
            _buildContactItem('📞', 'Phone', AppConstants.contactPhone),
            _buildContactItem('🕒', 'Hours', AppConstants.businessHours),
            const SizedBox(height: 24),
            // Social Media
            Text('Follow Us', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialButton('f', 'Facebook'),
                _buildSocialButton('📷', 'Instagram'),
                _buildSocialButton('𝕏', 'Twitter'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildContactItem(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
