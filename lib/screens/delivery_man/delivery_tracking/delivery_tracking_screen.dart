import 'package:flutter/material.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  final List<Map<String, dynamic>> _deliveries = [
    {
      'orderId': '#ORD101',
      'customer': 'Ali Ahmed',
      'address': '123 Main Street',
      'status': 'In Transit',
      'distance': '2.5 km',
    },
    {
      'orderId': '#ORD102',
      'customer': 'Fatima Khan',
      'address': '456 Oak Avenue',
      'status': 'Ready for Pickup',
      'distance': '0 km',
    },
    {
      'orderId': '#ORD103',
      'customer': 'Hassan Ahmed',
      'address': '789 Pine Road',
      'status': 'Delivered',
      'distance': 'Completed',
    },
    {
      'orderId': '#ORD104',
      'customer': 'Zainab Ali',
      'address': '321 Elm Street',
      'status': 'In Transit',
      'distance': '1.8 km',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _deliveries.length,
        itemBuilder: (context, index) {
          final delivery = _deliveries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              title: Text(
                delivery['orderId'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(delivery['customer']),
              trailing: Chip(
                label: Text(delivery['status']),
                backgroundColor: _getStatusColor(delivery['status']),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery Address: ${delivery['address']}'),
                      const SizedBox(height: 8),
                      Text('Distance: ${delivery['distance']}'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Customer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ready for Pickup':
        return Colors.blue;
      case 'In Transit':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
