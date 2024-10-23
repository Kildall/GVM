import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:gvm_flutter/src/widgets/language_dropdown.dart';

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
        title: Text(AppLocalizations.of(context).settingsHomeTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                Text(AppLocalizations.of(context).userInformation,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Text('${AppLocalizations.of(context).name}: ${user.name}'),
                Text('${AppLocalizations.of(context).email}: ${user.email}'),
                SizedBox(height: 16),
              ],
              Text(AppLocalizations.of(context).themeSettings,
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              DropdownButton<ThemeMode>(
                value: widget.controller.themeMode,
                onChanged: widget.controller.updateThemeMode,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(AppLocalizations.of(context).systemTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(AppLocalizations.of(context).lightTheme),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(AppLocalizations.of(context).darkTheme),
                  )
                ],
              ),
              SizedBox(height: 24),
              Text(AppLocalizations.of(context).languageSettings,
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16),
              const LanguageDropdown(),
              Divider(),
              if (user != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context).debugMode,
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
                  Text(AppLocalizations.of(context).permissions,
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
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => AuthManager.instance.logout(),
                  child: Text(AppLocalizations.of(context).logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
