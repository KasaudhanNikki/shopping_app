import 'package:flutter/material.dart';
import '../../data/models/address.dart';
import '../../data/repositories/address_repository.dart';

class AddressProvider with ChangeNotifier {
  final AddressRepository _repository;

  AddressProvider(this._repository);

  List<Address> _addresses = [];
  bool _isLoading = false;
  String _error = '';
  Address? _selectedAddress;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String get error => _error;
  Address? get selectedAddress => _selectedAddress;

  Future<void> fetchAddresses() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _addresses = await _repository.fetchAddresses();
      if (_addresses.isNotEmpty && _selectedAddress == null) {
        _selectedAddress = _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.first);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> addAddress(Address address) async {
    try {
      _isLoading = true;
      notifyListeners();
      final newAddress = await _repository.addAddress(address);
      _addresses.add(newAddress);
      
      // Auto-select if it's the first one or set as default
      if (_addresses.length == 1 || newAddress.isDefault) {
        _selectedAddress = newAddress;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      _isLoading = true;
      notifyListeners();
      final updatedAddress = await _repository.updateAddress(address);
      final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
      if (index >= 0) {
        _addresses[index] = updatedAddress;
      }
      
      if (_selectedAddress?.id == updatedAddress.id) {
        _selectedAddress = updatedAddress;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.deleteAddress(id);
      _addresses.removeWhere((a) => a.id == id);
      
      if (_selectedAddress?.id == id) {
        _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
