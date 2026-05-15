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
import '../profile/user_profile_screen.dart';

/// Home Screen - Main dashboard with bottom navigation
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

/// Home Page Content - Displays featured products and categories
class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  int _selectedCategory = 0;
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
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: AppColors.primary),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            _buildWelcomeBanner(),
            const SizedBox(height: 24),

            // Category Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryGrid(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Featured Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Items',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeaturedProducts(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Special Offers Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Offers',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSpecialOffers(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Consumer<AuthProvider>(
      builder: (_, authProvider, _) {
        final userName = authProvider.currentUser?.fullName ?? 'Guest';
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome Back,\n',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                    TextSpan(
                      text: userName.split(' ').first,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '🎉 Get 20% off on your first order today!',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryButton(
          label: categories[index],
          icon: categoryIcons[index],
          isSelected: _selectedCategory == index,
          onPressed: () {
            setState(() => _selectedCategory = index);
          },
          size: 70,
        );
      },
    );
  }

  Widget _buildFeaturedProducts() {
    return Consumer<MenuProvider>(
      builder: (_, menuProvider, _) {
        if (menuProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        final items = menuProvider.allMenuItems.take(6).toList();

        if (items.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.restaurant,
            title: 'No Items Available',
            subtitle: 'Come back later for fresh items',
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ProductCard(
              imageUrl: item.imageUrl ?? '',
              title: item.name,
              description: item.description ?? '',
              price: item.price,
              rating: item.rating,
              prepTimeMinutes: item.preparationTime,
              badge: item.isVegetarian ? 'VEG' : null,
              onAddPressed: () {
                // Add to cart logic
              },
              onTap: () {
                // Navigate to item details
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSpecialOffers() {
    return Consumer<MenuProvider>(
      builder: (_, menuProvider, _) {
        if (menuProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (menuProvider.activeOffers.isEmpty) {
          return FeatureBanner(
            title: 'No Active Offers',
            subtitle: 'Check back soon for special deals!',
            badgeText: 'Coming Soon',
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuProvider.activeOffers.length,
            itemBuilder: (context, index) {
              final offer = menuProvider.activeOffers[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                child: FeatureBanner(
                  title: offer.title,
                  subtitle: 'Save ${offer.discountText}',
                  badgeText: 'LIMITED TIME',
                  actionText: 'Learn More',
                  onActionPressed: () {
                    // Navigate to offer details
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
