//lib/ui_screens/cart_screen.dart;

import 'package:flutter/material.dart';
import 'package:foodies/providers/cart_provider.dart';
import 'package:foodies/widgets/cart_item.dart';
import 'package:foodies/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[CartScreen] building widget');
    final cart = Provider.of<CartProvider>(context);

    debugPrint(
        '[CartScreen] Recieved ${cart.items.length} items from provider');
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Cart Screen',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, index) => CartItemCard(
                        item: cart.items[index],
                        onIncrement: () => cart
                            .incrementQuantity(cart.items[index].foodItem.id),
                        onDecrement: () => cart
                            .decrementQuantity(cart.items[index].foodItem.id),
                        onRemove: () =>
                            cart.removeItem(cart.items[index].foodItem.id),
                      ),
                    )),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'LKR ${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
