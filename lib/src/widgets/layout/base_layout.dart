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
  @override
  Widget build(BuildContext context) {
    final navItems = getNavItems(widget.settingsController, context);

    final children = navItems.map((item) => item.widget).toList();
    final items = navItems.map((item) => item.item).toList();

    return DefaultTabController(
      length: items.length,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          padding: EdgeInsets.fromLTRB(2, 0, 2, 4),
          child: TabBar(
            tabAlignment: TabAlignment.fill,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: List.generate(items.length, (index) {
              // Other buttons
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                child: items[index].icon,
              );
            }),
          ),
        ),
        body: TabBarView(
          children: children,
        ),
      ),
    );
  }
}
