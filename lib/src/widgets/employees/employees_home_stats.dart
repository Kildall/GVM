import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card_skeleton.dart';

class EmployeesHomeStats extends StatefulWidget {
  const EmployeesHomeStats({super.key});

  @override
  State<EmployeesHomeStats> createState() => _HomeStatsState();
}

class _HomeStatsState extends State<EmployeesHomeStats> {
  bool isLoading = true;
  int employeeCount = 0;
  int entityCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadEmployees();
    final isAdmin = AuthGuard.checkPermissions([AppPermissions.admin]);
    if (isAdmin) {
      await _loadEntities();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadEmployees() async {
    final employeesResponse = await AuthManager.instance.apiService
        .get<GetEmployeesResponse>('/api/employees',
            fromJson: GetEmployeesResponse.fromJson);

    setState(() {
      employeeCount = employeesResponse.data?.employees.length ?? 0;
    });
  }

  Future<void> _loadEntities() async {
    final entitiesResponse = await AuthManager.instance.apiService
        .get<GetEntitiesResponse>('/api/admin/entities',
            fromJson: GetEntitiesResponse.fromJson);

    setState(() {
      entityCount = entitiesResponse.data?.entities.length ?? 0;
    });
  }

  Widget _buildStatCards() {
    if (isLoading) {
      return Row(
        children: [
          Expanded(child: const StatisticCardSkeleton()),
          const SizedBox(width: 16),
          Expanded(child: const StatisticCardSkeleton()),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: StatisticCard(
            icon: Icons.person,
            title: AppLocalizations.of(context).employees,
            value: employeeCount.toString(),
            color: Colors.blue,
          ),
        ),
        AuthGuard(
            permissions: [AppPermissions.admin],
            child: const SizedBox(width: 16)),
        AuthGuard(
          permissions: [AppPermissions.admin],
          child: Expanded(
            child: StatisticCard(
              icon: Icons.security,
              title: AppLocalizations.of(context).entities,
              value: entityCount.toString(),
              color: Colors.green,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).statistics,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildStatCards(),
      ],
    );
  }
}
