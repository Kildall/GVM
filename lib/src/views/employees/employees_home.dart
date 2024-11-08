import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/employees/employees/employees_browse.dart';
import 'package:gvm_flutter/src/views/employees/entities/entitites_browse.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/employees/employees_home_stats.dart';
import 'package:gvm_flutter/src/widgets/unauthorized_access.dart';

class EmployeesHome extends StatefulWidget {
  const EmployeesHome({super.key});

  @override
  _EmployeesHomeState createState() => _EmployeesHomeState();
}

class _EmployeesHomeState extends State<EmployeesHome> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToEmployees() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const EmployeesBrowse(),
    ));
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
        title: Text(AppLocalizations.of(context).employeesHomeTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AuthGuard(
            permissions: [
              AppPermissions.employeeBrowse,
              AppPermissions.admin,
            ],
            allPermissions: false,
            fallback: const UnauthorizedAccess(
              showBackButton: false,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EmployeesHomeStats(),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).modules,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    AuthGuard(
                      permissions: [AppPermissions.employeeBrowse],
                      child: _NavigationCard(
                        title: AppLocalizations.of(context).employeeManagement,
                        icon: Icons.people_outline,
                        description: AppLocalizations.of(context)
                            .employeeManagementDescription,
                        onTap: _navigateToEmployees,
                      ),
                    ),
                    const SizedBox(width: 16),
                    AuthGuard(
                      permissions: [AppPermissions.admin],
                      child: _NavigationCard(
                        title: AppLocalizations.of(context).securityManagement,
                        icon: Icons.security_outlined,
                        description: AppLocalizations.of(context)
                            .securityManagementDescription,
                        onTap: _navigateToEntities,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
