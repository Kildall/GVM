import 'package:flutter/material.dart';

class MobileBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the device is mobile (you can adjust this width as needed)
    bool isMobile = MediaQuery.of(context).size.width < 600;

    if (!isMobile) {
      return SizedBox.shrink(); // Return an empty widget for non-mobile devices
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onNavigationItemTapped;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: MobileBottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavigationItemTapped,
      ),
    );
  }
}