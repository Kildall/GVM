import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/sale_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_add.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_read.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class SalesBrowse extends StatefulWidget {
  const SalesBrowse({super.key});

  @override
  _SalesBrowseState createState() => _SalesBrowseState();
}

class _SalesBrowseState extends State<SalesBrowse> {
  bool isLoading = true;
  List<Sale> sales = [];
  String? searchQuery;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int? selectedCustomerId;
  SaleStatusEnum? selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    try {
      final salesResponse = await AuthManager.instance.apiService
          .get<GetSalesResponse>('/api/sales',
              fromJson: GetSalesResponse.fromJson);

      setState(() {
        isLoading = false;
        sales = salesResponse.data?.sales ?? [];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred)));
      }
    }
  }

  void _navigateToSaleDetail(Sale sale) {
    if (sale.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SaleRead(saleId: sale.id!),
      ));
    }
  }

  void _navigateToSaleAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SaleAdd(),
    ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      searchQuery = null;
      selectedStartDate = null;
      selectedEndDate = null;
      selectedCustomerId = null;
      selectedStatus = null;
    });
  }

  List<Sale> get filteredSales {
    return sales.where((sale) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          sale.customer?.name
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true ||
          sale.employee?.name
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesDateRange = (selectedStartDate == null ||
              sale.startDate?.isAfter(selectedStartDate!) == true) &&
          (selectedEndDate == null ||
              sale.startDate?.isBefore(
                      selectedEndDate!.add(const Duration(days: 1))) ==
                  true);

      final matchesCustomer =
          selectedCustomerId == null || sale.customerId == selectedCustomerId;

      final matchesStatus =
          selectedStatus == null || sale.status == selectedStatus;

      return matchesSearch &&
          matchesDateRange &&
          matchesCustomer &&
          matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sales),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: _clearFilters,
            tooltip: AppLocalizations.of(context).clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).searchSales,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectStartDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedStartDate != null
                            ? AppLocalizations.of(context).fromDate(
                                selectedStartDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0])
                            : AppLocalizations.of(context).startDate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectEndDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedEndDate != null
                            ? AppLocalizations.of(context).toDate(
                                selectedEndDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0])
                            : AppLocalizations.of(context).endDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<SaleStatusEnum>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).status,
                    border: const OutlineInputBorder(),
                  ),
                  value: selectedStatus,
                  items: SaleStatusEnum.values
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.name),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedStatus = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : sales.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noSalesFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredSales.length,
                        itemBuilder: (context, index) {
                          final sale = filteredSales[index];
                          return _SaleListItem(
                            sale: sale,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.saleRead])
                                ? _navigateToSaleDetail(sale)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: AuthGuard(
        permissions: [
          AppPermissions.saleAdd,
          AppPermissions.customerBrowse,
          AppPermissions.employeeBrowse,
          AppPermissions.productBrowse,
          AppPermissions.deliveryBrowse,
          AppPermissions.addressBrowse,
        ],
        allPermissions: true,
        fallback: null,
        child: FloatingActionButton(
          onPressed: _navigateToSaleAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _SaleListItem extends StatelessWidget {
  final Sale sale;
  final VoidCallback onTap;

  const _SaleListItem({
    required this.sale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text('${AppLocalizations.of(context).sale} #${sale.id}'),
            ),
            if (sale.status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: SalesUtils.getStatusColor(sale.status!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  SalesUtils.getStatusName(context, sale.status!),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sale.startDate != null)
              Text(sale.startDate!.toLocal().toString().split(' ')[0]),
            Row(
              children: [
                Expanded(
                  child: Text(
                    sale.customer?.name ??
                        AppLocalizations.of(context).unnamedCustomer,
                  ),
                ),
                const SizedBox(width: 8),
                if (sale.$productsCount != null) ...[
                  Icon(Icons.inventory_2,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${sale.$productsCount}'),
                ],
                if (sale.$deliveriesCount != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.local_shipping,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${sale.$deliveriesCount}'),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
