import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class EmployeeRead extends StatefulWidget {
  final Employee employee;

  const EmployeeRead({
    super.key,
    required this.employee,
  });

  @override
  _EmployeeReadState createState() => _EmployeeReadState();
}

class _EmployeeReadState extends State<EmployeeRead> {
  bool isLoading = true;
  late Employee employee;

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
    _loadEmployeeDetails();
  }

  Future<void> _loadEmployeeDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Employee>(
          '/api/employees/${employee.id}',
          fromJson: (json) => Employee.fromJson(json['data']));

      setState(() {
        employee = response.data!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

  void _navigateToEmployeeEdit() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EmployeeEdit(employee: employee)),
    // );
  }

  void _navigateToDelivery(Delivery delivery) {
    Navigator.pushNamed(context, '/deliveries/detail', arguments: delivery);
  }

  void _navigateToSale(Sale sale) {
    Navigator.pushNamed(context, '/sales/detail', arguments: sale);
  }

  void _navigateToPurchase(Purchase purchase) {
    Navigator.pushNamed(context, '/purchases/detail', arguments: purchase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .employeeDetailsTitle(employee.name ?? '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEmployeeEdit,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildSalesSection(),
                    const SizedBox(height: 24),
                    _buildDeliveriesSection(),
                    const SizedBox(height: 24),
                    _buildPurchasesSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name ??
                            AppLocalizations.of(context).unnamedEmployee,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        employee.position ??
                            AppLocalizations.of(context).noPosition,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  employee.enabled ?? true ? Icons.check_circle : Icons.cancel,
                  color: (employee.enabled ?? true)
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatisticItem(
                  icon: Icons.shopping_cart,
                  label: AppLocalizations.of(context).sales,
                  value: (employee.sales?.length ?? 0).toString(),
                ),
                _StatisticItem(
                  icon: Icons.local_shipping,
                  label: AppLocalizations.of(context).deliveries,
                  value: (employee.deliveries?.length ?? 0).toString(),
                ),
                _StatisticItem(
                  icon: Icons.shopping_bag,
                  label: AppLocalizations.of(context).purchases,
                  value: (employee.purchases?.length ?? 0).toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).sales,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (employee.sales?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noSalesRecorded,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: employee.sales?.length ?? 0,
              itemBuilder: (context, index) {
                final sale = employee.sales![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_cart),
                    ),
                    title: Text('Sale #${sale.id}'),
                    subtitle: Text(sale.startDate?.toString() ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToSale(sale),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDeliveriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).deliveries,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (employee.deliveries?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noDeliveriesRecorded,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: employee.deliveries?.length ?? 0,
              itemBuilder: (context, index) {
                final delivery = employee.deliveries![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.local_shipping),
                    ),
                    title: Text('Delivery #${delivery.id}'),
                    subtitle: Text(delivery.startDate?.toString() ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToDelivery(delivery),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPurchasesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).purchases,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (employee.purchases?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noPurchasesRecorded,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: employee.purchases?.length ?? 0,
              itemBuilder: (context, index) {
                final purchase = employee.purchases![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_bag),
                    ),
                    title: Text('Purchase #${purchase.id}'),
                    subtitle: Text(purchase.date?.toString() ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToPurchase(purchase),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
