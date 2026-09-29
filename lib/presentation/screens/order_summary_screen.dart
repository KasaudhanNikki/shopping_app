import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/address_provider.dart';
import '../provider/order_provider.dart';
import '../../data/models/order.dart';
import '../widgets/custom_button.dart';
import '../../core/constants.dart';
import 'order_success_screen.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final addressProvider = context.watch<AddressProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(addressProvider.selectedAddress!.street, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('${addressProvider.selectedAddress!.city}, ${addressProvider.selectedAddress!.state} ${addressProvider.selectedAddress!.zipCode}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),
            Text('Items', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.spacing16),
                itemCount: cartProvider.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.product.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.spacing24),
            Text('Payment Summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Column(
                  children: [
                    _buildRow('Subtotal', cartProvider.subtotal),
                    const SizedBox(height: 8),
                    _buildRow('Discount', -cartProvider.discount),
                    const SizedBox(height: 8),
                    _buildRow('Delivery', cartProvider.deliveryFee),
                    const Divider(height: 24),
                    _buildRow('Total', cartProvider.total, isTotal: true, theme: theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: CustomButton(
            text: 'Place Order',
            isLoading: orderProvider.isLoading,
            onPressed: () async {
              final newOrder = Order(
                id: '', // Will be set by backend
                date: DateTime.now(),
                status: 'Processing',
                items: cartProvider.items,
                subtotal: cartProvider.subtotal,
                discount: cartProvider.discount,
                deliveryFee: cartProvider.deliveryFee,
                total: cartProvider.total,
                shippingAddress: addressProvider.selectedAddress!,
              );
              
              final placedOrder = await context.read<OrderProvider>().placeOrder(newOrder);
              
              if (placedOrder != null && context.mounted) {
                context.read<CartProvider>().clearCart();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
                  (route) => route.isFirst,
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(orderProvider.error)),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isTotal = false, ThemeData? theme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? theme!.textTheme.titleLarge : const TextStyle(fontSize: 16),
        ),
        Text(
          '${amount < 0 ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: isTotal 
              ? theme!.textTheme.titleLarge?.copyWith(color: theme.primaryColor)
              : const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
