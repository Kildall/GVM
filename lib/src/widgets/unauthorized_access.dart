import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnauthorizedAccess extends StatelessWidget {
  final bool showBackButton;
  final EdgeInsetsGeometry padding;
  final double? iconSize;

  const UnauthorizedAccess({
    super.key,
    this.showBackButton = true,
    this.padding = const EdgeInsets.all(16.0),
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Calculate responsive icon size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultIconSize = screenWidth < 600 ? 48.0 : 64.0;
    final responsiveIconSize = iconSize ?? defaultIconSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're in a constrained space
        final bool isConstrained = constraints.maxHeight < 300;

        return SingleChildScrollView(
          padding: padding,
          child: Container(
            constraints: BoxConstraints(
              minHeight: isConstrained ? constraints.maxHeight : 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: responsiveIconSize,
                  color: colorScheme.error,
                ),
                SizedBox(height: isConstrained ? 8 : 16),
                Text(
                  AppLocalizations.of(context).unauthorized,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isConstrained ? 4 : 8),
                Text(
                  AppLocalizations.of(context).unauthorizedDescription,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (showBackButton) ...[
                  SizedBox(height: isConstrained ? 12 : 24),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(AppLocalizations.of(context).goBack),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
