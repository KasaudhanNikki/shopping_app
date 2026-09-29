import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state.dart';
import '../../core/constants.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';

class ProductCatalogueScreen extends StatefulWidget {
  const ProductCatalogueScreen({super.key});

  @override
  State<ProductCatalogueScreen> createState() => _ProductCatalogueScreenState();
}

class _ProductCatalogueScreenState extends State<ProductCatalogueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProductsAndCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    onChanged: (value) =>
                        context.read<ProductProvider>().search(value),
                  ),
                ),
                const SizedBox(width: AppConstants.spacing16),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (value) =>
                      context.read<ProductProvider>().sortProducts(value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'price_asc',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_desc',
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Top Rated'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: productProvider.isLoading
                ? const LoadingWidget()
                : productProvider.error.isNotEmpty
                ? EmptyState(
                    message: productProvider.error,
                    icon: Icons.error_outline,
                    onRetry: () => productProvider.fetchProductsAndCategories(),
                  )
                : productProvider.products.isEmpty
                ? const EmptyState(message: 'No products found.')
                : GridView.builder(
                    padding: const EdgeInsets.all(AppConstants.spacing16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: AppConstants.spacing16,
                          mainAxisSpacing: AppConstants.spacing16,
                        ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        onAddToCart: () {
                          context.read<CartProvider>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
