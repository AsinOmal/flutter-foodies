import 'package:flutter/material.dart';
import 'package:foodies/models/restaurant.dart';
import 'package:foodies/widgets/custom_appbar.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppbar(
          title: restaurant.name,
          showBackButton: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant_menu)),
              Tab(icon: Icon(Icons.reviews)),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildRestaurantInfoTab(context),
            const Center(child: Text('Reviews coming soon')),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfoTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                restaurant.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(width: 4),
                Text(
                  '${restaurant.rating}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width:20),
                Text(
                  restaurant.deliveryTime,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.credit_card, 'Delivery Fee',
                        restaurant.deliveryFee),
                    _buildInfoRow(Icons.phone, 'Contact', '+9476 230 2567'),
                    _buildInfoRow(Icons.location_on, 'Location',
                        '123, Food Street, Colombo')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
