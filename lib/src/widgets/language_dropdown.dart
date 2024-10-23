import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return DropdownButton<Locale>(
          value: localeProvider.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localeProvider.setLocale(newLocale);
            }
          },
          items: AppLocalizations.supportedLocales.map((Locale locale) {
            return DropdownMenuItem(
              value: locale,
              child:
                  Text(localeProvider.getDisplayLanguage(locale.languageCode)),
            );
          }).toList(),
        );
      },
    );
  }
}
