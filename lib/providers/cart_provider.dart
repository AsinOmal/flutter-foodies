import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodies/models/cart_item.dart';
import 'package:foodies/models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CartItem> _items = [];
  String? userId;

  List<CartItem> get items => _items;
  double get totalAmount =>
      _items.fold(0, (total, item) => total + item.totalPrice);

  Future<void> clearCart() async {
    _items.clear(); // Clear all items in the cart
    notifyListeners();
    await _saveCart(); // Update Firestore to reflect the empty cart
  }

  Future<void> _saveCart() async {
    if (userId == null) return;
    try {
      await _firestore.collection('carts').doc(userId).set({
        'items': _items.map((item) => item.toMap()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addItem(FoodItem foodItem) {
    final existingIndex =
        _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(foodItem: foodItem));
    }
    notifyListeners();
    _saveCart();
  }

  void incrementItem(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      _saveCart();
    }
  }

  void decrementItem(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _saveCart();
    }
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.foodItem.id == foodId);
    notifyListeners();
    _saveCart();
  }

  // Keep existing increment/decrement/remove methods
}
