import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../models/special_offer_model.dart';
import '../services/menu_service.dart';
import '../utils/logger.dart';

/// Menu Provider for managing menu state
class MenuProvider extends ChangeNotifier {
  final MenuService _menuService;

  List<MenuItem> _allMenuItems = [];
  List<MenuItem> _filteredMenuItems = [];
  List<SpecialOffer> _specialOffers = [];
  List<SpecialOffer> _activeOffers = [];
  List<String> _categories = [];

  String? _errorMessage;
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  MenuProvider(this._menuService) {
    _initialize();
  }

  // Getters
  List<MenuItem> get allMenuItems => _allMenuItems;
  List<MenuItem> get filteredMenuItems => _filteredMenuItems;
  List<SpecialOffer> get specialOffers => _specialOffers;
  List<SpecialOffer> get activeOffers => _activeOffers;
  List<String> get categories => _categories;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Initialize provider
  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load categories
      _categories = await _menuService.getCategories();

      // Load menu items
      await loadAllMenuItems();

      // Load special offers
      await loadSpecialOffers();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error initializing MenuProvider: $e');
    }
  }

  /// Load all menu items
  Future<void> loadAllMenuItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      _allMenuItems = await _menuService.getAllMenuItems();
      _filteredMenuItems = _allMenuItems;
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading menu items: $e');
    }
  }

  /// Filter by category
  Future<void> filterByCategory(String category) async {
    try {
      _selectedCategory = category;
      _isLoading = true;
      notifyListeners();

      if (category == 'All') {
        _filteredMenuItems = _allMenuItems;
      } else {
        _filteredMenuItems = await _menuService.getMenuItemsByCategory(
          category,
        );
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error filtering by category: $e');
    }
  }

  /// Search menu items
  Future<void> searchMenuItems(String query) async {
    try {
      _searchQuery = query;
      _isLoading = true;
      notifyListeners();

      if (query.isEmpty) {
        _filteredMenuItems = _allMenuItems;
      } else {
        _filteredMenuItems = await _menuService.searchMenuItems(query);
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error searching menu items: $e');
    }
  }

  /// Load special offers
  Future<void> loadSpecialOffers() async {
    try {
      _isLoading = true;
      notifyListeners();

      _specialOffers = await _menuService.getSpecialOffers();
      _activeOffers = await _menuService.getActiveSpecialOffers();

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading special offers: $e');
    }
  }

  /// Get menu item by ID
  Future<MenuItem?> getMenuItemById(String id) async {
    try {
      return await _menuService.getMenuItemById(id);
    } catch (e) {
      AppLogger.error('Error getting menu item: $e');
      return null;
    }
  }

  /// Get popular items
  Future<void> loadPopularItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      _filteredMenuItems = await _menuService.getPopularItems();

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading popular items: $e');
    }
  }

  /// Get vegetarian items
  Future<void> loadVegetarianItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      _filteredMenuItems = await _menuService.getVegetarianItems();

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading vegetarian items: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset filters
  Future<void> resetFilters() async {
    _selectedCategory = 'All';
    _searchQuery = '';
    _filteredMenuItems = _allMenuItems;
    notifyListeners();
  }

  /// Add new menu item (Admin only)
  Future<bool> addMenuItem(MenuItem item) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newItem = await _menuService.addMenuItem(item);
      _allMenuItems.add(newItem);
      _filteredMenuItems = _allMenuItems;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error adding menu item: $e');
      return false;
    }
  }

  /// Update menu item (Admin only)
  Future<bool> updateMenuItem(String id, MenuItem updatedItem) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final item = await _menuService.updateMenuItem(id, updatedItem);
      final index = _allMenuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _allMenuItems[index] = item;
        _filteredMenuItems = _allMenuItems;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error updating menu item: $e');
      return false;
    }
  }

  /// Delete menu item (Admin only)
  Future<bool> deleteMenuItem(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _menuService.deleteMenuItem(id);
      _allMenuItems.removeWhere((item) => item.id == id);
      _filteredMenuItems = _allMenuItems;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error deleting menu item: $e');
      return false;
    }
  }
}
