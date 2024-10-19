import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:gvm_flutter/src/views/home/home_dashboard.dart';
import 'package:gvm_flutter/src/views/settings/settings_view.dart';

class NavItem {
  final BottomNavigationBarItem item;
  final Widget widget;

  NavItem({required this.item, required this.widget});
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
          icon: Icon(Icons.inventory), label: 'Products'),
      widget: Center(
        child: Text('Products Page',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      ),
    ));
  }

  // Sales
  if (user.hasPermission('sale.browse') ||
      user.hasPermission('customer.browse')) {
    navItems.add(NavItem(
      item: BottomNavigationBarItem(
          icon: Icon(Icons.point_of_sale), label: 'Sales'),
      widget: Center(
        child: Text('Sales Page',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      ),
    ));
  }

  // Add
  navItems.add(NavItem(
    item: BottomNavigationBarItem(
        icon: Icon(Icons.add_business),
        label: 'Home',
        backgroundColor: Theme.of(context).colorScheme.onPrimary),
    widget: Center(
      child: HomeDashboard(),
    ),
  ));

  // Employees
  if (user.hasPermission('employee.browse')) {
    navItems.add(NavItem(
      item:
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Employees'),
      widget: Center(
        child: Text('Employees Page',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      ),
    ));
  }

  // Settings (always visible)
  navItems.add(NavItem(
    item:
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    widget: SettingsView(controller: settingsController),
  ));

  return navItems;
}
