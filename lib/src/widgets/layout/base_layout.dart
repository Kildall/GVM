import 'package:flutter/material.dart';

class BaseLayout extends StatefulWidget {
  final List<BottomNavigationBarItem> navItems;
  final List<Widget> children;

  const BaseLayout({
    super.key,
    required this.navItems,
    required this.children,
  }) : assert(navItems.length == children.length);

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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.children,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.navItems.length, (index) {
            if (index == widget.navItems.length ~/ 2) {
              return const SizedBox(width: 48);
            }
            return IconButton(
              icon: widget.navItems[index].icon,
              onPressed: () => _onItemTapped(index),
            );
          }),
        ),
      ),
      floatingActionButton: widget.navItems.length % 2 == 1
          ? FloatingActionButton(
              onPressed: () => _onItemTapped(widget.navItems.length ~/ 2),
              child: widget.navItems[widget.navItems.length ~/ 2].icon,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
