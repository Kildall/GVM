import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';
import 'package:gvm_flutter/src/widgets/layout/navbar/navbar.dart';

class BaseLayout extends StatefulWidget {
  final SettingsController settingsController;

  const BaseLayout({super.key, required this.settingsController});

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navItems = getNavItems(widget.settingsController);

    final children = navItems.map((item) => item.widget).toList();
    final items = navItems.map((item) => item.item).toList();

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: children,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              if (index == items.length ~/ 2 && items.length > 2) {
                // Center button
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: IconButton(
                    icon: items[index].icon,
                    onPressed: () => _onItemTapped(index),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }
              // Other buttons
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: _selectedIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2)),
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                child: IconButton(
                  icon: items[index].icon,
                  onPressed: () => _onItemTapped(index),
                  color: _selectedIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
