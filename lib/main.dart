import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gvm_flutter/src/providers/locale_provider.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/services/settings_service.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.initializeAuth(dotenv.get('API_URL', fallback: ''));

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(ChangeNotifierProvider(
    create: (context) => LocaleProvider(),
    child: GVMApp(settingsController: settingsController),
  ));
}
