import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:gvm_flutter/src/views/deliveries/deliveries_home.dart';
import 'package:gvm_flutter/src/views/employees/employees_home.dart';
import 'package:gvm_flutter/src/views/home/home_dashboard.dart';
import 'package:gvm_flutter/src/views/products/products_home.dart';
import 'package:gvm_flutter/src/views/sales/sales_home.dart';
import 'package:gvm_flutter/src/views/settings/settings_view.dart';

class NavItem {
  final BottomNavigationBarItem item;
  final Widget widget;
  final bool isDefault;

  NavItem({required this.item, required this.widget, this.isDefault = false});
}

List<NavItem> getNavItems(
    SettingsController settingsController, BuildContext context) {
  final user = AuthManager.instance.currentUser;
  final List<NavItem> navItems = [];

  if (user == null) {
    return [];
  }

  // Products
  if (user.hasPermission('product.browse') ||
      user.hasPermission('supplier.browse') ||
      user.hasPermission('purchase.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: AppLocalizations.of(context).productsHomeTitle),
      widget: const ProductsHome(),
    ));
  }

  // Sales
  if (user.hasPermission('sale.browse') ||
      user.hasPermission('customer.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale),
          label: AppLocalizations.of(context).salesHomeTitle),
      widget: const SalesHome(),
    ));
  }

  // Main stats and shortcuts
  if (user.hasPermission('sale.browse') &&
      user.hasPermission('customer.browse') &&
      user.hasPermission('employee.browse') &&
      user.hasPermission('product.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.add_business),
          label: AppLocalizations.of(context).dashboardHomeTitle,
          backgroundColor: Theme.of(context).colorScheme.onPrimary),
      widget: const HomeDashboard(),
      isDefault: true,
    ));
  }

  // Employees
  if (user.hasPermission('employee.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.badge),
          label: AppLocalizations.of(context).employeesHomeTitle),
      widget: const EmployeesHome(),
    ));
  }

  // Deliveries
  if (user.hasPermission('delivery.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining),
          label: AppLocalizations.of(context).deliveriesHomeTitle),
      widget: const DeliveriesHome(),
    ));
  }

  // Settings (always visible)
  navItems.add(NavItem(
    item: BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: AppLocalizations.of(context).settingsHomeTitle),
    widget: SettingsView(controller: settingsController),
  ));

  return navItems;
}
