/// Represents a single item on the restaurant's menu.
class MenuItem {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  final String category;
  final double rating;
  final int preparationTime;
  final bool isVegetarian;
  final bool isVegan;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    this.category = 'General',
    this.rating = 0.0,
    this.preparationTime = 20,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isAvailable = true,
  });
}
