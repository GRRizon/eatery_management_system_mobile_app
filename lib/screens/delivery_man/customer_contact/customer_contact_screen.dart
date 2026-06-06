import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../models/delivery_model.dart';
import '../../../providers/call_provider.dart';

/// Customer Contact Screen
///
/// This screen displays a list of customers for the delivery person.
/// Features:
/// - View customer details (name, phone, address, order ID)
/// - Call customer directly from the screen
/// - Shows call status and history
/// - Error handling and user feedback
///
/// The screen uses Provider pattern for state management,
/// with CallProvider handling all call-related operations.
class CustomerContactScreen extends StatefulWidget {
  const CustomerContactScreen({super.key});

  @override
  State<CustomerContactScreen> createState() => _CustomerContactScreenState();
}

class _CustomerContactScreenState extends State<CustomerContactScreen> {
  /// Sample customers list
  /// In production, this would come from a database/API
  final List<Customer> _customers = [
    Customer(
      id: '1',
      name: 'Ali Ahmed',
      phoneNumber: '+1-234-567-8901',
      email: 'ali@example.com',
      address: '123 Main Street',
      latitude: 40.7128,
      longitude: -74.0060,
      profileImageUrl: null,
    ),
    Customer(
      id: '2',
      name: 'Fatima Khan',
      phoneNumber: '+1-234-567-8902',
      email: 'fatima@example.com',
      address: '456 Oak Avenue',
      latitude: 40.7589,
      longitude: -73.9851,
      profileImageUrl: null,
    ),
    Customer(
      id: '3',
      name: 'Hassan Ahmed',
      phoneNumber: '+1-234-567-8903',
      email: 'hassan@example.com',
      address: '789 Pine Road',
      latitude: 40.7614,
      longitude: -73.9776,
      profileImageUrl: null,
    ),
    Customer(
      id: '4',
      name: 'Zainab Ali',
      phoneNumber: '+1-234-567-8904',
      email: 'zainab@example.com',
      address: '321 Elm Street',
      latitude: 40.7489,
      longitude: -73.9680,
      profileImageUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCallProvider();
  }

  /// Initialize the call provider on screen load
  ///
  /// This should be called once when the screen is initialized
  /// to set up the call service
  void _initializeCallProvider() {
    Future.microtask(() {
      if (mounted) {
        final callProvider = context.read<CallProvider>();
        callProvider.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CallProvider>(
        builder: (context, callProvider, child) {
          return Stack(
            children: [
              // Main customer list
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return _buildCustomerCard(context, customer, callProvider);
                },
              ),

              // Show active call overlay if call is in progress
              if (callProvider.isCallActive)
                _buildActiveCallOverlay(context, callProvider),
            ],
          );
        },
      ),
    );
  }

  /// Build individual customer card
  ///
  /// Parameters:
  /// - context: BuildContext
  /// - customer: Customer object
  /// - callProvider: CallProvider for managing calls
  ///
  /// Returns: Card widget displaying customer information
  Widget _buildCustomerCard(
    BuildContext context,
    Customer customer,
    CallProvider callProvider,
  ) {
    final isCurrentCallCustomer =
        callProvider.currentCallPhone == customer.phoneNumber;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        // Customer avatar with initial
        leading: CircleAvatar(
          backgroundColor: isCurrentCallCustomer
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.7),
          child: Text(
            customer.initial,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Customer name as title
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // Customer details as subtitle
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Phone number
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    customer.phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Address
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    customer.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Call button in trailing
        trailing: _buildCallButton(
          context,
          customer,
          callProvider,
          isCurrentCallCustomer,
        ),
      ),
    );
  }

  /// Build call button
  ///
  /// Shows different states based on call status:
  /// - Normal state: Shows call icon
  /// - Loading: Shows spinner
  /// - Active call: Shows end call button
  Widget _buildCallButton(
    BuildContext context,
    Customer customer,
    CallProvider callProvider,
    bool isCurrentCall,
  ) {
    if (callProvider.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (isCurrentCall && callProvider.isCallActive) {
      // End call button
      return IconButton(
        icon: const Icon(Icons.call_end, color: Colors.red),
        onPressed: () => _handleEndCall(context, callProvider),
        tooltip: 'End Call',
      );
    }

    // Make call button
    return IconButton(
      icon: const Icon(Icons.call, color: AppColors.primary),
      onPressed: () => _handleMakeCall(context, customer, callProvider),
      tooltip: 'Call Customer',
    );
  }

  /// Handle making a call to a customer
  ///
  /// Parameters:
  /// - context: BuildContext
  /// - customer: Customer to call
  /// - callProvider: Provider for managing call state
  ///
  /// Shows error snackbar if call fails
  Future<void> _handleMakeCall(
    BuildContext context,
    Customer customer,
    CallProvider callProvider,
  ) async {
    // Show loading state
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${customer.name}...'),
        duration: const Duration(seconds: 1),
      ),
    );

    // Attempt to make the call
    final success = await callProvider.makeCall(
      phoneNumber: customer.phoneNumber,
      customerName: customer.name,
    );

    if (!mounted) return;

    if (!success) {
      // Show error if call failed
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(callProvider.errorMessage ?? 'Failed to make call'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      // Show success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to ${customer.name}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handle ending the current call
  ///
  /// Parameters:
  /// - context: BuildContext
  /// - callProvider: Provider for managing call state
  Future<void> _handleEndCall(
    BuildContext context,
    CallProvider callProvider,
  ) async {
    final success = await callProvider.endCall();

    if (!mounted) return;

    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call ended'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(callProvider.errorMessage ?? 'Failed to end call'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Build active call overlay
  ///
  /// Shows when a call is in progress
  /// Displays current call information
  Widget _buildActiveCallOverlay(
    BuildContext context,
    CallProvider callProvider,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.call, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              'Calling ${callProvider.currentCallCustomerName ?? 'Customer'}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              callProvider.currentCallPhone ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
