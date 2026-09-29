import '../models/order.dart';
import '../services/mock_api_service.dart';

class OrderRepository {
  final MockApiService _apiService;
  
  // In a real app, history would be fetched from API.
  // Here we keep it in memory for the session.
  final List<Order> _orderHistory = [];

  OrderRepository(this._apiService);

  Future<Order> placeOrder(Order order) async {
    try {
      final response = await _apiService.createOrder(order.toJson());
      if (response['success'] == true) {
        // Assign the generated ID from backend
        final newOrder = Order(
          id: response['orderId'],
          date: order.date,
          status: 'Processing',
          items: order.items,
          subtotal: order.subtotal,
          discount: order.discount,
          deliveryFee: order.deliveryFee,
          total: order.total,
          shippingAddress: order.shippingAddress,
        );
        _orderHistory.insert(0, newOrder);
        return newOrder;
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      throw Exception('Error placing order: $e');
    }
  }

  Future<List<Order>> fetchOrderHistory() async {
    // Simulating network delay for fetching history
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_orderHistory);
  }
}
