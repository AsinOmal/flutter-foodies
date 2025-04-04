import 'package:flutter/material.dart';
import 'package:foodies/models/food_item.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/services/restaurant_service.dart';
import 'package:foodies/widgets/custom_appbar.dart';
import 'package:foodies/widgets/food_item_card.dart';
import 'package:foodies/widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  final TextEditingController _searchController = TextEditingController();

  int selectedCategoryIndex = 0;
  String searchQuery = '';
  bool showFoodItems = false;

  final List<String> categories = [
    "All",
    "Burgers",
    "Pizza",
    "Sushi",
    "Sides",
    "Fried Rice"
  ];

  void _toggleFavorite(Restaurant restaurant) {
    setState(() {
      restaurant.isFavorite = !restaurant.isFavorite;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Foodies',
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with greeting
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeOfDay()}!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'What would you like to order?',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants or foods...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              'Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                        showFoodItems = selected &&
                            index >
                                0; // Only show food items for specific categories
                      });
                    },
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: selectedCategoryIndex == index
                            ? Colors.transparent
                            : Colors.grey[300]!,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content Section
          Expanded(
            child: showFoodItems
                ? _buildFoodItemsByCategory()
                : _buildRestaurantList(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(ThemeData theme) {
    return Column(
      children: [
        // Restaurant List Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Restaurants',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Restaurant List
        Expanded(
          child: StreamBuilder<List<Restaurant>>(
            stream: _restaurantService.getRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredRestaurants = snapshot.data!.where((restaurant) {
                return restaurant.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
              }).toList();

              if (filteredRestaurants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off,
                          size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No restaurants found',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                itemCount: filteredRestaurants.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return RestaurantCard(
                    restaurant: filteredRestaurants[index],
                    onFavoriteTap: () =>
                        _toggleFavorite(filteredRestaurants[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemsByCategory() {
    final selectedCategory = categories[selectedCategoryIndex];

    return StreamBuilder<List<FoodItem>>(
      stream: _restaurantService.getFoodItemsByCategory(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredItems = snapshot.data!.where((item) {
          return item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fastfood_outlined,
                    size: 50, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No $selectedCategory items found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (searchQuery.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    child: const Text('Clear search'),
                  ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return FoodItemCard(
              foodItem: filteredItems[index],
              onAddPressed: () {
                // Handle add to cart
              },
            );
          },
        );
      },
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
