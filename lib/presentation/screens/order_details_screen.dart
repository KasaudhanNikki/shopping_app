import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/order.dart';
import '../../core/constants.dart';
import '../widgets/network_image_fallback.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.id}', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Placed on ${DateFormat('MMM dd, yyyy - hh:mm a').format(order.date)}'),
            const SizedBox(height: AppConstants.spacing24),
            
            Text('Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.spacing8),
            Chip(
              label: Text(order.status),
              backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.spacing24),
            
            Text('Items', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: NetworkImageWithFallback(imageUrl: item.product.imageUrl, width: 50, height: 50),
                    ),
                    title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text('\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppConstants.spacing24),
            Text('Shipping Address', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.spacing8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.shippingAddress.street, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.zipCode}'),
                    ],
                  ),
                ),
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
                    _buildRow('Subtotal', order.subtotal),
                    const SizedBox(height: 8),
                    _buildRow('Discount', -order.discount),
                    const SizedBox(height: 8),
                    _buildRow('Delivery', order.deliveryFee),
                    const Divider(height: 24),
                    _buildRow('Total', order.total, isTotal: true, theme: theme),
                  ],
                ),
              ),
            ),
          ],
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
