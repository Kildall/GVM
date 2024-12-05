import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/customers_requests.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_read.dart';

class CustomerEdit extends StatefulWidget {
  final Customer customer;

  const CustomerEdit({
    super.key,
    required this.customer,
  });

  @override
  _CustomerEditState createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Form fields
  late String? name;
  late String? phone;
  late bool enabled;
  late List<Address> selectedAddresses;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing customer data
    name = widget.customer.name;
    phone = widget.customer.phone;
    enabled = widget.customer.enabled ?? true;
    selectedAddresses = List<Address>.from(widget.customer.addresses ?? []);
  }

  Future<void> _updateCustomer() async {
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
      final request = UpdateCustomerRequest(
        customerId: widget.customer.id!,
        name: name!,
        phone: phone!,
        enabled: enabled,
        addresses: selectedAddresses
            .map((address) => Address(
                  name: address.name,
                  street1: address.street1!,
                  street2: address.street2,
                  city: address.city!,
                  state: address.state!,
                  postalCode: address.postalCode!,
                  details: address.details,
                  enabled: address.enabled,
                ))
            .toList(),
      );

      final response = await AuthManager.instance.apiService.put(
        '/api/customers',
        body: request.toJson(),
        fromJson: (json) => Customer.fromJson(json),
      );

      if (mounted) {
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
    // Declare variables outside the builder
    String? name;
    String? street1;
    String? street2;
    String? city;
    String? state;
    String? postalCode;
    String? details;
    bool enabled = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).addAddress),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).name,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).street,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            street1 = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).secondaryStreet,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            street2 = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).city,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).state,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            state = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).postalCode,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            postalCode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).details,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          setState(() {
                            details = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context).enabled),
                        value: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (street1?.isNotEmpty == true &&
                        city?.isNotEmpty == true) {
                      this.setState(() {
                        selectedAddresses.add(Address(
                          name: name,
                          street1: street1,
                          street2: street2,
                          city: city,
                          state: state,
                          postalCode: postalCode,
                          details: details,
                          enabled: enabled,
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
      },
    );
  }

  void _editAddress(int index) {
    final address = selectedAddresses[index];

    // Declare variables outside the builder
    String? name = address.name;
    String? street1 = address.street1;
    String? street2 = address.street2;
    String? city = address.city;
    String? state = address.state;
    String? postalCode = address.postalCode;
    String? details = address.details;
    bool enabled = address.enabled ?? true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).editAddress),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).name,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: name,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).street,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: street1,
                        onChanged: (value) {
                          setState(() {
                            street1 = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).secondaryStreet,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: street2,
                        onChanged: (value) {
                          setState(() {
                            street2 = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).city,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: city,
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).state,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: state,
                        onChanged: (value) {
                          setState(() {
                            state = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).postalCode,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: postalCode,
                        onChanged: (value) {
                          setState(() {
                            postalCode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).details,
                          border: const OutlineInputBorder(),
                        ),
                        initialValue: details,
                        maxLines: 3,
                        onChanged: (value) {
                          setState(() {
                            details = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context).enabled),
                        value: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    if (street1?.isNotEmpty == true &&
                        city?.isNotEmpty == true) {
                      this.setState(() {
                        // Changed from setState to this.setState
                        selectedAddresses[index] = address.copyWith(
                          name: name,
                          street1: street1,
                          street2: street2,
                          city: city,
                          state: state,
                          postalCode: postalCode,
                          details: details,
                          enabled: enabled,
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
      },
    );
  }

  bool hasChanges() {
    return name != widget.customer.name ||
        phone != widget.customer.phone ||
        enabled != widget.customer.enabled ||
        !areAddressListsEqual(
            selectedAddresses, widget.customer.addresses ?? []);
  }

  bool areAddressListsEqual(List<Address> list1, List<Address> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].street1 != list2[i].street1 ||
          list1[i].city != list2[i].city ||
          list1[i].state != list2[i].state ||
          list1[i].postalCode != list2[i].postalCode) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasChanges()) {
          return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).discardChanges),
                  content: Text(
                      AppLocalizations.of(context).discardChangesDescription),
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
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editCustomer),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: isLoading ? null : _updateCustomer,
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
                buildBasicInfoCard(),
                const SizedBox(height: 16),
                buildStatusCard(),
                const SizedBox(height: 16),
                buildAddressesCard(),
                const SizedBox(height: 24),
                if (hasChanges()) ...[
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateCustomer,
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
                            AppLocalizations.of(context).save,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBasicInfoCard() {
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
              ),
              initialValue: name,
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
              initialValue: phone,
              onChanged: (value) => setState(() => phone = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).status,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).enabled),
              subtitle: Text(enabled
                  ? AppLocalizations.of(context).enabled
                  : AppLocalizations.of(context).disabled),
              value: enabled,
              onChanged: (bool value) {
                setState(() => enabled = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddressesCard() {
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
                      leading: const CircleAvatar(
                        child: Icon(Icons.location_on),
                      ),
                      title: Text(address.street1 ??
                          AppLocalizations.of(context).noStreet),
                      subtitle: Text(
                        [
                          address.city,
                          address.state,
                          address.postalCode,
                        ]
                            .where((item) => item != null && item.isNotEmpty)
                            .join(', '),
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
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
