import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gvm_flutter/src/services/api/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:gvm_flutter/src/views/landing.dart';
import 'package:gvm_flutter/src/views/login/login_view.dart';
import 'package:gvm_flutter/src/views/signup/signup_view.dart';
import 'package:gvm_flutter/src/widgets/auth/auth_wrapper.dart';
import 'package:gvm_flutter/src/widgets/layout/authenticated_layout.dart';

import 'settings/settings_controller.dart';

class GVMApp extends StatelessWidget {
  final SettingsController settingsController;

  const GVMApp({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                final authService = Provider.of<AuthService>(context);
                
                if (settings.name == '/') {
                  return authService.isAuthenticated
                      ? AuthWrapper(
                          child: AuthenticatedLayout(
                            settingsController: settingsController,
                          ),
                        )
                      : LandingView();
                }
                
                // Handle other routes
                switch (settings.name) {
                  case LoginView.routeName:
                    return LoginView();
                  case SignupView.routeName:
                    return SignupView();
                  default:
                    return authService.isAuthenticated
                        ? AuthWrapper(
                            child: AuthenticatedLayout(
                              settingsController: settingsController,
                            ),
                          )
                        : LandingView();
                }
              },
            );
          },
        );
      },
    );
  }
}