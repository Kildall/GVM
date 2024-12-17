import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/purchase_requests.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/models/response/supplier_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_read.dart';
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
      if (description == null || description!.isEmpty) {
        description = AppLocalizations.of(context).noDescription;
      }
      final request = CreatePurchaseRequest(
        employeeId: employeeId!,
        supplierId: supplierId!,
        date: date!.toIso8601String(),
        amount: calculatedAmount,
        description: description!,
        products: selectedProducts
            .map((product) => PurchaseProductItem(
                  productId: product.productId!,
                  quantity: product.quantity!,
                ))
            .toList(),
      );

      final response = await AuthManager.instance.apiService.post<Purchase>(
        '/api/purchases',
        body: request.toJson(),
        fromJson: Purchase.fromJson,
      );

      if (response.success && response.data != null) {
        final createdPurchase = response.data!;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).success),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PurchaseRead(purchaseId: createdPurchase.id!)),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred),
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
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          title: Text(AppLocalizations.of(context).addProduct),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Product>(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).product,
                        border: OutlineInputBorder(),
                      ),
                      value: selectedProduct,
                      items: availableProducts
                          .map((product) => DropdownMenuItem(
                                value: product,
                                child: Text(product.name ??
                                    AppLocalizations.of(context)
                                        .unnamedProduct),
                              ))
                          .toList(),
                      onChanged: (Product? value) {
                        setState(() {
                          selectedProduct = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).quantity,
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
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
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
              child: Text(AppLocalizations.of(context).add),
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
        title: Text(AppLocalizations.of(context).add),
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
                        AppLocalizations.of(context).save,
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
              AppLocalizations.of(context).basicInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).employee,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              value: employeeId,
              items: employees
                  .map((employee) => DropdownMenuItem(
                        value: employee.id,
                        child: Text(employee.name ??
                            AppLocalizations.of(context).unnamedEmployee),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
              onChanged: (value) => setState(() => employeeId = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).supplier,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              value: supplierId,
              items: suppliers
                  .map((supplier) => DropdownMenuItem(
                        value: supplier.id,
                        child: Text(supplier.name ??
                            AppLocalizations.of(context).unnamedSupplier),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).fieldRequired;
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).date,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  date != null
                      ? DateFormat('yyyy-MM-dd').format(date!)
                      : AppLocalizations.of(context).selectDate,
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
                  AppLocalizations.of(context).products,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedProducts.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noProducts,
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
                    title: Text(item.product?.name ??
                        AppLocalizations.of(context).unnamedProduct),
                    subtitle: Text(
                        '${AppLocalizations.of(context).quantity}: ${item.quantity} × \$${item.product?.price?.toStringAsFixed(2)}'),
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
                  '${AppLocalizations.of(context).total}: \$${selectedProducts.fold<double>(0, (sum, item) => sum + (item.product?.price ?? 0) * (item.quantity ?? 0)).toStringAsFixed(2)}',
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
              AppLocalizations.of(context).additionalInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).description,
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
