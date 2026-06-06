import '../utils/logger.dart';

/// Service for handling map operations and navigation
///
/// Currently uses Figma as a placeholder for maps.
/// In future, this will be integrated with Google Maps API.
///
/// This service provides:
/// - Map display capabilities (currently Figma placeholder)
/// - Route calculation
/// - Location tracking
/// - Navigation features
///
/// Example usage:
/// ```dart
/// final mapService = MapService();
/// await mapService.initialize();
///
/// final route = mapService.calculateRoute(
///   startLocation: Location(latitude: 40.7128, longitude: -74.0060),
///   endLocation: Location(latitude: 40.7589, longitude: -73.9851),
/// );
/// ```
class MapService {
  /// Store the current route information
  DeliveryRoute? _currentRoute;

  /// Store whether map is initialized
  bool _isInitialized = false;

  /// Getters
  bool get isInitialized => _isInitialized;
  DeliveryRoute? get currentRoute => _currentRoute;

  /// Initialize the map service
  ///
  /// In production, this would:
  /// - Request location permissions
  /// - Initialize Google Maps API
  /// - Setup real-time location tracking
  Future<void> initialize() async {
    try {
      AppLogger.info('MapService initializing...');

      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 500));

      _isInitialized = true;
      AppLogger.info('MapService initialized successfully');
      AppLogger.warning(
        'NOTE: Currently using Figma map placeholder. '
        'Google Maps integration will be added in future.',
      );
    } catch (e) {
      AppLogger.error('Error initializing MapService: $e');
      _isInitialized = false;
    }
  }

  /// Calculate route between two locations
  ///
  /// Parameters:
  /// - startLocation: Starting point
  /// - endLocation: Destination point
  ///
  /// Returns:
  /// - DeliveryRoute with calculated distance and time
  ///
  /// Example:
  /// ```dart
  /// final route = mapService.calculateRoute(
  ///   startLocation: Location(latitude: 40.7128, longitude: -74.0060),
  ///   endLocation: Location(latitude: 40.7589, longitude: -73.9851),
  /// );
  /// print('Distance: ${route.distance}');
  /// print('Time: ${route.estimatedTime}');
  /// ```
  DeliveryRoute calculateRoute({
    required Location startLocation,
    required Location endLocation,
  }) {
    try {
      // Calculate simple distance using Haversine formula
      final distance = _calculateDistance(startLocation, endLocation);

      // Estimate time based on average speed (40 km/h for delivery)
      final estimatedMinutes = (distance / 40 * 60).toInt();

      _currentRoute = DeliveryRoute(
        startLocation: startLocation,
        endLocation: endLocation,
        distance: distance,
        estimatedTime: estimatedMinutes,
        createdAt: DateTime.now(),
      );

      AppLogger.info(
        'Route calculated: ${distance.toStringAsFixed(2)} km, '
        '~$estimatedMinutes minutes',
      );

      return _currentRoute!;
    } catch (e) {
      AppLogger.error('Error calculating route: $e');
      return _getDefaultRoute(startLocation, endLocation);
    }
  }

  /// Get current location (placeholder)
  ///
  /// In production, this would use geolocator package
  /// to get real device GPS location
  Future<Location> getCurrentLocation() async {
    try {
      // For now, return a default location
      // In production: use geolocator.getCurrentPosition()
      const defaultLocation = Location(
        latitude: 40.7128,
        longitude: -74.0060,
        name: 'Current Location',
      );

      AppLogger.info(
        'Current location: ${defaultLocation.latitude}, '
        '${defaultLocation.longitude}',
      );

      return defaultLocation;
    } catch (e) {
      AppLogger.error('Error getting current location: $e');
      return const Location(
        latitude: 0,
        longitude: 0,
        name: 'Unknown Location',
      );
    }
  }

  /// Get map view URL (for Figma or Google Maps)
  ///
  /// This provides a way to display maps in the UI
  /// Currently returns Figma placeholder info
  ///
  /// In future, this will integrate with Google Maps Static API
  String getMapViewUrl({
    required Location startLocation,
    required Location endLocation,
  }) {
    // Figma map placeholder
    const figmaMapUrl = 'https://www.figma.com/';

    AppLogger.info(
      'Map view: Using Figma placeholder. '
      'Google Maps will be integrated in future.',
    );

    return figmaMapUrl;
  }

  /// Format distance for display
  ///
  /// Parameters:
  /// - distance: Distance in kilometers
  ///
  /// Returns: Formatted string with unit
  ///
  /// Example:
  /// ```dart
  /// print(mapService.formatDistance(2.5)); // Output: "2.5 km"
  /// ```
  String formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toStringAsFixed(0)} m';
    }
    return '${distance.toStringAsFixed(2)} km';
  }

  /// Format time for display
  ///
  /// Parameters:
  /// - minutes: Time in minutes
  ///
  /// Returns: Formatted string with unit
  ///
  /// Example:
  /// ```dart
  /// print(mapService.formatTime(45)); // Output: "45 mins"
  /// ```
  String formatTime(int minutes) {
    if (minutes < 1) {
      return 'Less than a minute';
    }
    if (minutes == 1) {
      return '1 minute';
    }
    if (minutes < 60) {
      return '$minutes minutes';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    }

    return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min';
  }

  /// Calculate distance using Haversine formula
  ///
  /// This calculates the great-circle distance between two points
  /// on Earth given their coordinates
  double _calculateDistance(Location start, Location end) {
    const earthRadius = 6371; // km

    final lat1Rad = _degreesToRadians(start.latitude);
    final lat2Rad = _degreesToRadians(end.latitude);
    final deltaLat = _degreesToRadians(end.latitude - start.latitude);
    final deltaLon = _degreesToRadians(end.longitude - start.longitude);

    final a =
        (Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2)) +
        (Math.cos(lat1Rad) *
            Math.cos(lat2Rad) *
            Math.sin(deltaLon / 2) *
            Math.sin(deltaLon / 2));

    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  /// Get a default route between two locations
  DeliveryRoute _getDefaultRoute(Location start, Location end) {
    return DeliveryRoute(
      startLocation: start,
      endLocation: end,
      distance: 5.0, // Default distance
      estimatedTime: 15, // Default time in minutes
      createdAt: DateTime.now(),
    );
  }

  /// Dispose resources
  void dispose() {
    _currentRoute = null;
    _isInitialized = false;
    AppLogger.info('MapService disposed');
  }
}

/// Location model for latitude/longitude
class Location {
  final double latitude;
  final double longitude;
  final String? name;

  const Location({required this.latitude, required this.longitude, this.name});

  /// Create location from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      name: json['name'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'name': name,
  };
}

/// Delivery route model
class DeliveryRoute {
  final Location startLocation;
  final Location endLocation;
  final double distance; // in kilometers
  final int estimatedTime; // in minutes
  final DateTime createdAt;

  DeliveryRoute({
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.estimatedTime,
    required this.createdAt,
  });

  /// Create route from JSON
  factory DeliveryRoute.fromJson(Map<String, dynamic> json) {
    return DeliveryRoute(
      startLocation: Location.fromJson(json['startLocation']),
      endLocation: Location.fromJson(json['endLocation']),
      distance: json['distance'] as double,
      estimatedTime: json['estimatedTime'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'startLocation': startLocation.toJson(),
    'endLocation': endLocation.toJson(),
    'distance': distance,
    'estimatedTime': estimatedTime,
    'createdAt': createdAt.toIso8601String(),
  };
}

/// Math helper class for calculations
class Math {
  static double sin(double x) => _sin(x);
  static double cos(double x) => _cos(x);
  static double sqrt(double x) => _sqrt(x);
  static double atan2(double y, double x) => _atan2(y, x);

  static double _sin(double x) {
    // Taylor series approximation for sin
    x = x % (2 * 3.14159265359);
    double result = 0;
    double term = x;
    for (int i = 1; i < 20; i++) {
      result += term;
      term *= -x * x / ((2 * i) * (2 * i + 1));
    }
    return result;
  }

  static double _cos(double x) {
    x = x % (2 * 3.14159265359);
    double result = 1;
    double term = 1;
    for (int i = 1; i < 20; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _sqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0) return 0;

    double guess = x;
    double prev = 0;

    while ((guess - prev).abs() > 1e-10) {
      prev = guess;
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  static double _atan2(double y, double x) {
    return 2 * _atan(y / (x + _sqrt(x * x + y * y)));
  }

  static double _atan(double x) {
    if (x.abs() <= 1) {
      double result = 0;
      double term = x;
      for (int n = 0; n < 20; n++) {
        result += term / (2 * n + 1);
        term *= -x * x * (2 * n + 1) / (2 * n + 3);
      }
      return result;
    }
    return (x > 0 ? 1 : -1) * 3.14159265359 / 2 - _atan(1 / x);
  }
}
