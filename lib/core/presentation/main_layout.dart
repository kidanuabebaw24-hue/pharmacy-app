import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.teal,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.teal.withOpacity(0.1),
              color: Colors.grey[600],
              tabs: const [
                GButton(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: Icons.inventory,
                  text: 'Inventory',
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: 'Orders',
                ),
                GButton(
                  icon: Icons.people,
                  text: 'Suppliers',
                ),
              ],
              selectedIndex: _calculateSelectedIndex(context),
              onTabChange: (index) => _onItemTapped(index, context),
            ),
          ),
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/inventory')) return 1;
    if (location.startsWith('/orders')) return 2;
    if (location.startsWith('/suppliers')) return 3;
    return 0; // Dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/inventory');
        break;
      case 2:
        context.go('/orders');
        break;
      case 3:
        context.go('/suppliers');
        break;
    }
  }
}
