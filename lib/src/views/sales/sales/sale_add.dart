import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/helpers/validators.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/sale_requests.dart';
import 'package:gvm_flutter/src/models/response/address_responses.dart';
import 'package:gvm_flutter/src/models/response/customers_responses.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_read.dart';
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
  bool _autovalidateMode = false;

  // Form fields
  int? employeeId;
  int? customerId;
  DateTime? startDate;
  SaleStatusEnum status = SaleStatusEnum.CREATED;
  List<ProductSale> selectedProducts = [];
  List<Delivery> selectedDeliveries = [];

  // Available options
  List<Employee> employees = [];
  List<Customer> customers = [];
  List<Product> availableProducts = [];
  List<Address> addresses = [];

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
      final addressesResponse = await AuthManager.instance.apiService
          .get<GetAddressesResponse>('/api/addresses',
              fromJson: GetAddressesResponse.fromJson);

      setState(() {
        employees = employeesResponse.data?.employees ?? [];
        customers = customersResponse.data?.customers ?? [];
        availableProducts = productsResponse.data?.products ?? [];
        addresses = addressesResponse.data?.addresses ?? [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _createSale() async {
    setState(() => _autovalidateMode = true);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).fixErrors),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .emptyListError(AppLocalizations.of(context).products)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final request = CreateSaleRequest(
        employeeId: employeeId!,
        customerId: customerId!,
        products: selectedProducts
            .map((product) => SaleProductItem(
                  productId: product.productId!,
                  quantity: product.quantity!,
                ))
            .toList(),
        startDate: startDate!.toIso8601String(),
        deliveries: selectedDeliveries
            .map((delivery) => SaleDeliveryItem(
                  employeeId: delivery.employeeId!,
                  addressId: delivery.addressId!,
                  startDate: delivery.startDate!.toIso8601String(),
                ))
            .toList(),
      );

      final response = await AuthManager.instance.apiService.post(
        '/api/sales',
        body: request.toJson(),
        fromJson: (json) => Sale.fromJson(json),
      );

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).success),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SaleRead(saleId: response.data!.id!),
          ),
        );
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

  void _addDelivery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = DateTime.now();
        int? selectedEmployeeId;
        int? selectedAddressId;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).scheduleDelivery),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).employee,
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    value: selectedEmployeeId,
                    items: employees
                        .map((employee) => DropdownMenuItem(
                              value: employee.id,
                              child: Text(employee.name ??
                                  AppLocalizations.of(context).unnamedEmployee),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedEmployeeId = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).address,
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    value: selectedAddressId,
                    items: addresses
                        .where((address) => address.customerId == customerId)
                        .map((address) => DropdownMenuItem(
                              value: address.id,
                              child: Text(address.street1!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedAddressId = value);
                    },
                  ),
                  const SizedBox(height: 16),
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).deliveryDate,
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
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
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                if (selectedEmployeeId != null) {
                  setState(() {
                    selectedDeliveries.add(Delivery(
                      startDate: selectedDate,
                      employeeId: selectedEmployeeId,
                      addressId: selectedAddressId!,
                    ));
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .fieldRequired), // Assuming this translation exists
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).add),
            ),
          ],
        );
      },
    );
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Product? selectedProduct;
        int quantity = 1;
        String? errorText;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).addProduct),
          content: StatefulBuilder(
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
                              child: Text(
                                '${product.name ?? AppLocalizations.of(context).unnamedProduct}: ${product.quantity}',
                              ),
                            ))
                        .toList(),
                    onChanged: (Product? value) {
                      setState(() {
                        selectedProduct = value;
                        errorText = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).quantity,
                      border: OutlineInputBorder(),
                      errorText: errorText,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                    validator: (value) => Validators.validateNumber(value,
                        min: 1, max: selectedProduct?.quantity ?? 0),
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
                if (selectedProduct != null) {
                  if (quantity <= (selectedProduct?.quantity ?? 0)) {
                    setState(() {
                      selectedProducts.add(ProductSale(
                        productId: selectedProduct!.id,
                        quantity: quantity,
                        product: selectedProduct,
                      ));
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(AppLocalizations.of(context).add),
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
        String? errorText;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).editProduct),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${product.product?.name ?? AppLocalizations.of(context).unnamedProduct} (${AppLocalizations.of(context).available}: ${product.product?.quantity})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).quantity,
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: quantity.toString(),
                    validator: (value) => Validators.validateNumber(value,
                        min: 1, max: product.product?.quantity ?? 0),
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
                if (quantity <= (product.product?.quantity ?? 0)) {
                  setState(() {
                    selectedProducts[index] = product.copyWith(
                      quantity: quantity,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context).save),
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
              title: Text(AppLocalizations.of(context).discardChanges),
              content:
                  Text(AppLocalizations.of(context).discardChangesDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context).discard),
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
                errorStyle: const TextStyle(color: Colors.red),
              ),
              value: employeeId,
              items: employees
                  .map((employee) => DropdownMenuItem(
                        value: employee.id,
                        child: Text(employee.name ??
                            AppLocalizations.of(context).unnamedEmployee),
                      ))
                  .toList(),
              autovalidateMode: _autovalidateMode
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
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
                labelText: AppLocalizations.of(context).customer,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
                errorStyle: const TextStyle(color: Colors.red),
              ),
              value: customerId,
              items: customers
                  .map((customer) => DropdownMenuItem(
                        value: customer.id,
                        child: Text(customer.name ??
                            AppLocalizations.of(context).unnamedCustomer),
                      ))
                  .toList(),
              autovalidateMode: _autovalidateMode
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
              onChanged: (value) => setState(() => customerId = value),
            ),
            const SizedBox(height: 16),
            FormField<DateTime>(
              initialValue: startDate,
              autovalidateMode: _autovalidateMode
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
              builder: (FormFieldState<DateTime> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          field.didChange(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).date,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                          errorText: field.errorText,
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                        child: Text(
                          startDate != null
                              ? DateFormat('yyyy-MM-dd').format(startDate!)
                              : AppLocalizations.of(context).selectDate,
                        ),
                      ),
                    ),
                  ],
                );
              },
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
                errorStyle: const TextStyle(color: Colors.red),
              ),
              value: status,
              autovalidateMode: _autovalidateMode
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${AppLocalizations.of(context).date}: ${delivery.startDate?.toLocal().toString().split(' ')[0] ?? AppLocalizations.of(context).noDate}'),
                          Text(
                              '${AppLocalizations.of(context).address}: ${addresses.firstWhere((a) => a.id == delivery.addressId).street1 ?? AppLocalizations.of(context).noAddress}'),
                        ],
                      ),
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
}
