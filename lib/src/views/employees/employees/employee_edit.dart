import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class EmployeeEdit extends StatefulWidget {
  final Employee employee;

  const EmployeeEdit({
    super.key,
    required this.employee,
  });

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPasswordReset = false;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;

  // Track enabled states
  late bool employeeEnabled;
  late bool userEnabled;
  late bool userVerified;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _positionController = TextEditingController(text: widget.employee.position);
    _emailController = TextEditingController(text: widget.employee.user?.email);

    employeeEnabled = widget.employee.enabled ?? true;
    userEnabled = widget.employee.user?.enabled ?? true;
    userVerified = widget.employee.user?.verified ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() => isLoading = true);
    try {
      final userId = widget.employee.user?.id;
      if (userId == null) throw Exception('No user ID found');

      final passwordResponse = await AuthManager.instance.apiService.post(
        '/api/admin/users/$userId/reset-password',
        body: {},
        fromJson: (json) => json['password'] as String,
      );

      final password = passwordResponse.data!;

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).passwordReset),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).newTemporaryPassword),
                  const SizedBox(height: 8),
                  SelectableText(
                    password,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).pleaseStorePasswordSecurely,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).update),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      debugPrint('Error resetting password: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorResettingPassword),
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

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      // Update employee
      final updatedEmployee = widget.employee.copyWith(
        name: _nameController.text,
        position: _positionController.text,
        enabled: employeeEnabled,
      );

      await AuthManager.instance.apiService.put(
        '/api/admin/employees/${widget.employee.id}',
        body: updatedEmployee.toJson(),
        fromJson: (json) => {},
      );

      // Update associated user if exists
      if (widget.employee.user != null) {
        final updatedUser = widget.employee.user!.copyWith(
          email: _emailController.text,
          enabled: userEnabled,
          verified: userVerified,
        );

        await AuthManager.instance.apiService.put(
          '/api/admin/users/${widget.employee.user!.id}',
          body: updatedUser.toJson(),
          fromJson: (json) => {},
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context).employeeUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, updatedEmployee);
      }
    } catch (e) {
      debugPrint('Error updating employee: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorUpdatingEmployee),
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
        title: Text(AppLocalizations.of(context).editEmployee),
        actions: [
          if (!isLoading)
            TextButton.icon(
              onPressed: _saveEmployee,
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
                    _buildEmployeeSection(),
                    const SizedBox(height: 24),
                    _buildUserSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmployeeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).employeeDetails,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).name,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).position,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).employeeEnabled),
              value: employeeEnabled,
              onChanged: (bool value) {
                setState(() => employeeEnabled = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    if (widget.employee.user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              AppLocalizations.of(context).noUserAccountAssociated,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).userAccount,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                if (!value.contains('@')) {
                  return AppLocalizations.of(context).invalidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(AppLocalizations.of(context).resetPassword),
              subtitle:
                  Text(AppLocalizations.of(context).resetPasswordDescription),
              trailing: ElevatedButton.icon(
                onPressed: isLoading ? null : _resetPassword,
                icon: const Icon(Icons.lock_reset),
                label: Text(AppLocalizations.of(context).reset),
              ),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).userEnabled),
              value: userEnabled,
              onChanged: (bool value) {
                setState(() => userEnabled = value);
              },
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).userVerified),
              value: userVerified,
              onChanged: (bool value) {
                setState(() => userVerified = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
