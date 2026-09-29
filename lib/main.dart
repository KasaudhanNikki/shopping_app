import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/services/mock_api_service.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/address_repository.dart';
import 'data/repositories/order_repository.dart';
import 'presentation/provider/product_provider.dart';
import 'presentation/provider/cart_provider.dart';
import 'presentation/provider/address_provider.dart';
import 'presentation/provider/order_provider.dart';
import 'presentation/screens/product_catalogue_screen.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Services
    final mockApiService = MockApiService();
    
    /// Repositories
    final productRepository = ProductRepository(mockApiService);
    final addressRepository = AddressRepository(mockApiService);
    final orderRepository = OrderRepository(mockApiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(addressRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(orderRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ProductCatalogueScreen(),
      ),
    );
  }
}
