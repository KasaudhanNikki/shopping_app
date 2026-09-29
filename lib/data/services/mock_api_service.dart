import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/constants.dart';

class MockApiService {
  Map<String, dynamic>? _cachedData;

  Future<void> _loadDataIfNeeded() async {
    if (_cachedData == null) {
      final String response = await rootBundle.loadString(AppConstants.mockDataPath);
      _cachedData = await json.decode(response);
    }
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: AppConstants.networkDelayMs));
  }

  Future<List<dynamic>> getProducts() async {
    await _loadDataIfNeeded();
    await _simulateNetworkDelay();
    return _cachedData!['products'];
  }

  Future<List<dynamic>> getCategories() async {
    await _loadDataIfNeeded();
    await _simulateNetworkDelay();
    return _cachedData!['categories'];
  }

  Future<List<dynamic>> getAddresses() async {
    await _loadDataIfNeeded();
    await _simulateNetworkDelay();
    return _cachedData!['addresses'];
  }

  // Simulate a POST request for creating an order
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    await _simulateNetworkDelay();
    // In a real app, this would send data to backend.
    // For mock, just return success.
    return {
      'success': true,
      'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
    };
  }
}
