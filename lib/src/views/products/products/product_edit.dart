import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/product_requests.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class ProductEdit extends StatefulWidget {
  final Product product;

  const ProductEdit({
    super.key,
    required this.product,
  });

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  late String? name;
  late int? quantity;
  late double? measure;
  late String? brand;
  late double? price;
  late bool enabled;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing product data
    name = widget.product.name;
    quantity = widget.product.quantity;
    measure = widget.product.measure;
    brand = widget.product.brand;
    price = widget.product.price;
    enabled = widget.product.enabled ?? true;
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final request = UpdateProductRequest(
        productId: widget.product.id!,
        brand: brand!,
        measure: measure!.toInt(),
        name: name!,
        price: price!,
        quantity: quantity!,
      );

      // Assuming you have a similar API service setup
      final response = await AuthManager.instance.apiService.put(
        '/api/products',
        body: request.toJson(),
        fromJson: Product.fromJson,
      );

      if (response.success && response.data != null) {
        final updatedProduct = response.data!;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, updatedProduct);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating product'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges()) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'),
              content: Text(
                  'You have unsaved changes. Do you want to discard them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  bool _hasChanges() {
    return name != widget.product.name ||
        quantity != widget.product.quantity ||
        measure != widget.product.measure ||
        brand != widget.product.brand ||
        price != widget.product.price ||
        enabled != widget.product.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: isLoading ? null : _updateProduct,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoCard(),
                const SizedBox(height: 16),
                _buildPricingCard(),
                const SizedBox(height: 16),
                _buildStatusCard(),
                const SizedBox(height: 24),
                if (_hasChanges()) ...[
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Save Changes',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory),
              ),
              initialValue: name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product name is required';
                }
                return null;
              },
              onChanged: (value) => setState(() => name = value),
              onSaved: (value) => name = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.branding_watermark),
              ),
              initialValue: brand,
              onChanged: (value) => setState(() => brand = value),
              onSaved: (value) => brand = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing & Quantity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    initialValue: price?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        setState(() => price = double.tryParse(value)),
                    onSaved: (value) => price = double.tryParse(value ?? ''),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    initialValue: quantity?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity is required';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        setState(() => quantity = int.tryParse(value)),
                    onSaved: (value) => quantity = int.tryParse(value ?? ''),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Measure',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              initialValue: measure?.toString() ?? '',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              onChanged: (value) =>
                  setState(() => measure = double.tryParse(value)),
              onSaved: (value) => measure = double.tryParse(value ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Product Enabled'),
              subtitle: Text(
                'Enable or disable this product',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: enabled,
              onChanged: (bool value) {
                setState(() {
                  enabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
