import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gvm_flutter/src/views/home/home_view.dart';
import 'package:gvm_flutter/src/views/landing.dart';
import 'package:gvm_flutter/src/views/login/login_view.dart';
import 'package:gvm_flutter/src/views/signup/signup_view.dart';
import 'package:gvm_flutter/src/widgets/auth/auth_wrapper.dart';


import 'settings/settings_controller.dart';
import 'views/settings/settings_view.dart';

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
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case LandingView.routeName:
                    return LandingView();
                  case LoginView.routeName:
                    return LoginView();
                  case SignupView.routeName:
                    return SignupView();
                  case SettingsView.routeName:
                    return AuthWrapper(
                      child: SettingsView(controller: settingsController),
                    );
                  case HomeView.routeName:
                    return AuthWrapper(child: HomeView());
                  default:
                    return AuthWrapper(
                      child: Placeholder(), // Replace with your default authenticated page
                    );
                }
              },
            );
          }
        );
      },
    );
  }
}