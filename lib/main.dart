import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gvm_flutter/src/services/api/api_service.dart';
import 'package:gvm_flutter/src/services/api/auth_service.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/services/settings_service.dart';

void main() async {

  await dotenv.load(fileName: '.env');

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(dotenv.env['API_URL'] ?? '')),
        ProxyProvider<AuthService, APIService>(
          update: (_, authService, __) => APIService(dotenv.env['API_URL'] ?? '', authService.getToken),
        ),
      ],
      child: GVMApp(settingsController: settingsController),
    ),
  );
}
