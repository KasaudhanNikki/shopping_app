import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../widgets/network_image_fallback.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/custom_button.dart';
import '../widgets/empty_state.dart';
import '../../core/constants.dart';
import 'address_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final theme = Theme.of(context);

    if (cartProvider.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: const EmptyState(
          message: 'Your cart is empty.\nStart shopping!',
          icon: Icons.remove_shopping_cart,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => context.read<CartProvider>().clearCart(),
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        itemCount: cartProvider.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing16),
        itemBuilder: (context, index) {
          final item = cartProvider.items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacing8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radius12),
                    child: NetworkImageWithFallback(
                      imageUrl: item.product.imageUrl,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.spacing4),
                        Text(
                          '\$${item.product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing8),
                        QuantitySelector(
                          quantity: item.quantity,
                          onQuantityChanged: (newQ) => context.read<CartProvider>().updateQuantity(item.product.id, newQ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacing24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('Subtotal', cartProvider.subtotal, theme),
              const SizedBox(height: AppConstants.spacing8),
              _buildSummaryRow('Discount', -cartProvider.discount, theme, isDiscount: true),
              const SizedBox(height: AppConstants.spacing8),
              _buildSummaryRow('Delivery', cartProvider.deliveryFee, theme),
              const Divider(height: AppConstants.spacing24),
              _buildSummaryRow('Total', cartProvider.total, theme, isTotal: true),
              const SizedBox(height: AppConstants.spacing24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Proceed to Checkout',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddressScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, ThemeData theme, {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? theme.textTheme.titleLarge : theme.textTheme.bodyLarge,
        ),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: isTotal 
              ? theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor)
              : theme.textTheme.bodyLarge?.copyWith(color: isDiscount ? theme.colorScheme.error : null),
        ),
      ],
    );
  }
}
