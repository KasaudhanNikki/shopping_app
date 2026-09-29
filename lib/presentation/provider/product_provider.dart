import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final List<dynamic> _categories = [];
  
  bool _isLoading = false;
  String _error = '';
  
  String _searchQuery = '';
  String? _selectedCategoryId;

  List<Product> get products => _filteredProducts;
  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  String? get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchProductsAndCategories() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Assuming repository has a way to get categories too.
      // For this mock, we just fetch products. 
      // Categories could be extracted from mock_api_service directly or via a new repo.
      _products = await _repository.fetchProducts();
      _filteredProducts = _products;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryId == null || product.categoryId == _selectedCategoryId;
      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }

  void sortProducts(String criterion) {
    if (criterion == 'price_asc') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (criterion == 'price_desc') {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (criterion == 'rating') {
      _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }
    notifyListeners();
  }
}
