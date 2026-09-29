import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => onQuantityChanged(quantity - 1),
          color: Theme.of(context).primaryColor,
        ),
        Text(
          '$quantity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => onQuantityChanged(quantity + 1),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
