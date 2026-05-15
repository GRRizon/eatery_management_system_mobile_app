import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard('Total Orders', '1,234', Colors.blue),
            const SizedBox(height: 12),
            _buildStatCard('Total Revenue', '\$45,678', Colors.green),
            const SizedBox(height: 12),
            _buildStatCard('Active Deliveries', '28', Colors.orange),
            const SizedBox(height: 12),
            _buildStatCard('Customer Satisfaction', '4.8/5', Colors.purple),
            const SizedBox(height: 24),
            Text(
              'Sales Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildChartPlaceholder(),
            const SizedBox(height: 24),
            Text(
              'Top Selling Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildTopItemsCard('Burger', '156 sold'),
            _buildTopItemsCard('Pizza', '142 sold'),
            _buildTopItemsCard('Pasta', '118 sold'),
            _buildTopItemsCard('Salad', '98 sold'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Icon(Icons.trending_up, color: color, size: 32),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Chart Coming Soon')),
    );
  }

  Widget _buildTopItemsCard(String itemName, String sales) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(itemName),
        trailing: Text(
          sales,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
