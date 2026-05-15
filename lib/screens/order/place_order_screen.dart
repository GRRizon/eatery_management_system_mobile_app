// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/cart_model.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom/custom_app_bar.dart';

/// Screen for placing a new order
class PlaceOrderScreen extends StatefulWidget {
  final List<CartItem>? cartItems;

  const PlaceOrderScreen({super.key, this.cartItems});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  OrderType _selectedOrderType = OrderType.delivery;
  String _selectedPaymentMethod = '';
  final double _tax = 2.0;
  final double _deliveryFee = 3.0;

  // Menu items with categories
  final Map<String, List<MenuItem>> _menuItems = {
    'Special Offers': [
      MenuItem(
        name: 'Wednesday Wonder',
        price: 10.0,
        description: 'Special Wednesday combo',
      ),
      MenuItem(
        name: 'Friday Feast',
        price: 12.50,
        description: 'Delicious Friday special',
      ),
      MenuItem(
        name: 'Saturday Special',
        price: 15.0,
        description: 'Weekend celebration meal',
      ),
    ],
    'Coffee': [
      MenuItem(name: 'Espresso', price: 3.0),
      MenuItem(name: 'Latte', price: 4.50),
      MenuItem(name: 'Cappuccino', price: 4.50),
      MenuItem(name: 'Volcanica Coffee', price: 7.50),
    ],
    'Tea': [
      MenuItem(name: 'Green Tea', price: 3.0),
      MenuItem(name: 'Black Tea', price: 3.0),
      MenuItem(name: 'Herbal Infusion', price: 3.50),
      MenuItem(name: 'Milk Tea', price: 2.50),
    ],
    'Sandwiches': [
      MenuItem(name: 'Classic Club', price: 7.50),
      MenuItem(name: 'Veggie Wrap', price: 6.50),
      MenuItem(name: 'Grilled Cheese', price: 5.0),
      MenuItem(name: 'Muffaletta', price: 4.70),
    ],
    'Cakes & Pastries': [
      MenuItem(name: 'Chocolate Fudge Cake', price: 5.50),
      MenuItem(name: 'Carrot Cake', price: 5.0),
      MenuItem(name: 'Blueberry Muffin', price: 3.0),
      MenuItem(name: 'Kalb-el-louz Cake', price: 2.0),
    ],
  };

  final Map<String, int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadCartItems();
  }

  void _loadUserInfo() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      _nameController.text = authProvider.currentUser!.fullName;
      _phoneController.text = authProvider.currentUser!.phoneNumber;
      _emailController.text = authProvider.currentUser!.email;
      _addressController.text = authProvider.currentUser!.address ?? '';
    }
  }

  void _loadCartItems() {
    // Pre-populate selected items from cart
    if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
      for (final item in widget.cartItems!) {
        _selectedItems[item.name] = item.quantity;
      }
    }
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    _selectedItems.forEach((name, quantity) {
      for (var category in _menuItems.values) {
        final item = category.firstWhere(
          (item) => item.name == name,
          orElse: () => MenuItem(name: '', price: 0),
        );
        if (item.name.isNotEmpty) {
          subtotal += item.price * quantity;
          break;
        }
      }
    });
    return subtotal;
  }

  double _calculateTotal() {
    double subtotal = _calculateSubtotal();
    double total = subtotal + _tax;
    if (_selectedOrderType == OrderType.delivery) {
      total += _deliveryFee;
    }
    return total;
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
      }
      return;
    }

    if (_selectedItems.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one item')),
        );
      }
      return;
    }

    if (_selectedPaymentMethod.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a payment method')),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${_nameController.text}'),
              Text('Phone: ${_phoneController.text}'),
              Text('Order Type: ${_selectedOrderType.name}'),
              Text('Payment: $_selectedPaymentMethod'),
              const SizedBox(height: 16),
              Text(
                'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final dialogContext = context;
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed successfully! You will be redirected to order tracking.',
                    ),
                  ),
                );
                // Navigate after a delay
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted && dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                });
              },
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Place Order'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Order Type Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Type',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildOrderTypeChip(OrderType.delivery, 'Delivery'),
                            _buildOrderTypeChip(OrderType.pickup, 'Takeaway'),
                            _buildOrderTypeChip(OrderType.dineIn, 'Dine-in'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Information Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Information',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        if (_selectedOrderType == OrderType.delivery)
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Delivery Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.location_on),
                            ),
                            maxLines: 2,
                            validator: (value) {
                              if (_selectedOrderType == OrderType.delivery &&
                                  (value == null || value.isEmpty)) {
                                return 'Delivery address is required';
                              }
                              return null;
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Menu Items Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Items',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ..._menuItems.entries.map(
                          (entry) => _buildMenuCategory(
                            context,
                            entry.key,
                            entry.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedPaymentMethod.isEmpty
                              ? null
                              : _selectedPaymentMethod,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.payment),
                          ),
                          hint: const Text('Select payment method'),
                          items:
                              [
                                'Credit/Debit Card',
                                'Bkash',
                                'Nagad',
                                'Rocket',
                                'Cash on Delivery',
                              ].map((method) {
                                return DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(
                              () => _selectedPaymentMethod = value ?? '',
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a payment method';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Order Summary
                Card(
                  color: AppColors.lightGray,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          context,
                          'Subtotal',
                          '\$${_calculateSubtotal().toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          context,
                          'Tax',
                          '\$${_tax.toStringAsFixed(2)}',
                        ),
                        if (_selectedOrderType == OrderType.delivery) ...[
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            context,
                            'Delivery Fee',
                            '\$${_deliveryFee.toStringAsFixed(2)}',
                          ),
                        ],
                        const Divider(height: 24),
                        _buildSummaryRow(
                          context,
                          'Total',
                          '\$${_calculateTotal().toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Place Order Button
                ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTypeChip(OrderType type, String label) {
    final isSelected = _selectedOrderType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedOrderType = type);
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  Widget _buildMenuCategory(
    BuildContext context,
    String categoryName,
    List<MenuItem> items,
  ) {
    final bool isSpecial = categoryName == 'Special Offers';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isNotEmpty) ...[
            Row(
              children: [
                if (isSpecial) const Icon(Icons.star, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSpecial ? Colors.purple : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...items.map((item) => _buildMenuItemTile(item)),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItemTile(MenuItem item) {
    final isSelected = _selectedItems.containsKey(item.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : null,
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedItems[item.name] = 1;
                } else {
                  _selectedItems.remove(item.name);
                }
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (item.description != null && item.description!.isNotEmpty)
                  Text(
                    item.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          if (isSelected)
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: '${_selectedItems[item.name]}',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  isDense: true,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final qty = int.tryParse(value) ?? 1;
                    setState(() => _selectedItems[item.name] = qty);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}

/// Simple MenuItem model for local use
class MenuItem {
  final String name;
  final double price;
  final String? description;

  MenuItem({required this.name, required this.price, this.description});
}
