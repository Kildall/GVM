import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/request/supplier_request.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/widgets/supplier/supplier_form.dart';

class SupplierAdd extends StatelessWidget {
  const SupplierAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addSupplier),
      ),
      body: SupplierForm(
        onSubmit: (supplier) async {
          try {
            final request = CreateSupplierRequest(name: supplier.name!);

            final response = await AuthManager.instance.apiService.post(
                '/api/suppliers',
                fromJson: (json) => {},
                body: request.toJson());

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
