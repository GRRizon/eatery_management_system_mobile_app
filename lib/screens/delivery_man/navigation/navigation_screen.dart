import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map placeholder
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'Map View\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildRouteCard(
                    'Current Location',
                    '123 Current Street',
                    Icons.location_on,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildRouteCard(
                    'Next Delivery',
                    '456 Oak Avenue',
                    Icons.location_history,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildRouteCard(
                    'Total Distance',
                    '12.5 km',
                    Icons.directions,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildRouteCard(
                    'Estimated Time',
                    '45 minutes',
                    Icons.schedule,
                    Colors.purple,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.navigation),
                      label: const Text('Start Navigation'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
