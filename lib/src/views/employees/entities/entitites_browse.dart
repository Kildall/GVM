import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/employees/entities/entity_add.dart';
import 'package:gvm_flutter/src/views/employees/entities/entity_read.dart';

class EntitiesBrowse extends StatefulWidget {
  const EntitiesBrowse({super.key});

  @override
  _EntitiesBrowseState createState() => _EntitiesBrowseState();
}

class _EntitiesBrowseState extends State<EntitiesBrowse> {
  bool isLoading = true;
  List<Entity> entities = [];
  String? searchQuery;
  EntityType? selectedType;

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    final entitiesResponse = await AuthManager.instance.apiService
        .get<GetEntitiesResponse>('/api/admin/entities',
            fromJson: GetEntitiesResponse.fromJson);
    setState(() {
      isLoading = false;
      entities = entitiesResponse.data?.entities ?? [];
    });
  }

  void _navigateToEntityDetail(Entity entity) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EntityRead(entity: entity),
    ));
  }

  void _navigateToEntityAdd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const EntityAdd(),
    ));
  }

  List<Entity> get filteredEntities {
    return entities.where((entity) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          entity.name!.toLowerCase().contains(searchQuery!.toLowerCase());
      final matchesType = selectedType == null || entity.type == selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entities'),
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
                      hintText: 'Search entities...',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<EntityType?>(
                  value: selectedType,
                  hint: Text('Filter by type'),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All'),
                    ),
                    ...EntityType.values.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        )),
                  ],
                  onChanged: (value) => setState(() => selectedType = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : entities.isEmpty
                    ? Center(
                        child: Text(
                          'No entities found',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredEntities.length,
                        itemBuilder: (context, index) {
                          final entity = filteredEntities[index];
                          return _EntityListItem(
                            entity: entity,
                            onTap: () => _navigateToEntityDetail(entity),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEntityAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EntityListItem extends StatelessWidget {
  final Entity entity;
  final VoidCallback onTap;

  const _EntityListItem({
    required this.entity,
    required this.onTap,
  });

  IconData _getTypeIcon(EntityType? type) {
    switch (type) {
      case EntityType.Role:
        return Icons.badge;
      case EntityType.Permission:
        return Icons.key;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            _getTypeIcon(entity.type),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(entity.name ?? 'Unnamed Entity'),
        subtitle: Text(entity.type?.name ?? 'Unknown Type'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entity.$usersCount != null) ...[
              Icon(Icons.people,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${entity.$usersCount}'),
              const SizedBox(width: 16),
            ],
            if (entity.$permissionsCount != null &&
                entity.type == EntityType.Role) ...[
              Icon(Icons.key,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${entity.$permissionsCount}'),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
