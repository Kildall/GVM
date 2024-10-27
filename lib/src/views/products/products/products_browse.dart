import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/products/products/product_read.dart';

class ProductsBrowse extends StatefulWidget {
  const ProductsBrowse({super.key});

  @override
  _ProductsBrowseState createState() => _ProductsBrowseState();
}

class _ProductsBrowseState extends State<ProductsBrowse> {
  bool isLoading = true;
  List<Product> products = [];
  String? searchQuery;
  String? selectedBrand;
  bool? stockFilter; // null: all, true: in stock, false: out of stock

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final productsResponse = await AuthManager.instance.apiService
          .get<GetProductsResponse>('/api/products',
              fromJson: GetProductsResponse.fromJson);

      setState(() {
        isLoading = false;
        products = productsResponse.data?.products ?? [];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

  void _navigateToProductDetail(Product product) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductRead(product: product),
    ));
  }

  void _navigateToProductAdd() {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const ProductAdd(),
    // ));
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          product.name!.toLowerCase().contains(searchQuery!.toLowerCase()) ||
          (product.brand?.toLowerCase().contains(searchQuery!.toLowerCase()) ??
              false);

      final matchesBrand =
          selectedBrand == null || product.brand == selectedBrand;

      final matchesStock = stockFilter == null ||
          (stockFilter!
              ? (product.quantity ?? 0) > 0
              : (product.quantity ?? 0) == 0);

      return matchesSearch && matchesBrand && matchesStock;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueBrands = products
        .map((p) => p.brand)
        .where((brand) => brand != null)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).products),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).searchProducts,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String?>(
                        isExpanded: true,
                        value: selectedBrand,
                        hint: Text(AppLocalizations.of(context).filterByBrand),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(AppLocalizations.of(context).all),
                          ),
                          ...uniqueBrands.map((brand) => DropdownMenuItem(
                                value: brand,
                                child: Text(brand ?? ''),
                              )),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedBrand = value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<bool?>(
                        isExpanded: true,
                        value: stockFilter,
                        hint: Text(AppLocalizations.of(context).filterByStock),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(AppLocalizations.of(context).allStock),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text(AppLocalizations.of(context).inStock),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child:
                                Text(AppLocalizations.of(context).outOfStock),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => stockFilter = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noProductsFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _ProductListItem(
                            product: product,
                            onTap: () => _navigateToProductDetail(product),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToProductAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductListItem({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = (product.quantity ?? 0) < 10;
    final bool isOutOfStock = (product.quantity ?? 0) == 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.inventory_2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                  product.name ?? AppLocalizations.of(context).unnamedProduct),
            ),
            if (isOutOfStock || isLowStock)
              Icon(
                Icons.warning,
                size: 20,
                color: isOutOfStock ? Colors.red : Colors.orange,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.brand != null) Text(product.brand!),
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context).quantity}: ${product.quantity}',
                  style: TextStyle(
                    color: isOutOfStock
                        ? Colors.red
                        : isLowStock
                            ? Colors.orange
                            : null,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${AppLocalizations.of(context).price}: \$${product.price?.toStringAsFixed(2)}',
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (product.$salesCount != null) ...[
              Icon(Icons.shopping_cart,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${product.$salesCount}'),
              const SizedBox(width: 16),
            ],
            if (product.$purchasesCount != null) ...[
              Icon(Icons.shopping_bag,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${product.$purchasesCount}'),
              const SizedBox(width: 8),
            ],
            Icon(
              product.enabled ?? true ? Icons.check_circle : Icons.cancel,
              color: (product.enabled ?? true)
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
