import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/customers/addresses/addresses_browse.dart';
import 'package:gvm_flutter/src/views/sales/customers/customers_browse.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/deliveries_browse.dart';
import 'package:gvm_flutter/src/views/sales/sales/sales_browse.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/common/navigation_card.dart';
import 'package:gvm_flutter/src/widgets/sales/sales_home_stats.dart';
import 'package:gvm_flutter/src/widgets/unauthorized_access.dart';

class SalesHome extends StatefulWidget {
  const SalesHome({super.key});

  @override
  _SalesHomeState createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  void _navigateToSales() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SalesBrowse(),
    ));
  }

  void _navigateToCustomers() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CustomersBrowse(),
    ));
  }

  void _navigateToDeliveries() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const DeliveriesBrowse(),
    ));
  }

  void _navigateToAddresses() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddressesBrowse(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).salesHomeTitle),
      ),
      body: AuthGuard(
        permissions: [
          AppPermissions.saleBrowse,
          AppPermissions.deliveryBrowse,
          AppPermissions.customerBrowse,
          AppPermissions.addressBrowse,
        ],
        allPermissions: false,
        fallback: const UnauthorizedAccess(
          showBackButton: false,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthGuard(
                  permissions: [
                    AppPermissions.saleBrowse,
                  ],
                  child: const SalesHomeStats(),
                ),
                AuthGuard(
                  permissions: [
                    AppPermissions.saleBrowse,
                    AppPermissions.customerBrowse,
                    AppPermissions.deliveryBrowse,
                  ],
                  allPermissions: false,
                  fallback: const UnauthorizedAccess(
                    showBackButton: false,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).modules,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      NavigationCard(
                        title: AppLocalizations.of(context).sales,
                        icon: Icons.shopping_cart,
                        description:
                            AppLocalizations.of(context).salesDescription,
                        onTap: () => _navigateToSales(),
                      ),
                      const SizedBox(height: 16),
                      NavigationCard(
                        title: AppLocalizations.of(context).customers,
                        icon: Icons.person,
                        description:
                            AppLocalizations.of(context).customersDescription,
                        onTap: () => _navigateToCustomers(),
                      ),
                      const SizedBox(height: 16),
                      NavigationCard(
                        title: AppLocalizations.of(context).deliveries,
                        icon: Icons.delivery_dining,
                        description:
                            AppLocalizations.of(context).deliveriesDescription,
                        onTap: () => _navigateToDeliveries(),
                      ),
                      const SizedBox(height: 16),
                      NavigationCard(
                        title: AppLocalizations.of(context).addresses,
                        icon: Icons.location_on,
                        description:
                            AppLocalizations.of(context).addressesDescription,
                        onTap: () => _navigateToAddresses(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
