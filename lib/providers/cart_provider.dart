import 'package:flutter/material.dart';
import 'package:foodies/models/cart_item.dart';
import 'package:foodies/models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(FoodItem foodItem) {
    assert(foodItem.id.isNotEmpty, 'FoodItem must have an ID');
    
    final index = _items.indexWhere((item) => item.foodItem == foodItem);
    
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(foodItem: foodItem));
    }
    notifyListeners();
  }

  void incrementItem(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      notifyListeners();
    }
  }

  void decrementItem(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.foodItem.id == foodId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}