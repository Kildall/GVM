import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _debugMode = false;

  @override
  Widget build(BuildContext context) {
    final user = AuthManager.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsPageTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                Text('User Information',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Debug Mode',
                        style: Theme.of(context).textTheme.titleSmall),
                    Switch(
                      value: _debugMode,
                      onChanged: (value) {
                        setState(() {
                          _debugMode = value;
                        });
                      },
                      splashRadius: 0.5,
                    ),
                  ],
                ),
                if (_debugMode) ...[
                  Text('Permissions:',
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8),
                  Container(
                    height: 150, // Restricted height
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: user.permissions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Text('• ${user.permissions[index]}'),
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 24),
              ],
              ElevatedButton(
                onPressed: () => AuthManager.instance.logout(),
                child: Text('Logout'),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text('Theme Settings',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              DropdownButton<ThemeMode>(
                value: widget.controller.themeMode,
                onChanged: widget.controller.updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
