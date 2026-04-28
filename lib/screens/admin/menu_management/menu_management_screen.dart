import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/menu_item_model.dart';
import '../../../providers/menu_provider.dart';
import '../../../config/app_colors.dart';
import '../../../widgets/custom/custom_button.dart';
import '../../../widgets/custom/custom_text_field.dart';
import '../../../widgets/dialogs/confirmation_dialog.dart';
import '../../../widgets/dialogs/menu_item_dialog.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadAllMenuItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddMenuItemDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => MenuItemDialog(
        onSave: (menuItem) async {
          final success = await context.read<MenuProvider>().addMenuItem(
            menuItem,
          );
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu item added successfully')),
            );
          }
        },
      ),
    );
  }

  void _showEditMenuItemDialog(MenuItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => MenuItemDialog(
        menuItem: item,
        onSave: (updatedItem) async {
          final success = await context.read<MenuProvider>().updateMenuItem(
            item.id,
            updatedItem,
          );
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu item updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(MenuItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: 'Delete Menu Item',
        message: 'Are you sure you want to delete "${item.name}"?',
        onConfirm: () async {
          final success = await context.read<MenuProvider>().deleteMenuItem(
            item.id,
          );
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu item deleted successfully')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, child) {
          if (menuProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Search and Filter Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surfaceColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _searchController,
                            label: 'Search',
                            hint: 'Search menu items...',
                            prefixIcon: const Icon(Icons.search),
                            onChanged: (value) {
                              menuProvider.searchMenuItems(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        CustomButton(
                          label: 'Add Item',
                          onPressed: _showAddMenuItemDialog,
                          icon: const Icon(Icons.add),
                          width: 120,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Category Filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', ...menuProvider.categories].map((
                          category,
                        ) {
                          final isSelected = category == _selectedCategory;
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                                menuProvider.filterByCategory(category);
                              },
                              backgroundColor: AppColors.surfaceColor,
                              selectedColor: AppColors.primary.withValues(
                                alpha: 0.2,
                              ),
                              checkmarkColor: AppColors.primary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items List
              Expanded(
                child: menuProvider.filteredMenuItems.isEmpty
                    ? const Center(child: Text('No menu items found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: menuProvider.filteredMenuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuProvider.filteredMenuItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(item.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)} • ${item.category}',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () =>
                                        _showEditMenuItemDialog(item),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _showDeleteConfirmation(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
