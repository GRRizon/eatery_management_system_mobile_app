/// Delivery model for representing a delivery order
///
/// This model encapsulates all delivery-related information
/// including order details, customer info, and status.
class Delivery {
  final String id;
  final String orderId;
  final String driverId;
  final Customer customer;
  final String deliveryAddress;
  final DeliveryStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double? rating;
  final String? notes;

  Delivery({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.customer,
    required this.deliveryAddress,
    this.status = DeliveryStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.rating,
    this.notes,
  });

  /// Create delivery from JSON
  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      driverId: json['driverId'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      deliveryAddress: json['deliveryAddress'] as String,
      status: DeliveryStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeliveryStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'driverId': driverId,
    'customer': customer.toJson(),
    'deliveryAddress': deliveryAddress,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'rating': rating,
    'notes': notes,
  };

  /// Check if delivery is completed
  bool get isCompleted => status == DeliveryStatus.delivered;

  /// Check if delivery is in progress
  bool get isInProgress =>
      status == DeliveryStatus.inTransit ||
      status == DeliveryStatus.readyForPickup;
}

/// Customer model for delivery customer
///
/// This model represents a customer receiving a delivery
class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? profileImageUrl;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.latitude,
    this.longitude,
    this.profileImageUrl,
  });

  /// Create customer from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'profileImageUrl': profileImageUrl,
  };

  /// Get customer initial letter for avatar
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  /// Check if location is available
  bool get hasLocation => latitude != null && longitude != null;
}

/// Delivery status enum
enum DeliveryStatus {
  pending,
  readyForPickup,
  inTransit,
  delivered,
  cancelled,
  failed,
}

/// Extension for delivery status display
extension DeliveryStatusExtension on DeliveryStatus {
  /// Get user-friendly status text
  String get displayText {
    switch (this) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.readyForPickup:
        return 'Ready for Pickup';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
      case DeliveryStatus.failed:
        return 'Failed';
    }
  }

  /// Get status color representation
  String get colorCode {
    switch (this) {
      case DeliveryStatus.pending:
        return '#FFA500'; // Orange
      case DeliveryStatus.readyForPickup:
        return '#4169E1'; // Blue
      case DeliveryStatus.inTransit:
        return '#32CD32'; // Lime Green
      case DeliveryStatus.delivered:
        return '#228B22'; // Forest Green
      case DeliveryStatus.cancelled:
        return '#DC143C'; // Crimson
      case DeliveryStatus.failed:
        return '#FF0000'; // Red
    }
  }
}

/// Call record model for tracking customer calls
class CallRecord {
  final String id;
  final String customerId;
  final String driverId;
  final DateTime callTime;
  final Duration? duration;
  final CallStatus status;
  final String? notes;

  CallRecord({
    required this.id,
    required this.customerId,
    required this.driverId,
    required this.callTime,
    this.duration,
    this.status = CallStatus.initiated,
    this.notes,
  });

  /// Create call record from JSON
  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      driverId: json['driverId'] as String,
      callTime: DateTime.parse(json['callTime'] as String),
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      status: CallStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CallStatus.initiated,
      ),
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'driverId': driverId,
    'callTime': callTime.toIso8601String(),
    'duration': duration?.inSeconds,
    'status': status.name,
    'notes': notes,
  };
}

/// Call status enum
enum CallStatus { initiated, ringing, connected, ended, failed, missed }

/// Extension for call status display
extension CallStatusExtension on CallStatus {
  /// Get user-friendly status text
  String get displayText {
    switch (this) {
      case CallStatus.initiated:
        return 'Initiating...';
      case CallStatus.ringing:
        return 'Ringing...';
      case CallStatus.connected:
        return 'Connected';
      case CallStatus.ended:
        return 'Ended';
      case CallStatus.failed:
        return 'Failed';
      case CallStatus.missed:
        return 'Missed';
    }
  }
}
