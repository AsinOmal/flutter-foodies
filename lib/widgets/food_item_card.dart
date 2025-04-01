import 'package:flutter/material.dart';
import 'package:foodies/models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAddPressed;

  const FoodItemCard({
    super.key,
    required this.item,
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
                item.imageUrl,
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
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, //!ITEM NAME
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600], //!ITEM DESCRIPTION
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 8),
                Text(
                  'LKR ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
            _AnimatedAddButton(
              onPressed: onAddPressed,
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
