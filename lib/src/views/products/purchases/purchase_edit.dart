import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/models/response/supplier_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:intl/intl.dart';

class PurchaseEdit extends StatefulWidget {
  final Purchase purchase;

  const PurchaseEdit({
    super.key,
    required this.purchase,
  });

  @override
  _PurchaseEditState createState() => _PurchaseEditState();
}

class _PurchaseEditState extends State<PurchaseEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  late int? employeeId;
  late int? supplierId;
  late DateTime? date;
  late String? description;
  late List<PurchaseProduct> selectedProducts;

  // Available options
  List<Employee> employees = [];
  List<Supplier> suppliers = [];
  List<Product> availableProducts = [];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing purchase data
    employeeId = widget.purchase.employeeId;
    supplierId = widget.purchase.supplierId;
    date = widget.purchase.date;
    description = widget.purchase.description;
    selectedProducts =
        List<PurchaseProduct>.from(widget.purchase.products ?? []);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final employeesResponse = await AuthManager.instance.apiService
          .get<GetEmployeesResponse>('/api/employees',
              fromJson: GetEmployeesResponse.fromJson);
      final suppliersResponse = await AuthManager.instance.apiService
          .get<GetSuppliersResponse>('/api/suppliers',
              fromJson: GetSuppliersResponse.fromJson);
      final productsResponse = await AuthManager.instance.apiService
          .get<GetProductsResponse>('/api/products',
              fromJson: GetProductsResponse.fromJson);

      setState(() {
        employees = employeesResponse.data?.employees ?? [];
        suppliers = suppliersResponse.data?.suppliers ?? [];
        availableProducts = productsResponse.data?.products ?? [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updatePurchase() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // Calculate total amount from products
    final calculatedAmount = selectedProducts.fold<double>(
      0,
      (sum, item) => sum + (item.product?.price ?? 0) * (item.quantity ?? 0),
    );

    setState(() => isLoading = true);
    try {
      final updatedPurchase = widget.purchase.copyWith(
        employeeId: employeeId,
        supplierId: supplierId,
        date: date,
        amount: calculatedAmount,
        description: description,
        products: selectedProducts,
      );

      final response = await AuthManager.instance.apiService.put(
        '/api/purchases/${widget.purchase.id}',
        body: updatedPurchase.toJson(),
        fromJson: (json) => Purchase.fromJson(json['data']),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating purchase'),
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

  void _addProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Product? selectedProduct;
        int quantity = 1;
        double price = 0;

        return AlertDialog(
          title: Text('Add Product'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Product>(
                    decoration: const InputDecoration(
                      labelText: 'Product',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedProduct,
                    items: availableProducts
                        .map((product) => DropdownMenuItem(
                              value: product,
                              child: Text(product.name ?? 'Unnamed Product'),
                            ))
                        .toList(),
                    onChanged: (Product? value) {
                      setState(() {
                        selectedProduct = value;
                        if (value?.price != null) {
                          price = value!.price!;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: price.toString(),
                    onChanged: (value) {
                      setState(() {
                        price = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedProduct != null) {
                  setState(() {
                    selectedProducts.add(PurchaseProduct(
                      productId: selectedProduct!.id,
                      quantity: quantity,
                      product: selectedProduct,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(int index) {
    final product = selectedProducts[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int quantity = product.quantity ?? 1;
        double price = product.product?.price ?? 0;

        return AlertDialog(
          title: Text('Edit Product'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.product?.name ?? 'Unnamed Product',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? quantity;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: price.toString(),
                    onChanged: (value) {
                      setState(() {
                        price = double.tryParse(value) ?? price;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedProducts[index] = product.copyWith(
                    quantity: quantity,
                  );
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
    return employeeId != widget.purchase.employeeId ||
        supplierId != widget.purchase.supplierId ||
        date != widget.purchase.date ||
        description != widget.purchase.description ||
        !_areProductListsEqual(
            selectedProducts, widget.purchase.products ?? []);
  }

  bool _areProductListsEqual(
      List<PurchaseProduct> list1, List<PurchaseProduct> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].productId != list2[i].productId ||
          list1[i].quantity != list2[i].quantity) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Purchase'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: isLoading ? null : _updatePurchase,
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
                _buildProductsCard(),
                const SizedBox(height: 16),
                _buildDescriptionCard(),
                const SizedBox(height: 24),
                if (_hasChanges()) ...[
                  ElevatedButton(
                    onPressed: isLoading ? null : _updatePurchase,
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
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Employee',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              value: employeeId,
              items: employees
                  .map((employee) => DropdownMenuItem(
                        value: employee.id,
                        child: Text(employee.name ?? 'Unnamed Employee'),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select an employee';
                }
                return null;
              },
              onChanged: (value) => setState(() => employeeId = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Supplier',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              value: supplierId,
              items: suppliers
                  .map((supplier) => DropdownMenuItem(
                        value: supplier.id,
                        child: Text(supplier.name ?? 'Unnamed Supplier'),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select a supplier';
                }
                return null;
              },
              onChanged: (value) => setState(() => supplierId = value),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => date = picked);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  date != null
                      ? DateFormat('yyyy-MM-dd').format(date!)
                      : 'Select date',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedProducts.isEmpty)
              Center(
                child: Text(
                  'No products added',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final item = selectedProducts[index];
                  final subtotal =
                      (item.product?.price ?? 0) * (item.quantity ?? 0);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(item.product?.name ?? 'Unnamed Product'),
                      subtitle: Text(
                          'Quantity: ${item.quantity} × \$${item.product?.price?.toStringAsFixed(2)} = \$${subtotal.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editProduct(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                selectedProducts.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (selectedProducts.isNotEmpty) ...[
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '\$${selectedProducts.fold<double>(0, (sum, item) => sum + (item.product?.price ?? 0) * (item.quantity ?? 0)).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Summary of changes if any
              if (_hasProductChanges()) ...[
                const Divider(height: 32),
                Text(
                  'Changes Summary:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                _buildChangesSummary(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  bool _hasProductChanges() {
    return !_areProductListsEqual(
        selectedProducts, widget.purchase.products ?? []);
  }

  Widget _buildChangesSummary() {
    final originalProducts = widget.purchase.products ?? [];
    final currentProducts = selectedProducts;

    // Find added products
    final addedProducts = currentProducts.where((current) => !originalProducts
        .any((original) => original.productId == current.productId));

    // Find removed products
    final removedProducts = originalProducts.where((original) =>
        !currentProducts
            .any((current) => current.productId == original.productId));

    // Find modified products
    final modifiedProducts = currentProducts.where((current) {
      final original = originalProducts.firstWhere(
        (original) => original.productId == current.productId,
        orElse: () => PurchaseProduct(),
      );
      return original.productId != null &&
          (current.quantity != original.quantity);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (addedProducts.isNotEmpty) ...[
          Text('Added:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.green)),
          ...addedProducts.map((p) => Text(
              '• ${p.product?.name} (${p.quantity} × \$${p.product?.price?.toStringAsFixed(2)})')),
        ],
        if (removedProducts.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Removed:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red)),
          ...removedProducts.map((p) => Text(
              '• ${p.product?.name} (${p.quantity} × \$${p.product?.price?.toStringAsFixed(2)})')),
        ],
        if (modifiedProducts.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Modified:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.orange)),
          ...modifiedProducts.map((current) {
            final original = originalProducts
                .firstWhere((o) => o.productId == current.productId);
            return Text(
                '• ${current.product?.name}: ${original.quantity} → ${current.quantity}, \$${original.product?.price?.toStringAsFixed(2)} → \$${current.product?.price?.toStringAsFixed(2)}');
          }),
        ],
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                hintText: 'Enter any additional notes or comments',
              ),
              initialValue: description,
              maxLines: 3,
              onChanged: (value) => setState(() => description = value),
            ),
          ],
        ),
      ),
    );
  }
}
