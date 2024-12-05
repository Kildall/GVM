import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/customers_requests.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_read.dart';

class CustomerAdd extends StatefulWidget {
  const CustomerAdd({super.key});

  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _autovalidateMode = false;

  // Form fields
  String? name;
  String? phone;
  List<Address> selectedAddresses = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createCustomer() async {
    setState(() => _autovalidateMode = true);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).fixErrors),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final request = CreateCustomerRequest(
        name: name!,
        phone: phone!,
        addresses: selectedAddresses
            .map((address) => Address(
                  name: address.name,
                  street1: address.street1!,
                  street2: address.street2,
                  city: address.city!,
                  state: address.state!,
                  postalCode: address.postalCode!,
                  details: address.details,
                ))
            .toList(),
      );

      final response = await AuthManager.instance.apiService.post(
        '/api/customers',
        body: request.toJson(),
        fromJson: (json) => Customer.fromJson(json),
      );

      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).success),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerRead(customerId: response.data!.id!),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _addAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? addressName;
        String? street1;
        String? street2;
        String? city;
        String? state;
        String? postalCode;
        String? details;
        bool addressEnabled = true;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).addAddress),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).name,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => addressName = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).street,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => street1 = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).secondaryStreet,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => street2 = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).city,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => city = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).state,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => state = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).postalCode,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => postalCode = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).details,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => details = value,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).enabled),
                  value: addressEnabled,
                  onChanged: (value) => addressEnabled = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                if (street1?.isNotEmpty == true && city?.isNotEmpty == true) {
                  setState(() {
                    selectedAddresses.add(Address(
                      name: addressName,
                      street1: street1,
                      street2: street2,
                      city: city,
                      state: state,
                      postalCode: postalCode,
                      details: details,
                      enabled: addressEnabled,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context).add),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges()) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context).discardChanges),
              content:
                  Text(AppLocalizations.of(context).discardChangesDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context).discard),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  bool _hasUnsavedChanges() {
    return name != null || phone != null || selectedAddresses.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).add),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: isLoading ? null : _createCustomer,
              tooltip: AppLocalizations.of(context).create,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoCard(),
                const SizedBox(height: 16),
                _buildAddressesCard(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _createCustomer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          AppLocalizations.of(context).create,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).basicInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).name,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
                errorStyle: const TextStyle(color: Colors.red),
              ),
              autovalidateMode: _autovalidateMode
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).fieldRequired;
                }
                return null;
              },
              onChanged: (value) => setState(() => name = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).phone,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
              onChanged: (value) => setState(() => phone = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).addresses,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton.icon(
                  onPressed: _addAddress,
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).addAddress),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedAddresses.isEmpty)
              Center(
                child: Text(
                  AppLocalizations.of(context).noAddressesFound,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedAddresses.length,
                itemBuilder: (context, index) {
                  final address = selectedAddresses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: address.enabled == true
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      title: Text(address.name ??
                          address.street1 ??
                          AppLocalizations.of(context).noStreet),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (address.street1 != null) Text(address.street1!),
                          if (address.street2 != null) Text(address.street2!),
                          Text(
                            [
                              address.city,
                              address.state,
                              address.postalCode,
                            ]
                                .where(
                                    (item) => item != null && item.isNotEmpty)
                                .join(', '),
                          ),
                          if (address.details != null &&
                              address.details!.isNotEmpty)
                            Text(
                              address.details!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editAddress(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                selectedAddresses.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _editAddress(int index) {
    final address = selectedAddresses[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? addressName = address.name;
        String? street1 = address.street1;
        String? street2 = address.street2;
        String? city = address.city;
        String? state = address.state;
        String? postalCode = address.postalCode;
        String? details = address.details;
        bool addressEnabled = address.enabled ?? true;

        return AlertDialog(
          title: Text(AppLocalizations.of(context).editAddress),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).name,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: addressName,
                  onChanged: (value) => addressName = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).street,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: street1,
                  onChanged: (value) => street1 = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).secondaryStreet,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: street2,
                  onChanged: (value) => street2 = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).city,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: city,
                  onChanged: (value) => city = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).state,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: state,
                  onChanged: (value) => state = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).postalCode,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: postalCode,
                  onChanged: (value) => postalCode = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).details,
                    border: const OutlineInputBorder(),
                  ),
                  initialValue: details,
                  maxLines: 3,
                  onChanged: (value) => details = value,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).enabled),
                  value: addressEnabled,
                  onChanged: (value) => addressEnabled = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                if (street1?.isNotEmpty == true && city?.isNotEmpty == true) {
                  setState(() {
                    selectedAddresses[index] = address.copyWith(
                      name: addressName,
                      street1: street1,
                      street2: street2,
                      city: city,
                      state: state,
                      postalCode: postalCode,
                      details: details,
                      enabled: addressEnabled,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context).save),
            ),
          ],
        );
      },
    );
  }
}
