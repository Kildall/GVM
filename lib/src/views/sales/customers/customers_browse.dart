import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/customers_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_add.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class CustomersBrowse extends StatefulWidget {
  const CustomersBrowse({super.key});

  @override
  _CustomersBrowseState createState() => _CustomersBrowseState();
}

class _CustomersBrowseState extends State<CustomersBrowse> {
  bool isLoading = true;
  List<Customer> customers = [];
  String? searchQuery;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool? selectedEnabled;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final customersResponse = await AuthManager.instance.apiService
          .get<GetCustomersResponse>('/api/customers',
              fromJson: GetCustomersResponse.fromJson);

      setState(() {
        isLoading = false;
        customers = customersResponse.data?.customers ?? [];
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

  void _navigateToCustomerDetail(Customer customer) {
    if (customer.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomerRead(customerId: customer.id!),
      ));
    }
  }

  void _navigateToCustomerAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CustomerAdd(),
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
      selectedEnabled = null;
    });
  }

  List<Customer> get filteredCustomers {
    return customers.where((customer) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          customer.name?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          customer.phone?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesDateRange = (selectedStartDate == null ||
              customer.registrationDate?.isAfter(selectedStartDate!) == true) &&
          (selectedEndDate == null ||
              customer.registrationDate?.isBefore(
                      selectedEndDate!.add(const Duration(days: 1))) ==
                  true);

      final matchesEnabled =
          selectedEnabled == null || customer.enabled == selectedEnabled;

      return matchesSearch && matchesDateRange && matchesEnabled;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).customers),
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
                    hintText: AppLocalizations.of(context).searchCustomers,
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
                DropdownButtonFormField<bool>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).status,
                    border: const OutlineInputBorder(),
                  ),
                  value: selectedEnabled,
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text(AppLocalizations.of(context).enabled),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text(AppLocalizations.of(context).disabled),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedEnabled = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : customers.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noCustomersFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = filteredCustomers[index];
                          return _CustomerListItem(
                            customer: customer,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.customerRead])
                                ? _navigateToCustomerDetail(customer)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: AuthGuard(
        permissions: [
          AppPermissions.customerAdd,
          AppPermissions.addressBrowse,
        ],
        allPermissions: true,
        fallback: null,
        child: FloatingActionButton(
          onPressed: _navigateToCustomerAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _CustomerListItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const _CustomerListItem({
    required this.customer,
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
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(customer.name ??
                  AppLocalizations.of(context).unnamedCustomer),
            ),
            if (customer.enabled != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: customer.enabled == true
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customer.enabled == true
                      ? AppLocalizations.of(context).enabled
                      : AppLocalizations.of(context).disabled,
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
            if (customer.registrationDate != null)
              Text(customer.registrationDate!
                  .toLocal()
                  .toString()
                  .split(' ')[0]),
            Row(
              children: [
                if (customer.phone != null) ...[
                  Icon(Icons.phone,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(customer.phone!),
                ],
                const Spacer(),
                if (customer.$addressesCount != null) ...[
                  Icon(Icons.location_on,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${customer.$addressesCount}'),
                ],
                if (customer.$salesCount != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.shopping_cart,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${customer.$salesCount}'),
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
