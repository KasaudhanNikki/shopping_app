import '../models/address.dart';
import '../services/mock_api_service.dart';

class AddressRepository {
  final MockApiService _apiService;
  List<Address>? _cachedAddresses;

  AddressRepository(this._apiService);

  Future<List<Address>> fetchAddresses() async {
    if (_cachedAddresses != null) return _cachedAddresses!;
    
    try {
      final data = await _apiService.getAddresses();
      _cachedAddresses = data.map((json) => Address.fromJson(json)).toList();
      return _cachedAddresses!;
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  Future<Address> addAddress(Address address) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    _cachedAddresses?.add(address);
    return address;
  }

  Future<Address> updateAddress(Address address) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    if (_cachedAddresses != null) {
      final index = _cachedAddresses!.indexWhere((a) => a.id == address.id);
      if (index >= 0) {
        _cachedAddresses![index] = address;
      }
    }
    return address;
  }

  Future<void> deleteAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    _cachedAddresses?.removeWhere((a) => a.id == id);
  }
}
