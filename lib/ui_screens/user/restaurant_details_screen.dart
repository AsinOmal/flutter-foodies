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
    return Scaffold(
      appBar: CustomAppbar(
        title: restaurant.name,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                restaurant.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  '${restaurant.rating}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  'Delivery: ${restaurant.deliveryTime}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
