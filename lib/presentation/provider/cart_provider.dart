import 'package:flutter/material.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../core/constants.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  
  double get discount {
    // Example logic: 10% discount if subtotal > 200
    if (subtotal > 200) {
      return subtotal * 0.1;
    }
    return 0;
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0;
    if (subtotal > AppConstants.freeDeliveryThreshold) return 0;
    return AppConstants.defaultDeliveryFee;
  }

  double get total => subtotal - discount + deliveryFee;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
    } else {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        _items[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
