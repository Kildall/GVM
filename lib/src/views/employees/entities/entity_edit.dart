import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/entity_requests.dart';
import 'package:gvm_flutter/src/models/response/entity_responses.dart';
import 'package:gvm_flutter/src/models/response/user_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

enum AddType {
  Users,
  Permissions,
  Roles,
}

class EntityEdit extends StatefulWidget {
  final Entity entity;

  const EntityEdit({
    super.key,
    required this.entity,
  });

  @override
  _EntityEditState createState() => _EntityEditState();
}

class _EntityEditState extends State<EntityEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late Entity entity;

  // Available items for selection
  List<Entity> availablePermissions = [];
  List<Entity> availableRoles = [];
  List<User> availableUsers = [];

  // Selected items
  TextEditingController? _nameController;
  List<Entity> selectedPermissions = [];
  List<Entity> selectedRoles = [];
  List<User> selectedUsers = [];

  // Track if we need to transform to role
  bool willTransformToRole = false;

  @override
  void initState() {
    super.initState();
    entity = widget.entity;
    _nameController = TextEditingController(text: entity.name);
    selectedPermissions = entity.permissions?.toList() ?? [];
    selectedRoles = entity.roles?.toList() ?? [];
    selectedUsers = entity.users?.toList() ?? [];
    _loadData();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

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

      final usersResponse = await AuthManager.instance.apiService
          .get<GetUsersResponse>('/api/admin/users',
              fromJson: GetUsersResponse.fromJson);
      availableUsers = usersResponse.data?.users ?? [];

      // Filter out already selected items
      availablePermissions = availablePermissions
          .where((permission) => !selectedPermissions
              .any((selected) => selected.id == permission.id))
          .toList();

      availableRoles = availableRoles
          .where((role) =>
              !selectedRoles.any((selected) => selected.id == role.id))
          .toList();

      availableUsers =
          availableUsers.where((u) => !selectedUsers.contains(u)).toList();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveEntity() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      // Check if we need to transform to role
      final newType = willTransformToRole ? EntityType.Role : entity.type;

      final request = UpdateEntityRequest(
        entityId: entity.id!,
        name: _nameController!.text,
        type: newType!,
        permissions: selectedPermissions.map((p) => p.id!).toList(),
        roles: selectedRoles.map((r) => r.id!).toList(),
        users: selectedUsers.map((u) => u.id!).toList(),
      );

      await AuthManager.instance.apiService.put(
        '/api/admin/entities',
        body: request.toJson(),
        fromJson: (json) => {},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(willTransformToRole
                ? AppLocalizations.of(context).permissionTransformedToRole
                : AppLocalizations.of(context).entitySaved),
            backgroundColor: Colors.green,
          ),
        );

        final updatedEntity = entity.copyWith(
          name: _nameController!.text,
          type: newType,
          permissions: selectedPermissions,
          roles: selectedRoles,
          users: selectedUsers,
        );
        Navigator.pop(context, updatedEntity);
      }
    } catch (e) {
      debugPrint('Error saving entity: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorSavingEntity),
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

  void _showAddItemDialog({required AddType addType}) {
    showDialog(
      context: context,
      builder: (context) => _AddItemsDialog(
        title: switch (addType) {
          AddType.Users => AppLocalizations.of(context).addUsers,
          AddType.Permissions => AppLocalizations.of(context).addPermissions,
          AddType.Roles => AppLocalizations.of(context).addRoles,
        },
        selectedItems: switch (addType) {
          AddType.Users => selectedUsers,
          AddType.Permissions => selectedPermissions,
          AddType.Roles => selectedRoles,
        },
        items: switch (addType) {
          AddType.Users => availableUsers,
          AddType.Permissions => availablePermissions,
          AddType.Roles => availableRoles,
        },
        itemBuilder: (item, {onDelete}) => switch (addType) {
          AddType.Users => _buildUserListItem(item as User, onDelete: onDelete),
          AddType.Permissions =>
            _buildPermissionListItem(item as Entity, onDelete: onDelete),
          AddType.Roles =>
            _buildRoleListItem(item as Entity, context, onDelete: onDelete),
        },
        onConfirm: (selectedItems) {
          setState(() {
            switch (addType) {
              case AddType.Users:
                selectedUsers = [
                  ...selectedUsers,
                  ...selectedItems.map((item) => item as User)
                ];
                availableUsers = availableUsers
                    .where((u) => !selectedUsers.contains(u))
                    .toList();
              case AddType.Permissions:
                selectedPermissions = [
                  ...selectedPermissions,
                  ...selectedItems.map((item) => item as Entity)
                ];
                availablePermissions = availablePermissions
                    .where((p) => !selectedPermissions.contains(p))
                    .toList();

                // Check if we need to transform to role
                if (entity.type == EntityType.Permission &&
                    selectedRoles.isNotEmpty) {
                  willTransformToRole = true;
                  _showTransformationWarning();
                }
                break;
              case AddType.Roles:
                selectedRoles = [
                  ...selectedRoles,
                  ...selectedItems.map((item) => item as Entity)
                ];
                availableRoles = availableRoles
                    .where((r) => !selectedRoles.contains(r))
                    .toList();
                break;
            }
          });
        },
      ),
    );
  }

  void _showTransformationWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).permissionTransformed),
        content: Text(AppLocalizations.of(context).thisCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).iUnderstand),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(willTransformToRole
            ? AppLocalizations.of(context).editRole
            : AppLocalizations.of(context).editEntity),
        actions: [
          if (!isLoading)
            TextButton.icon(
              onPressed: _saveEntity,
              icon: const Icon(Icons.save),
              label: Text(AppLocalizations.of(context).save),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameSection(),
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

  Widget _buildNameSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  willTransformToRole
                      ? Icons.badge
                      : entity.type == EntityType.Role
                          ? Icons.badge
                          : Icons.key,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).users,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () => _showAddItemDialog(addType: AddType.Users),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (selectedUsers.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noUsersAssigned,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedUsers.length,
                itemBuilder: (context, index) {
                  return _buildUserListItem(
                    selectedUsers[index],
                    onDelete: () {
                      setState(() {
                        final user = selectedUsers[index];
                        selectedUsers.removeAt(index);
                        availableUsers.add(user);
                      });
                    },
                  );
                },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).permissions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () =>
                      _showAddItemDialog(addType: AddType.Permissions),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (selectedPermissions.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noPermissionsAssigned,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedPermissions.length,
                itemBuilder: (context, index) {
                  return _buildPermissionListItem(
                    selectedPermissions[index],
                    onDelete: () {
                      setState(() {
                        final permission = selectedPermissions[index];
                        selectedPermissions.removeAt(index);
                        availablePermissions.add(permission);

                        // Check if we should revert transformation
                        if (willTransformToRole && selectedRoles.isEmpty) {
                          willTransformToRole = false;
                        }
                      });
                    },
                  );
                },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).roles,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: () => _showAddItemDialog(addType: AddType.Roles),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (selectedRoles.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noRolesAssigned,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedRoles.length,
                itemBuilder: (context, index) {
                  return _buildRoleListItem(
                    selectedRoles[index],
                    context,
                    onDelete: () {
                      setState(() {
                        final role = selectedRoles[index];
                        selectedRoles.removeAt(index);
                        availableRoles.add(role);

                        // Check if we should revert transformation
                        if (willTransformToRole && selectedRoles.isEmpty) {
                          willTransformToRole = false;
                        }
                      });
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserListItem(User user, {VoidCallback? onDelete}) {
    return ListTile(
      // Make this have less padding
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        child: Text(user.employee?.name?[0].toUpperCase() ?? '?'),
      ),
      title:
          Text(user.employee?.name ?? AppLocalizations.of(context).unnamedUser),
      subtitle:
          Text(user.email ?? '', style: Theme.of(context).textTheme.bodySmall),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              onPressed: onDelete,
            )
          : null,
    );
  }

  Widget _buildPermissionListItem(Entity permission, {VoidCallback? onDelete}) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.key),
      ),
      title: Text(
          permission.name ?? AppLocalizations.of(context).unnamedPermission),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: Colors.red,
              onPressed: onDelete,
            )
          : null,
    );
  }
}

Widget _buildRoleListItem(Entity role, BuildContext context,
    {VoidCallback? onDelete}) {
  return ListTile(
    leading: const CircleAvatar(child: Icon(Icons.badge)),
    title: Text(role.name ?? AppLocalizations.of(context).unnamedRole),
    trailing: onDelete != null
        ? IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: Colors.red,
            onPressed: onDelete,
          )
        : null,
  );
}

class _AddItemsDialog extends StatefulWidget {
  final String title;
  final List<dynamic> items;
  final List<dynamic> selectedItems;
  final Widget Function(dynamic item, {VoidCallback? onDelete}) itemBuilder;
  final Function(List<dynamic>) onConfirm;

  const _AddItemsDialog({
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.itemBuilder,
    required this.onConfirm,
  });

  @override
  _AddItemsDialogState createState() => _AddItemsDialogState();
}

class _AddItemsDialogState extends State<_AddItemsDialog> {
  List<dynamic> selectedItems = [];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final name = item is User ? item.employee?.name : item.name;
      return name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
    }).toList();

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).search,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 16),
            if (filteredItems.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noItemsFound,
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return CheckboxListTile(
                      value: selectedItems.contains(item),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedItems.add(item);
                          } else {
                            selectedItems.remove(item);
                          }
                        });
                      },
                      title: widget.itemBuilder(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm(selectedItems);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }
}
