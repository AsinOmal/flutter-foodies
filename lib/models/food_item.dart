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

  // Convert Firestore data to FoodItem object
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed Item',
      restaurantId: map['restaurantId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] as String? ?? '',
      category: map['category'] as String? ?? 'Other',
      isPopular: map['isPopular'] as bool? ?? false,
    );
  }

  // Convert FoodItem to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'restaurantId': restaurantId,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isPopular': isPopular,
    };
  }

  // Helper for debugging
  @override
  String toString() {
    return 'FoodItem($name, LKR $price, ${isPopular ? 'Popular' : 'Regular'})';
  }
}