import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/pages/login_page.dart';
import 'package:wheels_up/pages/landing_welcome.dart';

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
          _buildNavigator(0, HomePagePenyewa()),
          _buildNavigator(1, HomePagePenyewa()),
          _buildNavigator(2, HomePagePenyewa()),
          _buildNavigator(3, ProfilePage())
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(
                Icons.chat,
                color: Colors.black,
              ),
              label: "Chat"),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
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

class HomeProfileDisplay extends StatelessWidget {
  const HomeProfileDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80'),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo!"),
                Text(
                  "Baby Zoo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => {},
          iconSize: 24,
          icon: const Icon(Icons.notifications),
          color: Colors.black,
        )
      ],
    );
  }
}

class CarListingCard extends StatelessWidget {
  const CarListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              'assets/jeep.png',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'JEEP WRANGLER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(4, (index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rp. 500.000,00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Purwokerto Selatan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
      hintStyle: TextStyle(color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.grey.shade200,
      hintText: "Search",
      prefixIcon: const Icon(Icons.search),
      suffixIcon: const Icon(Icons.tune_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ));
  }
}

class HomePagePenyewa extends StatelessWidget {
  const HomePagePenyewa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: SvgPicture.asset('assets/wheelsup_text_logo.svg')),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            HomeProfileDisplay(),
            SizedBox(
              height: 16,
            ),
            SearchBar(),
            SizedBox(
              height: 8,
            ),
            CarListingCard()
          ],
        ),
      ),
    );
  }
}

class HomePagePenyedia extends StatelessWidget {
  const HomePagePenyedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: SvgPicture.asset('assets/wheelsup_text_logo.svg')),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            HomeProfileDisplay(),
            SizedBox(
              height: 16,
            ),
            SearchBar(),
            SizedBox(
              height: 8,
            ),
            CarListingCard()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    
    // Navigate to login page and clear the entire navigation stack
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: SvgPicture.asset('assets/wheelsup_text_logo.svg'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/profile_picture.png'),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'User Name', // Replace with actual user name
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'user@example.com', // Replace with actual email
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              _buildOption(
                context,
                title: 'Edit Profile',
                onTap: () {
                  // Add navigation logic
                },
              ),
              _buildOption(
                context,
                title: 'Log out',
                onTap: _handleLogout,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}
