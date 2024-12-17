import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/address_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/customers/addresses/address_read.dart';
import 'package:gvm_flutter/src/widgets/addresses/addresses_filters.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class AddressesBrowse extends StatefulWidget {
  const AddressesBrowse({super.key});

  @override
  _AddressesBrowseState createState() => _AddressesBrowseState();
}

class _AddressesBrowseState extends State<AddressesBrowse>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  List<Address> addresses = [];
  String? searchQuery;
  bool? selectedEnabled;
  String? selectedCity;
  String? selectedState;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  Future<void> refresh() async {
    await _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final addressesResponse = await AuthManager.instance.apiService
          .get<GetAddressesResponse>('/api/addresses',
              fromJson: GetAddressesResponse.fromJson);

      setState(() {
        isLoading = false;
        addresses = addressesResponse.data?.addresses ?? [];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred)));
      }
    }
  }

  void _navigateToAddressDetail(Address address) {
    if (address.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddressRead(addressId: address.id!),
      ));
    }
  }

  void _clearFilters() {
    setState(() {
      searchQuery = null;
      selectedEnabled = null;
      selectedCity = null;
      selectedState = null;
    });
  }

  List<String> get uniqueCities {
    return addresses
        .where((address) => address.city != null)
        .map((address) => address.city!)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get uniqueStates {
    return addresses
        .where((address) => address.state != null)
        .map((address) => address.state!)
        .toSet()
        .toList()
      ..sort();
  }

  List<Address> get filteredAddresses {
    return addresses.where((address) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          address.name?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          address.street1?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          address.street2?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          address.city?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          address.state?.toLowerCase().contains(searchQuery!.toLowerCase()) ==
              true ||
          address.postalCode
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesEnabled =
          selectedEnabled == null || address.enabled == selectedEnabled;

      final matchesCity = selectedCity == null || address.city == selectedCity;

      final matchesState =
          selectedState == null || address.state == selectedState;

      return matchesSearch && matchesEnabled && matchesCity && matchesState;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addresses),
      ),
      body: Column(
        children: [
          AddressesFilters(
            searchQuery: searchQuery,
            selectedCity: selectedCity,
            selectedState: selectedState,
            selectedEnabled: selectedEnabled,
            onSearchChanged: (value) => setState(() => searchQuery = value),
            onCityChanged: (value) => setState(() => selectedCity = value),
            onStateChanged: (value) => setState(() => selectedState = value),
            onEnabledChanged: (value) =>
                setState(() => selectedEnabled = value),
            onClearFilters: _clearFilters,
            cities: uniqueCities,
            states: uniqueStates,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : addresses.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noAddressesFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredAddresses.length,
                        itemBuilder: (context, index) {
                          final address = filteredAddresses[index];
                          return _AddressListItem(
                            address: address,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.addressRead])
                                ? _navigateToAddressDetail(address)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AddressListItem extends StatelessWidget {
  final Address address;
  final VoidCallback onTap;

  const _AddressListItem({
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                  address.street1 ?? AppLocalizations.of(context).noStreet),
            ),
            if (address.enabled != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: address.enabled == true
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  address.enabled == true
                      ? AppLocalizations.of(context).enabled
                      : AppLocalizations.of(context).disabled,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text([
              address.street2,
              address.city,
              address.state,
              address.postalCode,
            ].where((item) => item != null).join(', ')),
            Row(
              children: [
                if (address.customer?.name != null) ...[
                  Icon(Icons.person,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Expanded(child: Text(address.customer!.name!)),
                ],
                if (address.$deliveriesCount != null) ...[
                  Icon(Icons.local_shipping,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text('${address.$deliveriesCount}'),
                ],
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
