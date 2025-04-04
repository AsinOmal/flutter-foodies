import 'package:foodies/models/food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
  });

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      foodItem: FoodItem.fromMap(map['foodItem'] ?? {}),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodItem': foodItem.toMap(),
      'quantity': quantity,
    };
  }

  double get totalPrice => foodItem.price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.foodItem == foodItem &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => foodItem.hashCode ^ quantity.hashCode;

  @override
  String toString() {
    return 'CartItem(${foodItem.name}, Qty: $quantity)';
  }
}