import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/employees/entities/entitites_browse.dart';

class EmployeesHome extends StatefulWidget {
  const EmployeesHome({super.key});

  @override
  _EmployeesHomeState createState() => _EmployeesHomeState();
}

class _EmployeesHomeState extends State<EmployeesHome> {
  bool isLoading = true;
  int employeeCount = 0;
  int entityCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final employeesResponse = await AuthManager.instance.apiService
        .get<GetEmployeesResponse>('/api/employees',
            fromJson: GetEmployeesResponse.fromJson);

    final entitiesResponse = await AuthManager.instance.apiService
        .get<GetEntitiesResponse>('/api/admin/entities',
            fromJson: GetEntitiesResponse.fromJson);

    setState(() {
      isLoading = false;
      employeeCount = employeesResponse.data?.employees.length ?? 0;
      entityCount = entitiesResponse.data?.entities.length ?? 0;
    });
  }

  void _navigateToEmployees() {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const EmployeesBrowse(),
    // ));
  }

  void _navigateToEntities() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const EntitiesBrowse(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.people,
                            title: 'Employees',
                            value: employeeCount.toString(),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.security,
                            title: 'Entities',
                            value: entityCount.toString(),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Modules',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _NavigationCard(
                          title: 'Employee Management',
                          icon: Icons.people_outline,
                          description: 'Manage your employees',
                          onTap: _navigateToEmployees,
                        ),
                        const SizedBox(width: 16),
                        _NavigationCard(
                          title: 'Security Management',
                          icon: Icons.security_outlined,
                          description: 'Manage roles and permissions',
                          onTap: _navigateToEntities,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatisticCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
