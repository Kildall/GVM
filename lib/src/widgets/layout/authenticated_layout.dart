import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/views/settings/settings_view.dart';
import 'package:gvm_flutter/src/settings/settings_controller.dart';

class AuthenticatedLayout extends StatefulWidget {
  final SettingsController settingsController;

  const AuthenticatedLayout({super.key, required this.settingsController});

  @override
  _AuthenticatedLayoutState createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Center(child: Text('Home Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
      const Center(child: Text('Search Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
      const Center(child: Text('Add Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
      const Center(child: Text('Notifications Page', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))),
      SettingsView(controller: widget.settingsController),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}