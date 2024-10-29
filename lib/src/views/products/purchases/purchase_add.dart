import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/models/response/supplier_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:intl/intl.dart';

class PurchaseAdd extends StatefulWidget {
  const PurchaseAdd({super.key});

  @override
  _PurchaseAddState createState() => _PurchaseAddState();
}

class _PurchaseAddState extends State<PurchaseAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  int? employeeId;
  int? supplierId;
  DateTime? date = DateTime.now();
  double? amount;
  String? description;
  List<PurchaseProduct> selectedProducts = [];

  // Available options
  List<Employee> employees = [];
  List<Supplier> suppliers = [];
  List<Product> availableProducts = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      // Load employees, suppliers, and products
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

  Future<void> _savePurchase() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // Calculate total amount from products
    final calculatedAmount = selectedProducts.fold<double>(
      0,
      (sum, item) => sum + (item.product?.price ?? 0) * (item.quantity ?? 0),
    );

    setState(() => isLoading = true);
    try {
      final newPurchase = Purchase(
        employeeId: employeeId,
        supplierId: supplierId,
        date: date,
        amount: calculatedAmount,
        description: description,
        products: selectedProducts,
      );

      await AuthManager.instance.apiService.post(
        '/api/purchases',
        body: newPurchase.toJson(),
        fromJson: (json) => Purchase.fromJson(json['data']),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating purchase'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Purchase'),
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
              ElevatedButton(
                onPressed: isLoading ? null : _savePurchase,
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
                        'Save Purchase',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
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
                  return ListTile(
                    title: Text(item.product?.name ?? 'Unnamed Product'),
                    subtitle: Text(
                        'Quantity: ${item.quantity} × \$${item.product?.price?.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          selectedProducts.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            if (selectedProducts.isNotEmpty) ...[
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: \$${selectedProducts.fold<double>(0, (sum, item) => sum + (item.product?.price ?? 0) * (item.quantity ?? 0)).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ],
        ),
      ),
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
              ),
              maxLines: 3,
              onSaved: (value) => description = value,
            ),
          ],
        ),
      ),
    );
  }
}
