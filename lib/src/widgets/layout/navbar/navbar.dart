import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:gvm_flutter/src/views/settings/settings_view.dart';

class NavItem {
  final BottomNavigationBarItem item;
  final Widget widget;

  NavItem({required this.item, required this.widget});
}

List<NavItem> getNavItems(SettingsController settingsController) {
  final user = AuthManager.instance.currentUser;
  final List<NavItem> navItems = [];

  if (user == null) {
    return [];
  }

  // Helper function to check permissions
  bool hasPermission(String permission) {
    return user.permissions.contains(permission);
  }

  // Products
  if (hasPermission('product.browse') ||
      hasPermission('supplier.browse') ||
      hasPermission('purchase.browse')) {
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
  if (hasPermission('sale.browse') || hasPermission('customer.browse')) {
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
    item:
        BottomNavigationBarItem(icon: Icon(Icons.add_business), label: 'Home'),
    widget: Center(
      child: Text('Home Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ),
  ));

  // Employees
  if (hasPermission('employee.browse')) {
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
