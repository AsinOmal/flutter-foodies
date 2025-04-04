import 'package:flutter/material.dart';

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
  })  : assert(id.isNotEmpty, 'FoodItem must have a non-empty ID'),
        assert(restaurantId.isNotEmpty, 'FoodItem must have a restaurant ID');

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    try {
      return FoodItem(
        id: map['id']?.toString() ?? UniqueKey().toString(),
        name: map['name']?.toString() ?? 'Unnamed Item',
        restaurantId: map['restaurantId']?.toString() ?? 'unknown_restaurant',
        description: map['description']?.toString() ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: map['imageUrl']?.toString() ?? '',
        category: map['category']?.toString() ?? 'Other',
        isPopular: map['isPopular'] as bool? ?? false,
      );
    } catch (e) {
      debugPrint('Error creating FoodItem: $e');
      rethrow;
    }
  }
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
}

// ... (keep existing toMap(), ==, hashCode, toString methods)
