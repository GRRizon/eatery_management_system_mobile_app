import '../core/base/base_service.dart';
import '../core/interfaces/services.dart';
import '../core/exceptions/app_exceptions.dart';
import '../models/menu_item_model.dart';

/// Enhanced Menu Service with improved OOP and error handling
///
/// This service handles all menu-related operations:
/// - Fetching menu items
/// - Filtering by category
/// - Searching products
/// - Caching results
///
/// It implements IMenuService for dependency injection
/// and extends BaseService for consistent service behavior.
///
/// Example usage:
/// ```dart
/// final menuService = MenuServiceImpl();
/// await menuService.initialize();
///
/// // Get all items
/// final items = await menuService.getAllMenuItems();
///
/// // Search items
/// final results = await menuService.searchMenuItems('pizza');
///
/// // Filter by category
/// final pizzas = await menuService.getMenuItemsByCategory('pizza');
/// ```

class MenuServiceImpl extends BaseService implements IMenuService {
  /// Cached menu items
  List<MenuItem>? _cachedMenuItems;

  /// Categories list
  final List<String> _categories = [
    'pizza',
    'burgers',
    'pasta',
    'salads',
    'desserts',
    'drinks',
  ];

  @override
  String get serviceName => 'MenuService';

  /// Initialize menu service
  @override
  Future<void> initialize() async {
    try {
      await super.initialize();
      logInfo('Menu service initialized');

      // Load menu items on initialization
      await _loadMenuItems();
    } catch (e) {
      logError('Error initializing MenuService', e);
      rethrow;
    }
  }

  /// Get all available menu items
  ///
  /// Returns cached items if available, otherwise loads from storage/API
  @override
  Future<List<MenuItem>> getAllMenuItems() async {
    try {
      verifyInitialized();

      if (_cachedMenuItems == null || _cachedMenuItems!.isEmpty) {
        await _loadMenuItems();
      }

      logInfo('Retrieved ${_cachedMenuItems?.length ?? 0} menu items');
      return _cachedMenuItems ?? [];
    } catch (e) {
      handleException('Failed to get all menu items', e);
    }
  }

  /// Get menu items filtered by category
  ///
  /// Parameters:
  ///   - category: Category name to filter by
  ///
  /// Throws [ValidationException] if category is invalid
  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      verifyInitialized();

      // Validate category
      if (!_isValidCategory(category)) {
        throw ValidationException(
          message: 'Invalid category: $category',
          fieldName: 'category',
        );
      }

      final items = await getAllMenuItems();
      final filtered = items
          .where(
            (item) => item.category.toLowerCase() == category.toLowerCase(),
          )
          .toList();

      logInfo('Retrieved ${filtered.length} items from category: $category');
      return filtered;
    } catch (e) {
      handleException('Failed to get items by category', e);
    }
  }

  /// Search menu items by query
  ///
  /// Searches in item name and description
  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      verifyInitialized();

      if (query.trim().isEmpty) {
        return await getAllMenuItems();
      }

      final items = await getAllMenuItems();
      final searchQuery = query.toLowerCase().trim();

      final results = items.where((item) {
        final nameMatch = item.name.toLowerCase().contains(searchQuery);
        final descriptionMatch =
            item.description?.toLowerCase().contains(searchQuery) ?? false;
        final categoryMatch = item.category.toLowerCase().contains(searchQuery);

        return nameMatch || descriptionMatch || categoryMatch;
      }).toList();

      logInfo('Search for "$query" found ${results.length} items');
      return results;
    } catch (e) {
      handleException('Search failed', e);
    }
  }

  /// Get details for specific menu item
  ///
  /// Parameters:
  ///   - itemId: ID of the menu item
  ///
  /// Throws [BusinessException] if item not found
  @override
  Future<MenuItem?> getMenuItemDetails(String itemId) async {
    try {
      verifyInitialized();

      if (itemId.isEmpty) {
        throw ValidationException(
          message: 'Item ID is required',
          fieldName: 'itemId',
        );
      }

      final items = await getAllMenuItems();
      final item = items.firstWhere(
        (item) => item.id == itemId,
        orElse: () =>
            throw BusinessException(message: 'Menu item not found: $itemId'),
      );

      logInfo('Retrieved details for item: ${item.name}');
      return item;
    } catch (e) {
      if (e is BusinessException) rethrow;
      handleException('Failed to get item details', e);
    }
  }

  /// Get all available categories
  @override
  Future<List<String>> getCategories() async {
    try {
      verifyInitialized();
      logInfo('Retrieved ${_categories.length} categories');
      return _categories;
    } catch (e) {
      handleException('Failed to get categories', e);
    }
  }

  /// Refresh menu items from source
  ///
  /// Clears cache and reloads data
  @override
  Future<void> refreshMenuItems() async {
    try {
      verifyInitialized();
      logInfo('Refreshing menu items...');

      _cachedMenuItems = null;
      await _loadMenuItems();

      logInfo('Menu items refreshed successfully');
    } catch (e) {
      handleException('Failed to refresh menu items', e);
    }
  }

  /// Dispose service
  @override
  Future<void> dispose() async {
    try {
      _cachedMenuItems = null;
      await super.dispose();
    } catch (e) {
      logError('Error disposing MenuService', e);
      rethrow;
    }
  }

  // ==================== Private Helper Methods ====================

  /// Load menu items from storage or API
  ///
  /// In production, this would call the backend API
  Future<void> _loadMenuItems() async {
    try {
      // In production, fetch from API:
      // final response = await _apiClient.get('/menu/items');
      // _cachedMenuItems = (response.data as List)
      //     .map((item) => MenuItem.fromJson(item))
      //     .toList();

      // Mock data for demonstration
      _cachedMenuItems = _generateMockMenuItems();

      logInfo('Loaded ${_cachedMenuItems?.length ?? 0} menu items');
    } catch (e) {
      logError('Error loading menu items', e);
      _cachedMenuItems = [];
    }
  }

  /// Generate mock menu items for demonstration
  List<MenuItem> _generateMockMenuItems() {
    return [
      // Pizza
      MenuItem(
        id: 'pizza_001',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato, mozzarella, and basil',
        price: 12.99,
        category: 'pizza',
        imageUrl: 'assets/images/margherita_pizza.jpg',
        preparationTime: 20,
        isAvailable: true,
        rating: 4.5,
      ),
      MenuItem(
        id: 'pizza_002',
        name: 'Pepperoni Pizza',
        description: 'Pizza with pepperoni and mozzarella cheese',
        price: 14.99,
        category: 'pizza',
        imageUrl: 'assets/images/pepperoni_pizza.jpg',
        preparationTime: 20,
        isAvailable: true,
        rating: 4.7,
      ),

      // Burgers
      MenuItem(
        id: 'burger_001',
        name: 'Classic Burger',
        description: 'Juicy beef patty with lettuce, tomato, and special sauce',
        price: 10.99,
        category: 'burgers',
        imageUrl: 'assets/images/classic_burger.jpg',
        preparationTime: 15,
        isAvailable: true,
        rating: 4.4,
      ),

      // Pasta
      MenuItem(
        id: 'pasta_001',
        name: 'Spaghetti Carbonara',
        description: 'Traditional Italian pasta with creamy sauce and bacon',
        price: 11.99,
        category: 'pasta',
        imageUrl: 'assets/images/spaghetti_carbonara.jpg',
        preparationTime: 18,
        isAvailable: true,
        rating: 4.6,
      ),

      // Salads
      MenuItem(
        id: 'salad_001',
        name: 'Caesar Salad',
        description: 'Fresh romaine lettuce with parmesan and croutons',
        price: 9.99,
        category: 'salads',
        imageUrl: 'assets/images/caesar_salad.jpg',
        preparationTime: 5,
        isAvailable: true,
        rating: 4.3,
      ),

      // Desserts
      MenuItem(
        id: 'dessert_001',
        name: 'Chocolate Cake',
        description: 'Rich chocolate cake with chocolate frosting',
        price: 5.99,
        category: 'desserts',
        imageUrl: 'assets/images/chocolate_cake.jpg',
        preparationTime: 2,
        isAvailable: true,
        rating: 4.8,
      ),

      // Drinks
      MenuItem(
        id: 'drink_001',
        name: 'Fresh Orange Juice',
        description: 'Freshly squeezed orange juice',
        price: 3.99,
        category: 'drinks',
        imageUrl: 'assets/images/orange_juice.jpg',
        preparationTime: 3,
        isAvailable: true,
        rating: 4.5,
      ),
    ];
  }

  /// Check if category is valid
  bool _isValidCategory(String category) {
    return _categories.contains(category.toLowerCase());
  }
}
