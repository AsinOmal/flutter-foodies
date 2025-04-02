import 'package:flutter/material.dart';

class AnimatedCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedCartButton({super.key, required this.onPressed});

  @override
  State<AnimatedCartButton> createState() => _AnimatedCartButtonState();
}


class _AnimatedCartButtonState extends State<AnimatedCartButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
