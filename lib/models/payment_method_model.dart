/// Payment Method Model
class PaymentMethod {
  final String id;
  final String userId;
  final String type; // credit_card, debit_card, wallet, net_banking, upi
  final String displayName; // Visa ending in 1234, etc.
  final String? cardNumber; // Last 4 digits only
  final String? cardBrand; // Visa, Mastercard, Amex, etc.
  final String? expiryMonth;
  final String? expiryYear;
  final String? cardholderName;
  final String? upiId;
  final String? bankName;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.displayName,
    this.cardNumber,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    this.cardholderName,
    this.upiId,
    this.bankName,
    this.isDefault = false,
    this.isActive = true,
    required this.createdAt,
    this.lastUsedAt,
  });

  /// Check if payment method is expired
  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;
    final now = DateTime.now();
    final expiry = DateTime(int.parse(expiryYear!), int.parse(expiryMonth!));
    return now.isAfter(expiry);
  }

  /// Get payment method description
  String get description {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return '$cardBrand ending in $cardNumber';
      case 'upi':
        return 'UPI: $upiId';
      case 'net_banking':
        return '$bankName';
      case 'wallet':
        return 'Digital Wallet';
      default:
        return displayName;
    }
  }

  /// Create PaymentMethod from JSON
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      displayName: json['displayName'] as String,
      cardNumber: json['cardNumber'] as String?,
      cardBrand: json['cardBrand'] as String?,
      expiryMonth: json['expiryMonth'] as String?,
      expiryYear: json['expiryYear'] as String?,
      cardholderName: json['cardholderName'] as String?,
      upiId: json['upiId'] as String?,
      bankName: json['bankName'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'displayName': displayName,
      'cardNumber': cardNumber,
      'cardBrand': cardBrand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardholderName': cardholderName,
      'upiId': upiId,
      'bankName': bankName,
      'isDefault': isDefault,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  PaymentMethod copyWith({
    String? id,
    String? userId,
    String? type,
    String? displayName,
    String? cardNumber,
    String? cardBrand,
    String? expiryMonth,
    String? expiryYear,
    String? cardholderName,
    String? upiId,
    String? bankName,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      cardNumber: cardNumber ?? this.cardNumber,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardholderName: cardholderName ?? this.cardholderName,
      upiId: upiId ?? this.upiId,
      bankName: bankName ?? this.bankName,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  String toString() =>
      'PaymentMethod(id: $id, type: $type, displayName: $displayName)';
}
