import 'cart_item.dart';
import 'address.dart';

class Order {
  final String id;
  final DateTime date;
  final String status; // e.g. Pending, Processing, Shipped, Delivered
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final Address shippingAddress;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      items: (json['items'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      shippingAddress: Address.fromJson(json['shippingAddress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'shippingAddress': shippingAddress.toJson(),
    };
  }
}
