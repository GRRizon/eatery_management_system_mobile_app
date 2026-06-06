import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../providers/map_provider.dart';
import '../../../services/map_service.dart';

/// Navigation Screen
///
/// This screen displays delivery route information and map.
/// Features:
/// - Figma map placeholder (for now)
/// - Route information display
/// - Distance and time estimates
/// - Navigation controls
///
/// Note: Currently uses Figma as map placeholder.
/// Google Maps integration will be added in future releases.
///
/// The screen uses Provider pattern with MapProvider for
/// state management and route calculations.
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  /// Sample delivery locations
  /// In production, these would come from actual delivery data
  late Location _currentLocation;
  late Location _nextDeliveryLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocations();
    _initializeMapProvider();
  }

  /// Initialize sample locations
  ///
  /// In production, these would be fetched from backend
  void _initializeLocations() {
    _currentLocation = const Location(
      latitude: 40.7128,
      longitude: -74.0060,
      name: 'Current Location',
    );

    _nextDeliveryLocation = const Location(
      latitude: 40.7589,
      longitude: -73.9851,
      name: 'Next Delivery',
    );
  }

  /// Initialize the map provider
  ///
  /// This sets up the map service and calculates the initial route
  void _initializeMapProvider() {
    Future.microtask(() {
      if (mounted) {
        final mapProvider = context.read<MapProvider>();

        // Initialize map
        mapProvider.initializeMap().then((_) {
          if (mounted && !mapProvider.isLoading) {
            // Calculate route after initialization
            mapProvider.calculateRoute(
              startLocation: _currentLocation,
              endLocation: _nextDeliveryLocation,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Map view section
                _buildMapSection(context, mapProvider),

                const SizedBox(height: 16),

                // Route information section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route information title
                      Text(
                        'Route Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Current location card
                      _buildRouteCard(
                        'Current Location',
                        _currentLocation.name ?? 'Unknown',
                        Icons.location_on,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),

                      // Next delivery card
                      _buildRouteCard(
                        'Next Delivery',
                        _nextDeliveryLocation.name ?? 'Unknown',
                        Icons.location_history,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),

                      // Total distance card
                      _buildRouteCard(
                        'Total Distance',
                        mapProvider.formattedDistance,
                        Icons.directions,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),

                      // Estimated time card
                      _buildRouteCard(
                        'Estimated Time',
                        mapProvider.formattedTime,
                        Icons.schedule,
                        Colors.purple,
                      ),

                      const SizedBox(height: 24),

                      // Start navigation button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _handleStartNavigation(context, mapProvider),
                          icon: const Icon(Icons.navigation),
                          label: const Text('Start Navigation'),
                        ),
                      ),

                      // Show error if any
                      if (mapProvider.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  mapProvider.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  /// Build map display section
  ///
  /// Currently shows Figma placeholder.
  /// In future, will display Google Maps.
  Widget _buildMapSection(BuildContext context, MapProvider mapProvider) {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[300],
      child: mapProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Map icon placeholder
                  Icon(Icons.map, size: 64, color: Colors.grey[600]),
                  const SizedBox(height: 16),

                  // Map placeholder text
                  Text(
                    'Figma Map Placeholder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Info about future Google Maps integration
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      mapProvider.getMapInfoText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Build route information card
  ///
  /// Parameters:
  /// - title: Card title
  /// - value: Display value
  /// - icon: Icon to show
  /// - color: Color scheme for the card
  ///
  /// Returns: Styled card widget
  Widget _buildRouteCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle start navigation button press
  ///
  /// Parameters:
  /// - context: BuildContext
  /// - mapProvider: MapProvider instance
  ///
  /// Shows a snackbar with navigation information
  void _handleStartNavigation(BuildContext context, MapProvider mapProvider) {
    if (mapProvider.currentRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Route not calculated. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigation started. '
          'Distance: ${mapProvider.formattedDistance}, '
          'Time: ${mapProvider.formattedTime}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // In production, this would integrate with actual navigation services
    // like Google Maps or Apple Maps
  }
}
