import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/index.dart';
import '../menu/menu_screen.dart';
import '../order/order_screen.dart';
import '../order/place_order_screen.dart';
import '../profile/user_profile_screen.dart';

/// Home Screen - Main dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Load initial data
  void _loadInitialData() {
    final menuProvider = context.read<MenuProvider>();
    final authProvider = context.read<AuthProvider>();

    menuProvider.loadAllMenuItems();
    menuProvider.loadSpecialOffers();

    if (authProvider.currentUser != null) {
      context.read<OrderProvider>().loadUserOrders(
        authProvider.currentUser!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomePageContent(),
      const MenuScreen(),
      const OrderScreen(),
      const UserProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      floatingActionButton:
          _selectedIndex !=
              2 // Hide FAB on Orders tab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlaceOrderScreen()),
                );
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_shopping_cart),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Home Page Content
class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  final List<String> categories = [
    'Pizza',
    'Burgers',
    'Pasta',
    'Salads',
    'Desserts',
    'Drinks',
  ];
  final List<IconData> categoryIcons = [
    Icons.local_pizza,
    Icons.lunch_dining,
    Icons.restaurant,
    Icons.fastfood,
    Icons.cake,
    Icons.local_drink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Eatery',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Consumer<OrderProvider>(
            builder: (_, orderProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        // Navigate to cart
                      },
                    ),
                    if (orderProvider.cartItemCount > 0)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '${orderProvider.cartItemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.all(20),
              child: Consumer<AuthProvider>(
                builder: (_, authProvider, _) {
                  final userName =
                      authProvider.currentUser?.fullName ?? 'Guest';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium,
                          children: [
                            TextSpan(
                              text: 'Welcome,\n',
                              style: TextStyle(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: userName.split(' ').first,
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fresh coffee, Tasty food.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Special Offers Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Offers Today',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Consumer<MenuProvider>(
                    builder: (_, menuProvider, _) {
                      if (menuProvider.isLoading) {
                        return const CustomLoadingIndicator();
                      }

                      if (menuProvider.activeOffers.isEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'No special offers today',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: menuProvider.activeOffers.length,
                          itemBuilder: (_, index) {
                            final offer = menuProvider.activeOffers[index];
                            return Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      offer.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: AppColors.lightGray,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Save ${offer.discountText}',
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(
                                                alpha: 0.8,
                                              ),
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.title,
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'Now ${offer.discountedPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Was ${offer.originalPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: AppColors.white
                                                        .withValues(alpha: 0.6),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Popular Items Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Items',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to menu
                        },
                        child: Text(
                          'View All',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Consumer<MenuProvider>(
                    builder: (_, menuProvider, _) {
                      if (menuProvider.isLoading) {
                        return const CustomLoadingIndicator();
                      }

                      final items = menuProvider.allMenuItems.take(4).toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          return MenuItemCard(
                            item: items[index],
                            onAddToCart: () {
                              context.read<OrderProvider>().addToCart(
                                menuItemId: items[index].id,
                                itemName: items[index].name,
                                itemPrice: items[index].price,
                                imageUrl: items[index].imageUrl ?? '',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${items[index].name} added to cart',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
