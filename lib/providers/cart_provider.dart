//lib/providers/cart_provider

import 'package:flutter/material.dart';
import 'package:foodies/models/cart_item.dart';
import 'package:foodies/models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(FoodItem foodItem) {
    debugPrint(
        '[CartProvider] Adding item: ${foodItem.name} (ID: ${foodItem.id})');
    final existingIndex =
        _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
      debugPrint(
          '[CartProvider] Increased quantity to ${_items[existingIndex].quantity}');
    } else {
      _items.add(CartItem(foodItem: foodItem));
      debugPrint(
          '[CartProvider] New item added. Total items: ${_items.length}');
    }
    notifyListeners();

    // Verify items list
    debugPrint('[CartProvider] Current cart contents:');
    for (var item in _items) {
      debugPrint(' - ${item.foodItem.name} x${item.quantity}');
    }
  }

  void removeItem(String foodItemId) {
    _items.removeWhere((item) => item.foodItem.id == foodItemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void incrementQuantity(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}
