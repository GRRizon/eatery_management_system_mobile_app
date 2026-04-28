import '../models/menu_item_model.dart';
import '../models/special_offer_model.dart';
import '../utils/logger.dart';
import '../utils/image_assets.dart';

/// Menu Service for managing menu items and special offers
class MenuService {
  static final MenuService _instance = MenuService._internal();

  // Mock menu categories
  static const List<String> categories = [
    'Hot Coffee',
    'Cold Coffee',
    'Specialty Drinks',
    'Tea & Infusions',
    'Pastries',
    'Sandwiches',
    'Desserts',
    'Beverages',
  ];

  // Mock menu items data
  static final List<MenuItem> _mockMenuItems = [
    // Hot Coffee Section
    MenuItem(
      id: 'menu_001',
      name: 'Classic Espresso',
      description: 'Bold and intense Italian espresso shot',
      price: 3.50,
      category: 'Hot Coffee',
      imageUrl: ImageAssets.espressoCoffee,
      preparationTime: 3,
      createdAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 145,
    ),
    MenuItem(
      id: 'menu_002',
      name: 'Vanilla Latte',
      description: 'Smooth espresso with steamed milk and vanilla syrup',
      price: 5.25,
      category: 'Hot Coffee',
      imageUrl: ImageAssets.latteCoffee,
      preparationTime: 5,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 98,
    ),
    MenuItem(
      id: 'menu_003',
      name: 'Caramel Macchiato',
      description:
          'Espresso with vanilla syrup, steamed milk, and caramel drizzle',
      price: 5.75,
      category: 'Hot Coffee',
      imageUrl: ImageAssets.cappuccinoCoffee,
      preparationTime: 6,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.9,
      reviewCount: 156,
    ),
    MenuItem(
      id: 'menu_004',
      name: 'White Chocolate Mocha',
      description: 'Rich espresso with white chocolate and steamed milk',
      price: 6.00,
      category: 'Hot Coffee',
      imageUrl: ImageAssets.latteCoffee,
      preparationTime: 6,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 87,
    ),
    MenuItem(
      id: 'menu_005',
      name: 'Hazelnut Cappuccino',
      description: 'Traditional cappuccino with hazelnut flavor',
      price: 5.50,
      category: 'Hot Coffee',
      imageUrl: ImageAssets.cappuccinoCoffee,
      preparationTime: 5,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.5,
      reviewCount: 76,
    ),

    // Cold Coffee Section
    MenuItem(
      id: 'menu_006',
      name: 'Iced Americano',
      description: 'Chilled espresso with cold water over ice',
      price: 4.25,
      category: 'Cold Coffee',
      imageUrl: ImageAssets.espressoCoffee,
      preparationTime: 4,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.4,
      reviewCount: 67,
    ),
    MenuItem(
      id: 'menu_007',
      name: 'Cold Brew Coffee',
      description: 'Smooth, slow-steeped coffee served over ice',
      price: 4.75,
      category: 'Cold Coffee',
      imageUrl: ImageAssets.latteCoffee,
      preparationTime: 2,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 112,
    ),
    MenuItem(
      id: 'menu_008',
      name: 'Iced Caramel Latte',
      description: 'Iced latte with caramel syrup and whipped cream',
      price: 5.50,
      category: 'Cold Coffee',
      imageUrl: ImageAssets.latteCoffee,
      preparationTime: 5,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 134,
    ),

    // Specialty Drinks Section
    MenuItem(
      id: 'menu_009',
      name: 'Matcha Green Tea Latte',
      description: 'Premium Japanese matcha with steamed milk',
      price: 6.25,
      category: 'Specialty Drinks',
      imageUrl: ImageAssets.greenTea,
      preparationTime: 7,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 89,
    ),
    MenuItem(
      id: 'menu_010',
      name: 'Chai Tea Latte',
      description: 'Spiced Indian chai with steamed milk and honey',
      price: 5.75,
      category: 'Specialty Drinks',
      imageUrl: ImageAssets.blackTea,
      preparationTime: 6,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.5,
      reviewCount: 78,
    ),

    // Tea & Infusions Section
    MenuItem(
      id: 'menu_011',
      name: 'Earl Grey Tea',
      description: 'Classic black tea with bergamot oil',
      price: 3.75,
      category: 'Tea & Infusions',
      imageUrl: ImageAssets.blackTea,
      preparationTime: 4,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.3,
      reviewCount: 45,
    ),
    MenuItem(
      id: 'menu_012',
      name: 'Jasmine Green Tea',
      description: 'Delicate green tea with jasmine flowers',
      price: 3.75,
      category: 'Tea & Infusions',
      imageUrl: ImageAssets.greenTea,
      preparationTime: 4,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.4,
      reviewCount: 52,
    ),

    // Pastries Section
    MenuItem(
      id: 'menu_013',
      name: 'Chocolate Croissant',
      description: 'Buttery croissant filled with rich chocolate',
      price: 4.50,
      category: 'Pastries',
      imageUrl: ImageAssets.blueberryMuffinCake,
      preparationTime: 2,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.9,
      reviewCount: 167,
    ),
    MenuItem(
      id: 'menu_014',
      name: 'Blueberry Scone',
      description: 'Fresh baked scone with blueberries',
      price: 4.25,
      category: 'Pastries',
      imageUrl: ImageAssets.blueberryMuffinCake,
      preparationTime: 2,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.6,
      reviewCount: 98,
    ),

    // Sandwiches Section
    MenuItem(
      id: 'menu_015',
      name: 'Turkey Club Sandwich',
      description: 'Turkey, bacon, lettuce, tomato on toasted bread',
      price: 9.75,
      category: 'Sandwiches',
      imageUrl: ImageAssets.grilledSandwich,
      preparationTime: 8,
      createdAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 123,
    ),
    MenuItem(
      id: 'menu_016',
      name: 'Caprese Panini',
      description: 'Mozzarella, tomato, basil, balsamic glaze',
      price: 8.50,
      category: 'Sandwiches',
      imageUrl: ImageAssets.vegSandwich,
      preparationTime: 7,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.5,
      reviewCount: 89,
    ),

    // Desserts Section
    MenuItem(
      id: 'menu_017',
      name: 'Tiramisu',
      description: 'Classic Italian dessert with coffee and mascarpone',
      price: 7.25,
      category: 'Desserts',
      imageUrl: ImageAssets.carrotCake,
      preparationTime: 2,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.8,
      reviewCount: 145,
    ),
    MenuItem(
      id: 'menu_018',
      name: 'Cheesecake',
      description: 'Creamy New York style cheesecake',
      price: 6.75,
      category: 'Desserts',
      imageUrl: ImageAssets.carrotCake,
      preparationTime: 2,
      isVegetarian: true,
      createdAt: DateTime.now(),
      rating: 4.7,
      reviewCount: 134,
    ),

    // Beverages Section
    MenuItem(
      id: 'menu_019',
      name: 'Fresh Orange Juice',
      description: 'Freshly squeezed orange juice',
      price: 4.50,
      category: 'Beverages',
      imageUrl: ImageAssets.blackTea,
      preparationTime: 2,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.4,
      reviewCount: 67,
    ),
    MenuItem(
      id: 'menu_020',
      name: 'Sparkling Water',
      description: 'Refreshing carbonated mineral water',
      price: 2.75,
      category: 'Beverages',
      imageUrl: ImageAssets.greenTea,
      preparationTime: 1,
      isVegetarian: true,
      isVegan: true,
      createdAt: DateTime.now(),
      rating: 4.2,
      reviewCount: 45,
    ),
  ];

  // Mock special offers
  static final List<SpecialOffer> _mockSpecialOffers = [
    SpecialOffer(
      id: 'offer_001',
      title: 'Wednesday Wonder',
      description: 'Sicilian Sip & Sandwich',
      originalPrice: 12.20,
      discountedPrice: 10.49,
      imageUrl: ImageAssets.wednesdayOffer,
      day: 'Wednesday',
      validFrom: DateTime.now().subtract(const Duration(days: 1)),
      validUntil: DateTime.now().add(const Duration(days: 6)),
      includedItems: ['Sicilian Coffee', 'Sandwich'],
    ),
    SpecialOffer(
      id: 'offer_002',
      title: 'Friday Special',
      description: 'The Triple Play - Three Grilled Cheese Sandwiches',
      originalPrice: 15.00,
      discountedPrice: 10.00,
      imageUrl: ImageAssets.fridayOffer,
      day: 'Friday',
      validFrom: DateTime.now().subtract(const Duration(days: 2)),
      validUntil: DateTime.now().add(const Duration(days: 5)),
      includedItems: ['Grilled Cheese Sandwich x3'],
    ),
    SpecialOffer(
      id: 'offer_003',
      title: 'Saturday Special',
      description:
          'The Ultimate Trio - Club Sandwich, Cappuccino & Chocolate Fudge Cake',
      originalPrice: 17.50,
      discountedPrice: 8.99,
      imageUrl: ImageAssets.saturdayOffer,
      day: 'Saturday',
      validFrom: DateTime.now().subtract(const Duration(days: 3)),
      validUntil: DateTime.now().add(const Duration(days: 4)),
      includedItems: ['Club Sandwich', 'Cappuccino', 'Chocolate Fudge Cake'],
    ),
  ];

  factory MenuService() {
    return _instance;
  }

  MenuService._internal();

  /// Get all menu items
  Future<List<MenuItem>> getAllMenuItems() async {
    try {
      AppLogger.info('Fetching all menu items');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockMenuItems;
    } catch (e) {
      AppLogger.error('Error fetching menu items: $e');
      rethrow;
    }
  }

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      AppLogger.info('Fetching menu items for category: $category');
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockMenuItems.where((item) => item.category == category).toList();
    } catch (e) {
      AppLogger.error('Error fetching menu items by category: $e');
      rethrow;
    }
  }

  /// Get menu item by ID
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      AppLogger.fine('Fetching menu item with ID: $id');
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockMenuItems.cast<MenuItem?>().firstWhere(
        (item) => item?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      AppLogger.error('Error fetching menu item: $e');
      return null;
    }
  }

  /// Search menu items
  Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      AppLogger.info('Searching menu items with query: $query');
      await Future.delayed(const Duration(milliseconds: 300));
      final lowerQuery = query.toLowerCase();
      return _mockMenuItems
          .where(
            (item) =>
                item.name.toLowerCase().contains(lowerQuery) ||
                item.description.toLowerCase().contains(lowerQuery) ||
                item.category.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      AppLogger.error('Error searching menu items: $e');
      rethrow;
    }
  }

  /// Get menu categories
  Future<List<String>> getCategories() async {
    try {
      AppLogger.fine('Fetching menu categories');
      return categories;
    } catch (e) {
      AppLogger.error('Error fetching categories: $e');
      rethrow;
    }
  }

  /// Get all special offers
  Future<List<SpecialOffer>> getSpecialOffers() async {
    try {
      AppLogger.info('Fetching special offers');
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockSpecialOffers;
    } catch (e) {
      AppLogger.error('Error fetching special offers: $e');
      rethrow;
    }
  }

  /// Get active special offers
  Future<List<SpecialOffer>> getActiveSpecialOffers() async {
    try {
      AppLogger.info('Fetching active special offers');
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockSpecialOffers.where((offer) => offer.isValidNow).toList();
    } catch (e) {
      AppLogger.error('Error fetching active special offers: $e');
      rethrow;
    }
  }

  /// Get special offer by ID
  Future<SpecialOffer?> getSpecialOfferById(String id) async {
    try {
      AppLogger.fine('Fetching special offer with ID: $id');
      return _mockSpecialOffers.cast<SpecialOffer?>().firstWhere(
        (offer) => offer?.id == id,
        orElse: () => null,
      );
    } catch (e) {
      AppLogger.error('Error fetching special offer: $e');
      return null;
    }
  }

  /// Get popular menu items (with high ratings)
  Future<List<MenuItem>> getPopularItems({int limit = 5}) async {
    try {
      AppLogger.info('Fetching popular menu items');
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockMenuItems
          .where((item) => item.hasGoodRating)
          .take(limit)
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching popular items: $e');
      rethrow;
    }
  }

  /// Get recently added items
  Future<List<MenuItem>> getRecentlyAdded({int limit = 5}) async {
    try {
      AppLogger.info('Fetching recently added items');
      final recent = _mockMenuItems.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return recent.take(limit).toList();
    } catch (e) {
      AppLogger.error('Error fetching recently added items: $e');
      rethrow;
    }
  }

  /// Get vegetarian items
  Future<List<MenuItem>> getVegetarianItems() async {
    try {
      AppLogger.info('Fetching vegetarian items');
      return _mockMenuItems.where((item) => item.isVegetarian).toList();
    } catch (e) {
      AppLogger.error('Error fetching vegetarian items: $e');
      rethrow;
    }
  }

  /// Get vegan items
  Future<List<MenuItem>> getVeganItems() async {
    try {
      AppLogger.info('Fetching vegan items');
      return _mockMenuItems.where((item) => item.isVegan).toList();
    } catch (e) {
      AppLogger.error('Error fetching vegan items: $e');
      rethrow;
    }
  }

  /// Add a new menu item (Admin only)
  Future<MenuItem> addMenuItem(MenuItem item) async {
    try {
      AppLogger.info('Adding new menu item: ${item.name}');
      await Future.delayed(const Duration(milliseconds: 500));
      _mockMenuItems.add(item);
      return item;
    } catch (e) {
      AppLogger.error('Error adding menu item: $e');
      rethrow;
    }
  }

  /// Update an existing menu item (Admin only)
  Future<MenuItem> updateMenuItem(String id, MenuItem updatedItem) async {
    try {
      AppLogger.info('Updating menu item: $id');
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _mockMenuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _mockMenuItems[index] = updatedItem;
        return updatedItem;
      } else {
        throw Exception('Menu item not found');
      }
    } catch (e) {
      AppLogger.error('Error updating menu item: $e');
      rethrow;
    }
  }

  /// Delete a menu item (Admin only)
  Future<void> deleteMenuItem(String id) async {
    try {
      AppLogger.info('Deleting menu item: $id');
      await Future.delayed(const Duration(milliseconds: 500));
      _mockMenuItems.removeWhere((item) => item.id == id);
    } catch (e) {
      AppLogger.error('Error deleting menu item: $e');
      rethrow;
    }
  }
}
