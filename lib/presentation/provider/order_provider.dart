import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _repository;

  OrderProvider(this._repository);

  List<Order> _orders = [];
  bool _isLoading = false;
  String _error = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _orders = await _repository.fetchOrderHistory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order?> placeOrder(Order order) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final newOrder = await _repository.placeOrder(order);
      _orders.insert(0, newOrder);
      return newOrder;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
