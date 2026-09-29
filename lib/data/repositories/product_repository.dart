import '../models/product.dart';
import '../services/mock_api_service.dart';

class ProductRepository {
  final MockApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<Product>> fetchProducts() async {
    try {
      final data = await _apiService.getProducts();
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
