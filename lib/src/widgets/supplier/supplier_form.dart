import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/helpers/validators.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class SupplierForm extends StatefulWidget {
  final Supplier? initialSupplier;
  final Future<void> Function(Supplier supplier) onSubmit;

  const SupplierForm({
    super.key,
    required this.onSubmit,
    this.initialSupplier,
  });

  @override
  SupplierFormState createState() => SupplierFormState();
}

class SupplierFormState extends State<SupplierForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  late TextEditingController _nameController;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSupplier?.name);
    _enabled = widget.initialSupplier?.enabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      final supplierData = Supplier(
        id: widget.initialSupplier?.id,
        name: _nameController.text.trim(),
        enabled: _enabled,
      );

      try {
        await widget.onSubmit(supplierData);
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).basicInformation,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).name,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.business),
                      ),
                      validator: (value) => Validators.validateString(value,
                          minLength: 3, maxLength: 256),
                      textInputAction: TextInputAction.next,
                      enabled: !_isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _handleSubmit,
              icon: _isSubmitting
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                widget.initialSupplier == null
                    ? AppLocalizations.of(context).create
                    : AppLocalizations.of(context).update,
              ),
            ),
            if (widget.initialSupplier != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                icon: const Icon(Icons.cancel),
                label: Text(AppLocalizations.of(context).cancel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
