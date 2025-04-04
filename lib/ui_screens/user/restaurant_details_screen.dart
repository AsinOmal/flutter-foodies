import 'package:flutter/material.dart';
import 'package:foodies/models/food_item.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/services/restaurant_service.dart';
import 'package:foodies/widgets/food_item_card.dart';
import 'package:provider/provider.dart';
import 'package:foodies/providers/cart_provider.dart';
import 'package:badges/badges.dart' as badges;

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
  final RestaurantService _restaurantService = RestaurantService();

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

  void _handleAddToCart(FoodItem item, BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(item);
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

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _restaurant.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                _restaurant.rating.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 4),
              Text(_restaurant.deliveryTime),
              const SizedBox(width: 16),
              const Icon(Icons.delivery_dining, size: 20),
              const SizedBox(width: 4),
              Text(_restaurant.deliveryFee),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
        ],
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
                        color: Colors.grey[800],
                        child: const Icon(Icons.restaurant,
                            size: 50, color: Colors.white),
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
                Column(
                  children: [
                    _buildRestaurantInfo(),
                    Expanded(
                      child: StreamBuilder<List<FoodItem>>(
                        stream: _restaurantService.getMenuItems(_restaurant.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 50, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error loading menu: ${snapshot.error}',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => setState(() {}),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No menu items available',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) => FoodItemCard(
                              foodItem: snapshot.data![index],
                              onAddPressed: () => _handleAddToCart(
                                  snapshot.data![index], context),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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

  const _SliverAppBarDelegate(this.tabBar);

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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
