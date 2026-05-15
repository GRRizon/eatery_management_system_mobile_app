import 'dart:collection';

import '../core/base/base_service.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/interfaces/services.dart';
import '../models/cart_model.dart';
import '../models/menu_item_model.dart';

/// Mock implementation of the ICartService.
///
/// This service simulates cart management operations. In a real application,
/// this would interact with a backend API or a local database.
class CartServiceImpl extends BaseService implements ICartService {
  /// In-memory map to store cart items, with MenuItem ID as the key.
  final Map<String, CartItem> _items = {};

  @override
  String get serviceName => 'CartService';

  @override
  Future<void> addToCart({
    required MenuItem item,
    required int quantity,
  }) async {
    verifyInitialized();
    logInfo('Adding ${item.name} to cart (quantity: $quantity)');
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate network

    if (_items.containsKey(item.id)) {
      _items.update(
        item.id,
        (existing) => existing.copyWith(quantity: existing.quantity + quantity),
      );
    } else {
      _items[item.id] = CartItem(menuItem: item, quantity: quantity);
    }
  }

  @override
  Future<void> clearCart() async {
    verifyInitialized();
    logInfo('Clearing cart');
    await Future.delayed(const Duration(milliseconds: 100));
    _items.clear();
  }

  @override
  Future<List<CartItem>> getCart() async {
    verifyInitialized();
    logInfo('Fetching cart items');
    await Future.delayed(const Duration(milliseconds: 50));
    return UnmodifiableListView(_items.values).toList();
  }

  @override
  Future<double> getCartTotal() async {
    verifyInitialized();
    await Future.delayed(const Duration(milliseconds: 20));
    return _items.values.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    verifyInitialized();
    logInfo('Removing item $itemId from cart');
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_items.containsKey(itemId)) {
      throw BusinessException(message: 'Item not found in cart.');
    }
    _items.remove(itemId);
  }

  @override
  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    verifyInitialized();
    logInfo('Updating quantity for item $itemId to $quantity');
    await Future.delayed(const Duration(milliseconds: 100));

    if (quantity < 0) {
      throw ValidationException(message: 'Quantity cannot be negative.');
    }

    if (!_items.containsKey(itemId)) {
      throw BusinessException(message: 'Item not found in cart.');
    }

    if (quantity == 0) {
      _items.remove(itemId);
    } else {
      _items.update(
        itemId,
        (existing) => existing.copyWith(quantity: quantity),
      );
    }
  }
}
