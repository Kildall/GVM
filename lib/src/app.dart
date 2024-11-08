import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gvm_flutter/src/providers/locale_provider.dart';
import 'package:gvm_flutter/src/services/auth/auth_listener.dart';
import 'package:gvm_flutter/src/views/landing/landing.dart';
import 'package:gvm_flutter/src/widgets/layout/base_layout.dart';
import 'package:provider/provider.dart';

import 'settings/settings_controller.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class GVMApp extends StatefulWidget {
  final SettingsController settingsController;

  const GVMApp({
    super.key,
    required this.settingsController,
  });

  @override
  State<GVMApp> createState() => _GVMAppState();
}

class _GVMAppState extends State<GVMApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) => ListenableBuilder(
        listenable: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            scaffoldMessengerKey: snackbarKey,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context).appTitle,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: widget.settingsController.themeMode,
            home: AuthListener(
              authenticated: BaseLayout(
                settingsController: widget.settingsController,
              ),
              unAuthenticated: const LandingView(),
            ),
          );
        },
      ),
    );
  }
}
