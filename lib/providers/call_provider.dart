import 'package:flutter/material.dart';
import '../models/delivery_model.dart';
import '../services/call_service.dart';
import '../utils/logger.dart';

/// Provider for managing call operations state
///
/// This provider handles:
/// - Making calls to customers
/// - Tracking call status
/// - Managing call history
///
/// Uses Provider pattern for state management.
///
/// Example usage:
/// ```dart
/// final callProvider = Provider.of<CallProvider>(context);
///
/// // Make a call
/// await callProvider.makeCall(
///   phoneNumber: '+1-234-567-8901',
///   customerName: 'Ali Ahmed',
/// );
///
/// // Check if call is active
/// if (callProvider.isCallActive) {
///   print('Call is currently active');
/// }
/// ```
class CallProvider extends ChangeNotifier {
  final CallService _callService;

  /// Call records history
  final List<CallRecord> _callHistory = [];

  /// Current call state
  bool _isCallActive = false;
  String? _currentCallPhone;
  String? _currentCallCustomerName;
  String? _errorMessage;
  bool _isLoading = false;

  CallProvider(this._callService);

  // ============ Getters ============

  /// Check if a call is currently active
  bool get isCallActive => _isCallActive;

  /// Get current call phone number
  String? get currentCallPhone => _currentCallPhone;

  /// Get current call customer name
  String? get currentCallCustomerName => _currentCallCustomerName;

  /// Get error message if any
  String? get errorMessage => _errorMessage;

  /// Check if operation is loading
  bool get isLoading => _isLoading;

  /// Get call history
  List<CallRecord> get callHistory => List.unmodifiable(_callHistory);

  /// Get call history count
  int get callHistoryCount => _callHistory.length;

  // ============ Methods ============

  /// Initialize the call provider
  ///
  /// This should be called before making any calls
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _callService.initialize();
      _errorMessage = null;

      AppLogger.info('CallProvider initialized successfully');
    } catch (e) {
      _errorMessage = 'Failed to initialize call service: $e';
      AppLogger.error(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Make a call to a customer
  ///
  /// Parameters:
  /// - phoneNumber: Customer's phone number
  /// - customerName: Name of the customer
  ///
  /// Returns:
  /// - true if call was successful
  /// - false if call failed
  ///
  /// Example:
  /// ```dart
  /// final success = await callProvider.makeCall(
  ///   phoneNumber: '+1-234-567-8901',
  ///   customerName: 'Ali Ahmed',
  /// );
  /// ```
  Future<bool> makeCall({
    required String phoneNumber,
    required String customerName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check if phone number is valid
      if (phoneNumber.isEmpty) {
        _errorMessage = 'Phone number cannot be empty';
        AppLogger.error(_errorMessage!);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if customer name is valid
      if (customerName.isEmpty) {
        _errorMessage = 'Customer name cannot be empty';
        AppLogger.error(_errorMessage!);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Make the call
      final result = await _callService.callCustomer(
        phoneNumber: phoneNumber,
        customerName: customerName,
      );

      if (result) {
        _isCallActive = true;
        _currentCallPhone = phoneNumber;
        _currentCallCustomerName = customerName;

        // Add to call history
        _addToCallHistory(phoneNumber, customerName, CallStatus.initiated);

        AppLogger.info('Call to $customerName initiated successfully');
      } else {
        _errorMessage = 'Failed to initiate call. Please try again.';
        AppLogger.error(_errorMessage!);
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Error making call: $e';
      AppLogger.error(_errorMessage!);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// End the current call
  ///
  /// Returns:
  /// - true if call was ended successfully
  /// - false if no active call
  ///
  /// Example:
  /// ```dart
  /// final success = await callProvider.endCall();
  /// ```
  Future<bool> endCall() async {
    try {
      if (!_isCallActive) {
        _errorMessage = 'No active call to end';
        AppLogger.warning(_errorMessage!);
        notifyListeners();
        return false;
      }

      _isLoading = true;
      notifyListeners();

      final result = await _callService.endCall();

      if (result) {
        _isCallActive = false;
        AppLogger.info('Call ended successfully');
      } else {
        _errorMessage = 'Failed to end call';
        AppLogger.error(_errorMessage!);
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Error ending call: $e';
      AppLogger.error(_errorMessage!);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear call history
  void clearCallHistory() {
    _callHistory.clear();
    AppLogger.info('Call history cleared');
    notifyListeners();
  }

  /// Get last call record
  ///
  /// Returns null if no call history exists
  CallRecord? getLastCall() {
    if (_callHistory.isEmpty) return null;
    return _callHistory.last;
  }

  // ============ Private Methods ============

  /// Add a call record to history
  void _addToCallHistory(
    String phoneNumber,
    String customerName,
    CallStatus status,
  ) {
    final callRecord = CallRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerId: phoneNumber, // Use phone as temporary ID
      driverId: 'driver_${DateTime.now().millisecondsSinceEpoch}',
      callTime: DateTime.now(),
      status: status,
      notes: 'Called $customerName',
    );

    _callHistory.add(callRecord);
    AppLogger.info('Call record added to history');
  }

  // ============ Cleanup ============

  /// Dispose resources
  @override
  void dispose() {
    _callService.dispose();
    super.dispose();
  }
}
