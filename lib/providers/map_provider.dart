import 'package:flutter/material.dart';
import '../services/map_service.dart';
import '../utils/logger.dart';

/// Provider for managing map and navigation state
///
/// This provider handles:
/// - Map initialization and display
/// - Route calculation
/// - Current location tracking
/// - Navigation features
///
/// Uses Provider pattern for state management.
///
/// Example usage:
/// ```dart
/// final mapProvider = Provider.of<MapProvider>(context);
///
/// // Initialize map
/// await mapProvider.initializeMap();
///
/// // Calculate route
/// final route = mapProvider.calculateRoute(
///   startLocation: Location(latitude: 40.7128, longitude: -74.0060),
///   endLocation: Location(latitude: 40.7589, longitude: -73.9851),
/// );
/// ```
class MapProvider extends ChangeNotifier {
  final MapService _mapService;

  /// Current route
  DeliveryRoute? _currentRoute;

  /// Current location
  Location? _currentLocation;

  /// State flags
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  /// Flag for using Figma placeholder
  final bool _useFigmaPlaceholder = true;

  MapProvider(this._mapService);

  // ============ Getters ============

  /// Check if map is initialized
  bool get isInitialized => _isInitialized;

  /// Check if operation is loading
  bool get isLoading => _isLoading;

  /// Get error message if any
  String? get errorMessage => _errorMessage;

  /// Get current route
  DeliveryRoute? get currentRoute => _currentRoute;

  /// Get current location
  Location? get currentLocation => _currentLocation;

  /// Check if using Figma placeholder
  bool get useFigmaPlaceholder => _useFigmaPlaceholder;

  /// Get formatted distance text
  String get formattedDistance {
    if (_currentRoute == null) return 'N/A';
    return _mapService.formatDistance(_currentRoute!.distance);
  }

  /// Get formatted time text
  String get formattedTime {
    if (_currentRoute == null) return 'N/A';
    return _mapService.formatTime(_currentRoute!.estimatedTime);
  }

  // ============ Methods ============

  /// Initialize the map provider
  ///
  /// This must be called before using map features
  ///
  /// Example:
  /// ```dart
  /// await mapProvider.initializeMap();
  /// ```
  Future<void> initializeMap() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _mapService.initialize();
      _isInitialized = true;
      _errorMessage = null;

      // Get current location after initialization
      _currentLocation = await _mapService.getCurrentLocation();

      AppLogger.info('MapProvider initialized successfully');
      AppLogger.warning(
        'Currently using Figma map placeholder. '
        'Google Maps will be integrated in future release.',
      );
    } catch (e) {
      _errorMessage = 'Failed to initialize map: $e';
      _isInitialized = false;
      AppLogger.error(_errorMessage!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculate route between two locations
  ///
  /// Parameters:
  /// - startLocation: Starting point
  /// - endLocation: Destination point
  ///
  /// Returns:
  /// - DeliveryRoute object with calculated distance and time
  ///
  /// Example:
  /// ```dart
  /// final route = mapProvider.calculateRoute(
  ///   startLocation: Location(latitude: 40.7128, longitude: -74.0060),
  ///   endLocation: Location(latitude: 40.7589, longitude: -73.9851),
  /// );
  /// ```
  DeliveryRoute? calculateRoute({
    required Location startLocation,
    required Location endLocation,
  }) {
    try {
      _errorMessage = null;

      _currentRoute = _mapService.calculateRoute(
        startLocation: startLocation,
        endLocation: endLocation,
      );

      AppLogger.info(
        'Route calculated: ${_currentRoute?.distance} km, '
        '${_currentRoute?.estimatedTime} minutes',
      );

      notifyListeners();
      return _currentRoute;
    } catch (e) {
      _errorMessage = 'Failed to calculate route: $e';
      AppLogger.error(_errorMessage!);
      notifyListeners();
      return null;
    }
  }

  /// Get current device location
  ///
  /// Returns:
  /// - Location object with latitude and longitude
  ///
  /// Note: In production, this would use actual GPS data
  /// from device using geolocator package
  ///
  /// Example:
  /// ```dart
  /// final location = await mapProvider.getCurrentLocation();
  /// print('Current: ${location.latitude}, ${location.longitude}');
  /// ```
  Future<Location?> getCurrentLocation() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentLocation = await _mapService.getCurrentLocation();

      AppLogger.info(
        'Current location: ${_currentLocation?.latitude}, '
        '${_currentLocation?.longitude}',
      );
    } catch (e) {
      _errorMessage = 'Failed to get current location: $e';
      AppLogger.error(_errorMessage!);
      _currentLocation = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _currentLocation;
  }

  /// Get map view URL
  ///
  /// Returns URL for displaying map (Figma placeholder for now)
  ///
  /// In future, this will return Google Maps Static API URL
  String getMapViewUrl({
    required Location startLocation,
    required Location endLocation,
  }) {
    return _mapService.getMapViewUrl(
      startLocation: startLocation,
      endLocation: endLocation,
    );
  }

  /// Format distance for display
  ///
  /// Parameters:
  /// - distance: Distance in kilometers
  ///
  /// Returns: Formatted string like "2.5 km" or "500 m"
  String formatDistance(double distance) {
    return _mapService.formatDistance(distance);
  }

  /// Format time for display
  ///
  /// Parameters:
  /// - minutes: Time in minutes
  ///
  /// Returns: Formatted string like "45 mins" or "1 hour 15 min"
  String formatTime(int minutes) {
    return _mapService.formatTime(minutes);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset route
  void resetRoute() {
    _currentRoute = null;
    notifyListeners();
  }

  /// Get map info text
  ///
  /// Returns information text about the current map state
  String getMapInfoText() {
    if (_useFigmaPlaceholder) {
      return 'Using Figma map placeholder.\n'
          'Google Maps will be integrated in future.';
    }
    return 'Map ready for navigation';
  }

  // ============ Cleanup ============

  /// Dispose resources
  @override
  void dispose() {
    _mapService.dispose();
    super.dispose();
  }
}
