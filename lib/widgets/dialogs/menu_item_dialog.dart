import 'package:flutter/material.dart';
import '../../models/menu_item_model.dart';
import '../custom/custom_button.dart';
import '../custom/custom_text_field.dart';

class MenuItemDialog extends StatefulWidget {
  final MenuItem? menuItem;
  final Function(MenuItem) onSave;

  const MenuItemDialog({super.key, this.menuItem, required this.onSave});

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _preparationTimeController;
  late final TextEditingController _imageUrlController;

  String _selectedCategory = 'Coffee';
  bool _isVegetarian = false;
  bool _isVegan = false;

  final List<String> _categories = [
    'Coffee',
    'Tea',
    'Sandwiches',
    'Cakes',
    'Beverages',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menuItem?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.menuItem?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.menuItem?.price.toString() ?? '',
    );
    _preparationTimeController = TextEditingController(
      text: widget.menuItem?.preparationTime.toString() ?? '5',
    );
    _imageUrlController = TextEditingController(
      text: widget.menuItem?.imageUrl ?? '',
    );

    if (widget.menuItem != null) {
      _selectedCategory = widget.menuItem!.category;
      _isVegetarian = widget.menuItem!.isVegetarian;
      _isVegan = widget.menuItem!.isVegan;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _preparationTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final menuItem = MenuItem(
        id:
            widget.menuItem?.id ??
            'menu_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        imageUrl: _imageUrlController.text.trim(),
        preparationTime: int.parse(_preparationTimeController.text),
        isVegetarian: _isVegetarian,
        isVegan: _isVegan,
        createdAt: widget.menuItem?.createdAt ?? DateTime.now(),
        rating: widget.menuItem?.rating ?? 0.0,
        reviewCount: widget.menuItem?.reviewCount ?? 0,
      );

      widget.onSave(menuItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.menuItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Price',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Price is required';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Enter valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _preparationTimeController,
                      label: 'Prep Time (min)',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Prep time is required';
                        }
                        final time = int.tryParse(value);
                        if (time == null || time <= 0) {
                          return 'Enter valid time';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Image URL is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isVegetarian,
                    onChanged: (value) {
                      setState(() {
                        _isVegetarian = value ?? false;
                      });
                    },
                  ),
                  const Text('Vegetarian'),
                  const SizedBox(width: 16),
                  Checkbox(
                    value: _isVegan,
                    onChanged: (value) {
                      setState(() {
                        _isVegan = value ?? false;
                      });
                    },
                  ),
                  const Text('Vegan'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CustomButton(label: 'Save', onPressed: _save, width: 80),
      ],
    );
  }
}
