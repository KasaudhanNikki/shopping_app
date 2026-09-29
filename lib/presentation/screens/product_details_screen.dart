import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../provider/cart_provider.dart';
import '../widgets/network_image_fallback.dart';
import '../widgets/custom_button.dart';
import '../../core/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: NetworkImageWithFallback(imageUrl: product.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.displayMedium,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: AppConstants.spacing16),
                      Text(
                        product.stockQuantity > 0 ? 'In Stock' : 'Out of Stock',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: product.stockQuantity > 0 ? theme.colorScheme.secondary : theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing24),
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.spacing8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: CustomButton(
            text: product.stockQuantity > 0 ? 'Add to Cart' : 'Out of Stock',
            onPressed: product.stockQuantity > 0
                ? () {
                    context.read<CartProvider>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} added to cart')),
                    );
                    Navigator.pop(context);
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
