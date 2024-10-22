import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;
  static const String _localeKey = 'selectedLocale';

  LocaleProvider() : _locale = const Locale('es');

  Locale get locale => _locale;

  // Initialize locale from stored preferences
  Future<void> initializeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLocale = prefs.getString(_localeKey);
    if (storedLocale != null) {
      _locale = Locale(storedLocale);
      notifyListeners();
    }
  }

  // Change the locale and save to preferences
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;

    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    notifyListeners();
  }

  // Get the display name for the current locale
  String getDisplayLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Português';
      default:
        return languageCode;
    }
  }
}
