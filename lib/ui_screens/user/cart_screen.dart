import 'package:flutter/material.dart';
import 'package:foodies/providers/cart_provider.dart';
import 'package:foodies/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: CustomAppbar(
        title: 'View Cart',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Browse restaurants and add some delicious food!',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context); // Return to previous screen
                          },
                          child: const Text('Explore Restaurants'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) => CartItemCard(
                      item: cart.items[index],
                      onDecrement: () =>
                          cart.decrementItem(cart.items[index].foodItem.id),
                      onIncrement: () =>
                          cart.incrementItem(cart.items[index].foodItem.id),
                      onRemove: () =>
                          cart.removeItem(cart.items[index].foodItem.id),
                    ),
                  ),
          ),
          if (cart.items
              .isNotEmpty) // Only show total and checkout if cart has items
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'LKR ${cart.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/order-confirmation'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
