import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class EntityAdd extends StatefulWidget {
  const EntityAdd({super.key});

  @override
  _EntityAddState createState() => _EntityAddState();
}

class _EntityAddState extends State<EntityAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  String? name;
  EntityType selectedType = EntityType.Role;
  List<Entity> selectedPermissions = [];
  List<Entity> selectedRoles = [];

  // For permission selection when creating a role
  List<Entity> availablePermissions = [];
  List<Entity> availableRoles = [];

  @override
  void initState() {
    super.initState();
    if (selectedType == EntityType.Role) {
      _loadPermissions();
    }
  }

  Future<void> _loadPermissions() async {
    setState(() => isLoading = true);
    try {
      final entitiesResponse = await AuthManager.instance.apiService
          .get<GetEntitiesResponse>('/api/admin/entities',
              fromJson: GetEntitiesResponse.fromJson);
      availablePermissions = entitiesResponse.data?.entities
              .where((entity) => entity.type == EntityType.Permission)
              .toList() ??
          [];
      availableRoles = entitiesResponse.data?.entities
              .where((entity) => entity.type == EntityType.Role)
              .toList() ??
          [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveEntity() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final newEntity = Entity(
        name: name,
        type: selectedType,
        permissions:
            selectedType == EntityType.Role ? selectedPermissions : null,
        roles: selectedRoles,
      );

      final response = await AuthManager.instance.apiService.post(
          '/api/admin/entities',
          body: newEntity.toJson(),
          fromJson: GetEntityResponse.fromJson);

      if (mounted) {
        if (response.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Entity created successfully'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating entity'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Entity'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 24),
              if (selectedType == EntityType.Role) ...[
                _buildPermissionsSection(),
                const SizedBox(height: 24),
              ],
              _buildRolesSection(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _saveEntity,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Save',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entity Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<EntityType>(
              segments: [
                ButtonSegment<EntityType>(
                  value: EntityType.Role,
                  label: Text('Role'),
                  icon: const Icon(Icons.badge),
                ),
                ButtonSegment<EntityType>(
                  value: EntityType.Permission,
                  label: Text('Permission'),
                  icon: const Icon(Icons.key),
                ),
              ],
              selected: {selectedType},
              onSelectionChanged: (Set<EntityType> newSelection) {
                setState(() {
                  selectedType = newSelection.first;
                  if (selectedType == EntityType.Role &&
                      availablePermissions.isEmpty) {
                    _loadPermissions();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: selectedType == EntityType.Role
                    ? 'Enter role name'
                    : 'Enter permission name',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  selectedType == EntityType.Role ? Icons.badge : Icons.key,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              onSaved: (value) => name = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign permissions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (availablePermissions.isEmpty)
              Center(
                child: Text(
                  'No permissions available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: availablePermissions.length,
                  itemBuilder: (context, index) {
                    final permission = availablePermissions[index];
                    return CheckboxListTile(
                      title: Text(permission.name ?? 'Unnamed Permission'),
                      value: selectedPermissions.contains(permission),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedPermissions.add(permission);
                          } else {
                            selectedPermissions.remove(permission);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign to roles',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (availableRoles.isEmpty)
              Center(
                child: Text(
                  'No roles available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: availableRoles.length,
                  itemBuilder: (context, index) {
                    final role = availableRoles[index];
                    return CheckboxListTile(
                      title: Text(role.name ?? 'Unnamed Role'),
                      value: selectedRoles.contains(role),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedRoles.add(role);
                          } else {
                            selectedRoles.remove(role);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
