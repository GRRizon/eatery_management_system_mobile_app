import '../models/cart_model.dart';

/// Cart Service - Handles cart operations
class CartService {
  // In-memory storage for demo purposes
  // In production, this would communicate with a backend API
  final Map<String, Cart> _carts = {};

  /// Get or create cart for user
  Future<Cart> getCart(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (_carts.containsKey(userId)) {
      return _carts[userId]!;
    }

    // Create new cart
    final cart = Cart(
      id: 'cart_$userId',
      userId: userId,
      items: [],
      subtotal: 0,
      tax: 0,
      deliveryFee: 3.99,
      total: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _carts[userId] = cart;
    return cart;
  }

  /// Update cart items
  Future<Cart> updateCart(String cartId, List<CartItem> items) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    // Find cart by ID and update
    for (final entry in _carts.entries) {
      final cart = entry.value;
      if (cart.id == cartId) {
        final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
        final tax = subtotal * 0.08; // 8% tax
        final total = subtotal + tax + cart.deliveryFee;

        final updatedCart = cart.copyWith(
          items: items,
          subtotal: subtotal,
          tax: tax,
          total: total,
          updatedAt: DateTime.now(),
        );

        _carts[entry.key] = updatedCart;
        return updatedCart;
      }
    }

    throw Exception('Cart not found');
  }

  /// Clear cart
  Future<void> clearCart(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (_carts.containsKey(userId)) {
      _carts[userId] = _carts[userId]!.copyWith(
        items: [],
        subtotal: 0,
        tax: 0,
        total: _carts[userId]!.deliveryFee,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Delete cart
  Future<void> deleteCart(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    _carts.remove(userId);
  }
}
