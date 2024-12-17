import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteButton extends StatelessWidget {
  final Future<void> Function() onDelete;
  final String itemName;
  final String? customTitle;
  final String? customMessage;
  final IconData? icon;
  final Widget? child;

  const DeleteButton({
    super.key,
    required this.onDelete,
    required this.itemName,
    this.customTitle,
    this.customMessage,
    this.icon,
    this.child,
  });

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(customTitle ??
              AppLocalizations.of(context).deleteConfirmationTitle),
          content: Text(customMessage ??
              AppLocalizations.of(context).deleteConfirmationMessage(itemName)),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context).delete),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await onDelete();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context).anErrorOccurred)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return InkWell(
        onTap: () => _showConfirmationDialog(context),
        child: child!,
      );
    }

    return IconButton(
      icon: Icon(icon ?? Icons.delete),
      color: Theme.of(context).colorScheme.error,
      onPressed: () => _showConfirmationDialog(context),
    );
  }
}
