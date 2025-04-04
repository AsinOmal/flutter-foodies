import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/models/food_item.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Restaurant>> getRestaurants() {
    return _firestore.collection('restaurants').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Restaurant.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<FoodItem>> getMenuItems(String restaurantId) {
    return _firestore
        .collection('menu_items')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodItem.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<FoodItem>> getFoodItemsByCategory(String category) {
    return _firestore
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodItem.fromMap(doc.data());
      }).toList();
    });
  }
}
