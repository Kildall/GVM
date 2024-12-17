import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/employees/entities/entity_edit.dart';
import 'package:gvm_flutter/src/views/employees/entities/utils.dart';

class EntityRead extends StatefulWidget {
  final Entity entity;

  const EntityRead({
    super.key,
    required this.entity,
  });

  @override
  _EntityReadState createState() => _EntityReadState();
}

class _EntityReadState extends State<EntityRead>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  late Entity entity;

  @override
  void initState() {
    super.initState();
    entity = widget.entity;
    _loadEntityDetails();
  }

  @override
  Future<void> refresh() async {
    await _loadEntityDetails();
  }

  Future<void> _loadEntityDetails() async {
    final entityResponse = await AuthManager.instance.apiService
        .get<GetEntityResponse>('/api/admin/entities/${entity.id}',
            fromJson: GetEntityResponse.fromJson);

    if (entityResponse.data != null) {
      setState(() {
        entity = entityResponse.data!.entity;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _navigateToUser(User user) {
    Navigator.pushNamed(context, '/users/detail', arguments: user);
  }

  void _navigateToEntity(Entity entity) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntityRead(entity: entity)),
    );
  }

  void _navigateToEntityEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntityEdit(entity: entity)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).entityDetailsTitle(entity.name ?? '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEntityEdit,
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
                    _buildUsersSection(),
                    const SizedBox(height: 24),
                    _buildPermissionsSection(),
                    const SizedBox(height: 24),
                    _buildRolesSection(),
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
                    entity.type == EntityType.Role ? Icons.badge : Icons.key,
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
                        entity.name ??
                            AppLocalizations.of(context).unnamedEntity,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        mapEntityTypeToName(entity.type, context),
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatisticItem(
                  icon: Icons.people,
                  label: AppLocalizations.of(context).users,
                  value: entity.$usersCount?.toString() ?? '0',
                ),
                if (entity.type == EntityType.Role)
                  _StatisticItem(
                    icon: Icons.key,
                    label: AppLocalizations.of(context).permissions,
                    value: entity.$permissionsCount?.toString() ?? '0',
                  ),
                if (entity.type == EntityType.Permission)
                  _StatisticItem(
                    icon: Icons.badge,
                    label: AppLocalizations.of(context).roles,
                    value: entity.$rolesCount?.toString() ?? '0',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).users,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: _navigateToEntityEdit,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).addUser),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entity.users?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noUsersAssigned,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250, // Restricted height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: entity.users?.length ?? 0,
              itemBuilder: (context, index) {
                final user = entity.users![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.employee?.name?[0].toUpperCase() ?? '?'),
                    ),
                    title: Text(user.employee?.name ?? 'Unnamed User'),
                    subtitle: Text(user.email ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToUser(user),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRolesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).roles,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: _navigateToEntityEdit,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).addRole),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entity.roles?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noRolesAssigned,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250, // Restricted height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: entity.roles?.length ?? 0,
              itemBuilder: (context, index) {
                final role = entity.roles![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.badge),
                    ),
                    title: Text(role.name ??
                        AppLocalizations.of(context).unnamedEntity),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToEntity(role),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).permissions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: _navigateToEntityEdit,
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context).addPermission),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entity.permissions?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context).noPermissionsAssigned),
            ),
          )
        else
          Container(
            height: 250, // Restricted height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: entity.permissions?.length ?? 0,
              itemBuilder: (context, index) {
                final permission = entity.permissions![index];
                return Card(
                  child: ListTile(
                    title: Text(permission.name ??
                        AppLocalizations.of(context).unnamedEntity),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _navigateToEntity(permission),
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
