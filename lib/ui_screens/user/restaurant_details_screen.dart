import 'package:flutter/material.dart';
import 'package:foodies/models/food_item.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/widgets/food_item_card.dart';
import 'package:provider/provider.dart';
import 'package:foodies/providers/cart_provider.dart';
import 'package:badges/badges.dart' as badges;

final List<FoodItem> _foodItems = [
  FoodItem(
    id: '1',
    name: 'Classic Burger',
    restaurantId: '1',
    description: 'Beef Patty with cheese and veggies',
    price: 950.00,
    imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b',
    category: 'Burgers',
    isPopular: true,
  ),
  FoodItem(
    id: '2',
    name: 'Margherita Pizza',
    restaurantId: '1',
    description: 'Classic tomato and mozzarella',
    price: 3250.00,
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
    category: 'Pizza',
  ),
];

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late Restaurant _restaurant;
  bool _showFullAppBar = true;

  @override
  void initState() {
    super.initState();
    _restaurant = widget.restaurant;
  }

  void _toggleFavorite() {
    setState(() {
      _restaurant.isFavorite = !_restaurant.isFavorite;
    });
  }

  void handleAddToCart(FoodItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${item.name} to cart!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            setState(() {
              _showFullAppBar = notification.metrics.pixels < 100;
            });
            return false;
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      _restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color.fromARGB(255, 3, 3, 3),
                        child: const Icon(Icons.restaurant),
                      ),
                    ),
                  ),
                  pinned: true,
                  actions: [
                    if (_showFullAppBar) ...[
                      IconButton(
                        icon: badges.Badge(
                          badgeContent: Consumer<CartProvider>(
                            builder: (context, cart, _) => Text(
                              cart.items.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          child: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                      ),
                      IconButton(
                        icon: Icon(
                          _restaurant.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _restaurant.isFavorite
                              ? Colors.red
                              : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ],
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      tabs: const [
                        Tab(text: 'Menu'),
                        Tab(text: 'Reviews'),
                      ],
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: theme.colorScheme.primary,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                    ),
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: _buildCollapsedAppBarContent(),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // Menu Tab
                ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _foodItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => FoodItemCard(
                    foodItem: _foodItems[index],
                    onAddPressed: () => handleAddToCart(_foodItems[index]),
                  ),
                ),
                // Reviews Tab
                const Center(
                  child: Text(
                    'Reviews coming soon',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedAppBarContent() {
    return AnimatedOpacity(
      opacity: _showFullAppBar ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _restaurant.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(_restaurant.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, _) => badges.Badge(
                badgeContent: Text(
                  cart.items.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _restaurant.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
