import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/customers_responses.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:intl/intl.dart';

class SaleAdd extends StatefulWidget {
  const SaleAdd({super.key});

  @override
  _SaleAddState createState() => _SaleAddState();
}

class _SaleAddState extends State<SaleAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  int? employeeId;
  int? customerId;
  DateTime? startDate;
  SaleStatusEnum status = SaleStatusEnum.STARTED;
  List<ProductSale> selectedProducts = [];
  List<Delivery> selectedDeliveries = [];

  // Available options
  List<Employee> employees = [];
  List<Customer> customers = [];
  List<Product> availableProducts = [];

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final employeesResponse = await AuthManager.instance.apiService
          .get<GetEmployeesResponse>('/api/employees',
              fromJson: GetEmployeesResponse.fromJson);
      final customersResponse = await AuthManager.instance.apiService
          .get<GetCustomersResponse>('/api/customers',
              fromJson: GetCustomersResponse.fromJson);
      final productsResponse = await AuthManager.instance.apiService
          .get<GetProductsResponse>('/api/products',
              fromJson: GetProductsResponse.fromJson);

      setState(() {
        employees = employeesResponse.data?.employees ?? [];
        customers = customersResponse.data?.customers ?? [];
        availableProducts = productsResponse.data?.products ?? [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _createSale() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product to the sale'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final newSale = Sale(
        employeeId: employeeId,
        customerId: customerId,
        startDate: startDate,
        lastUpdateDate: DateTime.now(),
        status: status,
        products: selectedProducts,
        deliveries: selectedDeliveries,
      );

      final response = await AuthManager.instance.apiService.post(
        '/api/sales',
        body: newSale.toJson(),
        fromJson: (json) => Sale.fromJson(json['data']),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error creating sale'),
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
          title: const Text('Add Product'),
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
                      setState(() => selectedProduct = value);
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
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedProduct != null) {
                  setState(() {
                    selectedProducts.add(ProductSale(
                      productId: selectedProduct!.id,
                      quantity: quantity,
                      product: selectedProduct,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addDelivery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          title: const Text('Schedule Delivery'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Delivery Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDeliveries.add(Delivery(
                    startDate: selectedDate,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges()) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes?'),
              content:
                  const Text('Do you want to discard the current sale draft?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  bool _hasUnsavedChanges() {
    return employeeId != null ||
        customerId != null ||
        selectedProducts.isNotEmpty ||
        selectedDeliveries.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).newSale),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: isLoading ? null : _createSale,
              tooltip: AppLocalizations.of(context).createSale,
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
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildProductsCard(),
                const SizedBox(height: 16),
                _buildDeliveriesCard(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _createSale,
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
                          AppLocalizations.of(context).createSale,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
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
              AppLocalizations.of(context).basicInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).employee,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
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
                  return AppLocalizations.of(context).selectEmployee;
                }
                return null;
              },
              onChanged: (value) => setState(() => employeeId = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).customer,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              value: customerId,
              items: customers
                  .map((customer) => DropdownMenuItem(
                        value: customer.id,
                        child: Text(customer.name ?? 'Unnamed Customer'),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).selectCustomer;
                }
                return null;
              },
              onChanged: (value) => setState(() => customerId = value),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => startDate = picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).date,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  startDate != null
                      ? DateFormat('yyyy-MM-dd').format(startDate!)
                      : AppLocalizations.of(context).selectDate,
                ),
              ),
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
              AppLocalizations.of(context).status,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SaleStatusEnum>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).status,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.flag),
              ),
              value: status,
              items: SaleStatusEnum.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SalesUtils.getStatusColor(status),
                              ),
                            ),
                            Text(SalesUtils.getStatusName(context, status)),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => status = value);
                }
              },
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
                  label: Text(AppLocalizations.of(context).addProduct),
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
                  final subtotal =
                      (item.product?.price ?? 0) * (item.quantity ?? 0);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.inventory_2),
                      ),
                      title: Text(item.product?.name ??
                          AppLocalizations.of(context).unnamedProduct),
                      subtitle: Text(
                          '${AppLocalizations.of(context).quantity}: ${item.quantity} × \$${item.product?.price?.toStringAsFixed(2)} = \$${subtotal.toStringAsFixed(2)}'),
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
                    AppLocalizations.of(context).totalProducts,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${selectedProducts.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveriesCard() {
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
                  AppLocalizations.of(context).deliveries,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addDelivery,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).addDelivery),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedDeliveries.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noDeliveriesScheduled,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedDeliveries.length,
                itemBuilder: (context, index) {
                  final delivery = selectedDeliveries[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.local_shipping),
                      ),
                      title: Text(
                          '${AppLocalizations.of(context).delivery} ${index + 1}'),
                      subtitle: Text(
                          '${AppLocalizations.of(context).date}: ${delivery.startDate?.toLocal().toString().split(' ')[0] ?? AppLocalizations.of(context).noDate}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            selectedDeliveries.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _editProduct(int index) {
    final product = selectedProducts[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int quantity = product.quantity ?? 1;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).editProduct),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.product?.name ??
                        AppLocalizations.of(context).unnamedProduct,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).quantity,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? quantity;
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
              child: Text(AppLocalizations.of(context).cancel),
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
              child: Text(AppLocalizations.of(context).save),
            ),
          ],
        );
      },
    );
  }
}
