import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class CustomerContactScreen extends StatefulWidget {
  const CustomerContactScreen({super.key});

  @override
  State<CustomerContactScreen> createState() => _CustomerContactScreenState();
}

class _CustomerContactScreenState extends State<CustomerContactScreen> {
  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ali Ahmed',
      'phone': '+1-234-567-8901',
      'address': '123 Main Street',
      'orderId': '#ORD101',
    },
    {
      'name': 'Fatima Khan',
      'phone': '+1-234-567-8902',
      'address': '456 Oak Avenue',
      'orderId': '#ORD102',
    },
    {
      'name': 'Hassan Ahmed',
      'phone': '+1-234-567-8903',
      'address': '789 Pine Road',
      'orderId': '#ORD103',
    },
    {
      'name': 'Zainab Ali',
      'phone': '+1-234-567-8904',
      'address': '321 Elm Street',
      'orderId': '#ORD104',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  customer['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                customer['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(customer['phone']),
                  Text(
                    customer['address'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Order: ${customer['orderId']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.call),
                        SizedBox(width: 8),
                        Text('Call'),
                      ],
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.message),
                        SizedBox(width: 8),
                        Text('Message'),
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
