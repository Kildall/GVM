import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/employees/employees/employee_add.dart';
import 'package:gvm_flutter/src/views/employees/employees/employee_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class EmployeesBrowse extends StatefulWidget {
  const EmployeesBrowse({super.key});

  @override
  _EmployeesBrowseState createState() => _EmployeesBrowseState();
}

class _EmployeesBrowseState extends State<EmployeesBrowse>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  List<Employee> employees = [];
  String? searchQuery;
  String? selectedPosition;
  List<String?> positions = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  Future<void> refresh() async {
    await _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final response = await AuthManager.instance.apiService
          .get<GetEmployeesResponse>('/api/employees',
              fromJson: GetEmployeesResponse.fromJson);

      // Extract unique positions for the filter dropdown
      final uniquePositions = response.data?.employees
          .map((e) => e.position)
          .where((position) => position != null)
          .toSet()
          .toList();

      setState(() {
        isLoading = false;
        employees = response.data?.employees ?? [];
        positions = uniquePositions ?? [];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

  void _navigateToEmployeeDetail(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeRead(employee: employee)),
    );
  }

  void _navigateToEmployeeAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmployeeAdd()),
    );
  }

  List<Employee> get filteredEmployees {
    return employees.where((employee) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          employee.name!.toLowerCase().contains(searchQuery!.toLowerCase());
      final matchesPosition =
          selectedPosition == null || employee.position == selectedPosition;
      return matchesSearch && matchesPosition;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).employees),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchEmployees,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String?>(
                  value: selectedPosition,
                  hint: Text(AppLocalizations.of(context).filterByPosition),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(AppLocalizations.of(context).all),
                    ),
                    ...positions.map((position) => DropdownMenuItem(
                          value: position,
                          child: Text(position ?? ''),
                        )),
                  ],
                  onChanged: (value) =>
                      setState(() => selectedPosition = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : employees.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noEmployeesFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = filteredEmployees[index];
                          return _EmployeeListItem(
                            employee: employee,
                            onTap: () => AuthGuard.checkPermissions([
                              AppPermissions.employeeRead,
                            ])
                                ? _navigateToEmployeeDetail(employee)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: AuthGuard(
        permissions: [AppPermissions.employeeAdd],
        child: FloatingActionButton(
          onPressed: _navigateToEmployeeAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeListItem({
    required this.employee,
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
        title:
            Text(employee.name ?? AppLocalizations.of(context).unnamedEmployee),
        subtitle:
            Text(employee.position ?? AppLocalizations.of(context).noPosition),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (employee.sales?.isNotEmpty ?? false) ...[
              Icon(Icons.shopping_cart,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${employee.sales?.length ?? 0}'),
              const SizedBox(width: 16),
            ],
            if (employee.deliveries?.isNotEmpty ?? false) ...[
              Icon(Icons.local_shipping,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${employee.deliveries?.length ?? 0}'),
              const SizedBox(width: 8),
            ],
            Icon(
              employee.enabled ?? true ? Icons.check_circle : Icons.cancel,
              color: (employee.enabled ?? true)
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
