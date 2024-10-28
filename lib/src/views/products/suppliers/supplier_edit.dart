import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/widgets/supplier/supplier_form.dart';

class SupplierEdit extends StatelessWidget {
  final Supplier supplier;

  const SupplierEdit({
    super.key,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editSupplier),
      ),
      body: SupplierForm(
        initialSupplier: supplier,
        onSubmit: (updatedSupplier) async {
          try {
            final response = await AuthManager.instance.apiService
                .put<Supplier>('/api/suppliers/${supplier.id}',
                    fromJson: Supplier.fromJson,
                    body: updatedSupplier.toJson());

            if (response.data != null && context.mounted) {
              Navigator.of(context).pop(response.data);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context).anErrorOccurred)));
            }
          }
        },
      ),
    );
  }
}
