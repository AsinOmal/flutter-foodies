import 'package:flutter/material.dart';
import 'package:foodies/models/food_item.dart';
import 'package:foodies/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onAddPressed;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            //!image section
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                foodItem.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[600],
                  child: Icon(Icons.fastfood),
                ),
              ),
            ),
            SizedBox(width: 16),

            //!text section
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, //!ITEM NAME
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  foodItem.description,
                  style: TextStyle(
                    color: Colors.grey[600], //!ITEM DESCRIPTION
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 8),
                Text(
                  'LKR ${foodItem.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
            IconButton(
              onPressed: () {
                final cart = Provider.of<CartProvider>(context, listen: false);
                cart.addItem(foodItem);
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class _AnimatedAddButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedAddButton({required this.onPressed});

  @override
  __AnimatedAddButtonState createState() => __AnimatedAddButtonState();
}

class __AnimatedAddButtonState extends State<_AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: const Icon(Icons.add_circle),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onPressed();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
