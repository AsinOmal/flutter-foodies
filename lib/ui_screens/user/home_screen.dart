import 'package:flutter/material.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/widgets/custom_appbar.dart';
import 'package:foodies/widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Restaurant> restaurants = [
    Restaurant(
      id: '1',
      name: 'Burger Palace',
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add',
      rating: 4.5,
      deliveryTime: '20-30 min',
      deliveryFee: 'LKR 350',
    ),
    Restaurant(
      id: '2',
      name: 'Pizza Heaven',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
      rating: 4.7,
      deliveryTime: '25-35 min',
      deliveryFee: 'LKR 375',
    ),
  ];

  int selectedCategoryIndex = 0;
  final List<String> categories = [
    "All",
    "Burgers",
    "Pizza",
    "Asian",
    "Kottu",
    "Fried Rice"
  ];

  void _toggleFavorite(int index) {
    setState(() {
      restaurants[index].isFavorite = !restaurants[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Foodies',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 218, 244, 219),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(1),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),

          // Restaurant List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: restaurants[index],
                  onFavoriteTap: () => _toggleFavorite(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}