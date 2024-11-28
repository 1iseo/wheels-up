import 'package:flutter/material.dart';
import 'package:wheels_up/pages/profile/profile_page.dart';
import 'package:wheels_up/widgets/navigation_destinations.dart';
import 'package:wheels_up/pages/home/home_page.dart';
import 'package:wheels_up/pages/home/home_page_penyewa.dart';

// This class handles bottom bar navigation, and also creates nested navigators for each tab / page.
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  _MainAppShellState createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, const HomePage()),
          _buildNavigator(1, const HomePagePenyewa()),
          _buildNavigator(2, const HomePagePenyewa()),
          _buildNavigator(3, const ProfilePage())
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: mainNavigationDestinations,
      ),
    );
  }

  Widget _buildNavigator(int index, Widget screen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (_) => screen);
      },
    );
  }
}
