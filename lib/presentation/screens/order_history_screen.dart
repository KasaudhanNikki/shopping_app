import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/order_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state.dart';
import '../../core/constants.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orderProvider.isLoading
          ? const LoadingWidget()
          : orderProvider.error.isNotEmpty
              ? EmptyState(
                  message: orderProvider.error,
                  onRetry: () => orderProvider.fetchOrders(),
                )
              : orderProvider.orders.isEmpty
                  ? const EmptyState(message: 'You have no past orders.')
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      itemCount: orderProvider.orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing16),
                      itemBuilder: (context, index) {
                        final order = orderProvider.orders[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppConstants.spacing16),
                            title: Text('Order #${order.id}', style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM dd, yyyy').format(order.date)),
                                const SizedBox(height: 4),
                                Text(
                                  order.status,
                                  style: TextStyle(
                                    color: order.status == 'Delivered' ? Colors.green : Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
