class FoodItem {
  final String id;
  final String name;
  final String restaurantId;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  bool isPopular;

  FoodItem({
    required this.id,
    required this.name,
     required this.restaurantId,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isPopular = false,
  });
}
