import 'package:flutter/material.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD001',
      'customer': 'John Doe',
      'amount': '\$45.99',
      'status': 'Pending',
      'date': '2024-05-15',
    },
    {
      'id': '#ORD002',
      'customer': 'Jane Smith',
      'amount': '\$67.50',
      'status': 'Confirmed',
      'date': '2024-05-15',
    },
    {
      'id': '#ORD003',
      'customer': 'Mike Johnson',
      'amount': '\$89.99',
      'status': 'Delivered',
      'date': '2024-05-14',
    },
    {
      'id': '#ORD004',
      'customer': 'Sarah Williams',
      'amount': '\$56.75',
      'status': 'In Progress',
      'date': '2024-05-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              title: Text(
                '${order['id']} - ${order['customer']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Amount: ${order['amount']}'),
                  Text('Date: ${order['date']}'),
                ],
              ),
              trailing: Chip(
                label: Text(order['status']),
                backgroundColor: _getStatusColor(order['status']),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'In Progress':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
