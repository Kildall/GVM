import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gvm_flutter/src/services/api/auth_service.dart';
import 'package:gvm_flutter/src/widgets/layout/splash_screen_loader.dart';
import 'package:provider/provider.dart';
import 'package:gvm_flutter/src/views/landing.dart';
import 'package:gvm_flutter/src/views/login/login_view.dart';
import 'package:gvm_flutter/src/views/signup/signup_view.dart';
import 'package:gvm_flutter/src/widgets/auth/auth_wrapper.dart';
import 'package:gvm_flutter/src/widgets/layout/authenticated_layout.dart';

import 'settings/settings_controller.dart';

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
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      openAppLink(appLink);
    }

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    if (uri.host == 'kildall.ar') {
      final path = uri.path.isEmpty ? '/' : uri.path;
      debugPrint('Navigating to: $path');
      _navigatorKey.currentState?.pushNamed(path);
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
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
          themeMode: widget.settingsController.themeMode,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                final authService = Provider.of<AuthService>(context);

                if (authService.isLoading) {
                  return SplashScreen();
                }
                
                if (settings.name == '/') {
                  return authService.isAuthenticated
                      ? AuthWrapper(
                          child: AuthenticatedLayout(
                            settingsController: widget.settingsController,
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
                              settingsController: widget.settingsController,
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