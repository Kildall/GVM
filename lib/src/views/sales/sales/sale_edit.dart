import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/sale_requests.dart';
import 'package:gvm_flutter/src/models/response/customers_responses.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_read.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:intl/intl.dart';

class SaleEdit extends StatefulWidget {
  final Sale sale;

  const SaleEdit({
    super.key,
    required this.sale,
  });

  @override
  _SaleEditState createState() => _SaleEditState();
}

class _SaleEditState extends State<SaleEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  late int? employeeId;
  late int? customerId;
  late DateTime? startDate;
  late DateTime? lastUpdateDate;
  late SaleStatusEnum? status;
  late List<ProductSale> selectedProducts;
  late List<Delivery> selectedDeliveries;

  // Available options
  List<Employee> employees = [];
  List<Customer> customers = [];
  List<Product> availableProducts = [];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing sale data
    employeeId = widget.sale.employeeId;
    customerId = widget.sale.customerId;
    startDate = widget.sale.startDate;
    lastUpdateDate = widget.sale.lastUpdateDate ?? DateTime.now();
    status = widget.sale.status;
    selectedProducts = List<ProductSale>.from(widget.sale.products ?? []);
    selectedDeliveries = List<Delivery>.from(widget.sale.deliveries ?? []);
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

  Future<void> _updateSale() async {
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
      final request = UpdateSaleRequest(
        saleId: widget.sale.id!,
        products: selectedProducts
            .map((product) => SaleProductItem(
                  productId: product.productId!,
                  quantity: product.quantity!,
                ))
            .toList(),
        status: status!,
        employeeId: employeeId!,
        customerId: customerId!,
        startDate: startDate!.toIso8601String(),
      );

      final response = await AuthManager.instance.apiService.put(
        '/api/sales',
        body: request.toJson(),
        fromJson: (json) => Sale.fromJson(json),
      );

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

  void _addProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Product? selectedProduct;
        int quantity = 1;

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
                              child: Text(product.name ??
                                  AppLocalizations.of(context).unnamedProduct),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
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
              child: Text(AppLocalizations.of(context).add),
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
          title: Text(AppLocalizations.of(context).addDelivery),
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
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).deliveryDate,
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
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDeliveries.add(Delivery(
                    startDate: selectedDate,
                    saleId: widget.sale.id,
                  ));
                });
                Navigator.pop(context);
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

  bool _hasChanges() {
    return employeeId != widget.sale.employeeId ||
        customerId != widget.sale.customerId ||
        startDate != widget.sale.startDate ||
        status != widget.sale.status ||
        !_areProductListsEqual(selectedProducts, widget.sale.products ?? []) ||
        !_areDeliveryListsEqual(
            selectedDeliveries, widget.sale.deliveries ?? []);
  }

  bool _areProductListsEqual(List<ProductSale> list1, List<ProductSale> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].productId != list2[i].productId ||
          list1[i].quantity != list2[i].quantity) {
        return false;
      }
    }
    return true;
  }

  bool _areDeliveryListsEqual(List<Delivery> list1, List<Delivery> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].startDate != list2[i].startDate) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges()) {
          return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).discardChanges),
                  content: Text(
                      AppLocalizations.of(context).discardChangesDescription),
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
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editSale),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: isLoading ? null : _updateSale,
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
                if (_hasChanges()) ...[
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateSale,
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
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              value: customerId,
              items: customers
                  .map((customer) => DropdownMenuItem(
                        value: customer.id,
                        child: Text(customer.name ??
                            AppLocalizations.of(context).unnamedCustomer),
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
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => startDate = picked);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).startDate,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
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
                labelText: AppLocalizations.of(context).saleStatus,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
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
              validator: (value) {
                if (value == null) {
                  return AppLocalizations.of(context).selectStatus;
                }
                return null;
              },
              onChanged: (value) => setState(() => status = value),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context).lastUpdate}: ${DateFormat('yyyy-MM-dd HH:mm').format(lastUpdateDate ?? DateTime.now())}',
              style: Theme.of(context).textTheme.bodySmall,
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
                  AppLocalizations.of(context).noProductsFound,
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
                    AppLocalizations.of(context).total,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '\$ ${selectedProducts.fold(0.0, (sum, product) => sum + (product.product?.price ?? 0) * (product.quantity ?? 0))}',
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
}
