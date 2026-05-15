import 'dart:math';

import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/menu_item_model.dart';
import '../services/cart_service.dart';

/// Cart Provider - Manages cart state
class CartProvider extends ChangeNotifier {
  final CartService _cartService;

  Cart? _cart;
  bool _isLoading = false;
  String? _error;
  double _discount = 0.0;
  String? _couponCode;

  CartProvider(this._cartService);

  // Getters
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get discount => _discount;
  String? get couponCode => _couponCode;
  int get itemCount => _cart?.itemCount ?? 0;
  double get totalPrice => max(0, (_cart?.total ?? 0) - _discount);
  List<CartItem> get items => _cart?.items ?? [];

  /// Initialize or load cart
  Future<void> initializeCart(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartService.getCart(userId);
      _discount = 0.0;
      _couponCode = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add item to cart
  Future<void> addItem(
    MenuItem menuItem, {
    int quantity = 1,
    String? notes,
  }) async {
    if (_cart == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final cartItem = CartItem(menuItem: menuItem, quantity: quantity);

      final existingItemIndex = _cart!.items.indexWhere(
        (item) => item.menuItemId == menuItem.id,
      );

      List<CartItem> updatedItems;
      if (existingItemIndex != -1) {
        // Update quantity if item already exists
        updatedItems = List.from(_cart!.items);
        final existingItem = updatedItems[existingItemIndex];
        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        updatedItems = [..._cart!.items, cartItem];
      }

      _cart = await _cartService.updateCart(_cart!.id, updatedItems);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove item from cart
  Future<void> removeItem(String cartItemId) async {
    if (_cart == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedItems = _cart!.items
          .where((item) => item.id != cartItemId)
          .toList();

      _cart = await _cartService.updateCart(_cart!.id, updatedItems);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update item quantity
  Future<void> updateItemQuantity(String cartItemId, int newQuantity) async {
    if (_cart == null || newQuantity < 0) return;

    if (newQuantity == 0) {
      await removeItem(cartItemId);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedItems = _cart!.items.map((item) {
        if (item.id == cartItemId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();

      _cart = await _cartService.updateCart(_cart!.id, updatedItems);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    if (_cart == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _cart = await _cartService.updateCart(_cart!.id, []);
      _discount = 0.0;
      _couponCode = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply discount/coupon
  Future<void> applyCoupon(String couponCode) async {
    if (_cart == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final normalizedCode = couponCode.trim().toUpperCase();
      double discount = 0.0;

      if (normalizedCode == 'SAVE10') {
        discount = _cart!.subtotal * 0.10;
      } else if (normalizedCode == 'FREESHIP') {
        discount = _cart!.deliveryFee;
      } else if (normalizedCode == 'SAVE50') {
        discount = 50.0;
      } else {
        throw Exception('Invalid coupon code');
      }

      _discount = min(discount, _cart!.total);
      _couponCode = normalizedCode;
      _error = null;
    } catch (e) {
      _discount = 0.0;
      _couponCode = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get cart summary
  Map<String, dynamic> getCartSummary() {
    if (_cart == null) {
      return {
        'itemCount': 0,
        'subtotal': 0.0,
        'tax': 0.0,
        'deliveryFee': 0.0,
        'total': 0.0,
      };
    }

    return {
      'itemCount': _cart!.itemCount,
      'subtotal': _cart!.subtotal,
      'tax': _cart!.tax,
      'deliveryFee': _cart!.deliveryFee,
      'discount': _discount,
      'total': max(0, _cart!.total - _discount),
    };
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
