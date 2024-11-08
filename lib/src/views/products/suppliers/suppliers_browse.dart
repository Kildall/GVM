import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/supplier_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/suppliers/supplier_add.dart';
import 'package:gvm_flutter/src/views/products/suppliers/supplier_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class SuppliersBrowse extends StatefulWidget {
  const SuppliersBrowse({super.key});

  @override
  _SuppliersBrowseState createState() => _SuppliersBrowseState();
}

class _SuppliersBrowseState extends State<SuppliersBrowse> {
  bool isLoading = true;
  List<Supplier> suppliers = [];
  String? searchQuery;
  bool? filterEnabled;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    try {
      final suppliersResponse = await AuthManager.instance.apiService
          .get<GetSuppliersResponse>('/api/suppliers',
              fromJson: GetSuppliersResponse.fromJson);

      if (suppliersResponse.data != null) {
        setState(() {
          isLoading = false;
          suppliers = suppliersResponse.data!.suppliers;
        });
      }
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

  void _navigateToSupplierDetail(Supplier supplier) {
    if (supplier.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SupplierRead(supplierId: supplier.id!),
      ));
    }
  }

  void _navigateToSupplierAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SupplierAdd(),
    ));
  }

  void _clearFilters() {
    setState(() {
      searchQuery = null;
      filterEnabled = null;
    });
  }

  List<Supplier> get filteredSuppliers {
    return suppliers.where((supplier) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          supplier.name?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesEnabled =
          filterEnabled == null || supplier.enabled == filterEnabled;

      return matchesSearch && matchesEnabled;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).suppliers),
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
                    hintText: AppLocalizations.of(context).searchSuppliers,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 16),
                SegmentedButton<bool?>(
                  segments: [
                    ButtonSegment<bool?>(
                      value: null,
                      label: Text(AppLocalizations.of(context).all),
                    ),
                    ButtonSegment<bool?>(
                      value: true,
                      label: Text(AppLocalizations.of(context).enabled),
                    ),
                    ButtonSegment<bool?>(
                      value: false,
                      label: Text(AppLocalizations.of(context).disabled),
                    ),
                  ],
                  selected: {filterEnabled},
                  onSelectionChanged: (Set<bool?> newSelection) {
                    setState(() {
                      filterEnabled = newSelection.first;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : suppliers.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noSuppliersFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredSuppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = filteredSuppliers[index];
                          return _SupplierListItem(
                            supplier: supplier,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.supplierRead])
                                ? _navigateToSupplierDetail(supplier)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: AuthGuard(
        permissions: [AppPermissions.supplierAdd],
        fallback: null,
        child: FloatingActionButton(
          onPressed: _navigateToSupplierAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _SupplierListItem extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onTap;

  const _SupplierListItem({
    required this.supplier,
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
            Icons.business,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                supplier.name ?? AppLocalizations.of(context).unnamedSupplier,
                style: TextStyle(
                  color: supplier.enabled == true
                      ? null
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            if (supplier.$purchasesCount != null) ...[
              Icon(Icons.shopping_bag,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${supplier.$purchasesCount}'),
            ],
          ],
        ),
        subtitle: Text(
          supplier.enabled == true
              ? AppLocalizations.of(context).enabled
              : AppLocalizations.of(context).disabled,
          style: TextStyle(
            color: supplier.enabled == true
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.error,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
