/// Special Offer Model for promotional items
class SpecialOffer {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercentage;
  final String imageUrl;
  final String day; // Monday, Tuesday, etc. or "Weekend"
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final int quantityAvailable;
  final List<String> includedItems;

  SpecialOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imageUrl,
    required this.day,
    required this.validFrom,
    required this.validUntil,
    this.isActive = true,
    this.quantityAvailable = -1, // -1 means unlimited
    this.includedItems = const [],
  }) : discountPercentage =
           ((originalPrice - discountedPrice) / originalPrice * 100);

  /// Create SpecialOffer from JSON
  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    final originalPrice = (json['originalPrice'] as num).toDouble();
    final discountedPrice = (json['discountedPrice'] as num).toDouble();

    return SpecialOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      imageUrl: json['imageUrl'] as String,
      day: json['day'] as String,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      isActive: json['isActive'] as bool? ?? true,
      quantityAvailable: json['quantityAvailable'] as int? ?? -1,
      includedItems: List<String>.from(json['includedItems'] as List? ?? []),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'imageUrl': imageUrl,
      'day': day,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'isActive': isActive,
      'quantityAvailable': quantityAvailable,
      'includedItems': includedItems,
    };
  }

  /// Check if offer is currently valid (within date range)
  bool get isValidNow {
    final now = DateTime.now();
    return isActive && now.isAfter(validFrom) && now.isBefore(validUntil);
  }

  /// Get discount percentage as string
  String get discountText => '${discountPercentage.toStringAsFixed(1)}%';

  /// Get savings amount
  double get savingsAmount => originalPrice - discountedPrice;

  /// Get savings as string
  String get savingsText => '\$${savingsAmount.toStringAsFixed(2)}';

  /// Copy with replacement
  SpecialOffer copyWith({
    String? id,
    String? title,
    String? description,
    double? originalPrice,
    double? discountedPrice,
    String? imageUrl,
    String? day,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
    int? quantityAvailable,
    List<String>? includedItems,
  }) {
    return SpecialOffer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      day: day ?? this.day,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      includedItems: includedItems ?? this.includedItems,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialOffer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SpecialOffer(id: $id, title: $title, day: $day, discount: $discountText)';
}
