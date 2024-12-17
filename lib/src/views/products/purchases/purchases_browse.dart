import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/purchase_response.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_add.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class PurchasesBrowse extends StatefulWidget {
  const PurchasesBrowse({super.key});

  @override
  _PurchasesBrowseState createState() => _PurchasesBrowseState();
}

class _PurchasesBrowseState extends State<PurchasesBrowse>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  List<Purchase> purchases = [];
  String? searchQuery;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int? selectedSupplierId;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  @override
  Future<void> refresh() async {
    await _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    try {
      final purchasesResponse = await AuthManager.instance.apiService
          .get<GetPurchasesResponse>('/api/purchases',
              fromJson: GetPurchasesResponse.fromJson);

      setState(() {
        isLoading = false;
        purchases = purchasesResponse.data?.purchases ?? [];
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

  void _navigateToPurchaseDetail(Purchase purchase) {
    if (purchase.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PurchaseRead(purchaseId: purchase.id!),
      ));
    }
  }

  void _navigateToPurchaseAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PurchaseAdd(),
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
      selectedSupplierId = null;
    });
  }

  List<Purchase> get filteredPurchases {
    return purchases.where((purchase) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          purchase.description
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true ||
          purchase.supplier?.name
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true ||
          purchase.employee?.name
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesDateRange = (selectedStartDate == null ||
              purchase.date?.isAfter(selectedStartDate!) == true) &&
          (selectedEndDate == null ||
              purchase.date?.isBefore(
                      selectedEndDate!.add(const Duration(days: 1))) ==
                  true);

      final matchesSupplier = selectedSupplierId == null ||
          purchase.supplierId == selectedSupplierId;

      return matchesSearch && matchesDateRange && matchesSupplier;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).purchases),
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
                    hintText: AppLocalizations.of(context).searchPurchases,
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
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : purchases.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noPurchasesFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredPurchases.length,
                        itemBuilder: (context, index) {
                          final purchase = filteredPurchases[index];
                          return _PurchaseListItem(
                            purchase: purchase,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.purchaseRead])
                                ? _navigateToPurchaseDetail(purchase)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: AuthGuard(
        permissions: [
          AppPermissions.purchaseAdd,
          AppPermissions.employeeBrowse,
          AppPermissions.productBrowse,
          AppPermissions.supplierBrowse,
        ],
        allPermissions: true,
        fallback: null,
        child: FloatingActionButton(
          onPressed: _navigateToPurchaseAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _PurchaseListItem extends StatelessWidget {
  final Purchase purchase;
  final VoidCallback onTap;

  const _PurchaseListItem({
    required this.purchase,
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
            Icons.shopping_bag,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                  '${AppLocalizations.of(context).purchase} #${purchase.id.toString().padLeft(4, '0')}'),
            ),
            Text(
              '\$${purchase.amount?.toStringAsFixed(2) ?? '0.00'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (purchase.date != null)
              Text(purchase.date!.toLocal().toString().split(' ')[0]),
            Row(
              children: [
                Expanded(
                  child: Text(
                    purchase.supplier?.name ??
                        AppLocalizations.of(context).unknownSupplier,
                  ),
                ),
                const SizedBox(width: 8),
                if (purchase.$productsCount != null) ...[
                  Icon(Icons.inventory_2,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${purchase.$productsCount}'),
                ],
              ],
            ),
            if (purchase.description != null) Text(purchase.description!),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
