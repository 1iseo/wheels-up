import 'package:flutter/material.dart';
import 'package:wheels_up/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _handleLogout() async {
    await AuthService().logout();
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.black,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Baby Zoo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildOption(
            context,
            title: 'Edit Profile',
            onTap: () {},
          ),
          const Divider(),
          _buildOption(
            context,
            title: 'Settings',
            onTap: () {},
          ),
          const Divider(),
          _buildOption(
            context,
            title: 'Help Center',
            onTap: () {},
          ),
          const Divider(),
          _buildOption(
            context,
            title: 'Logout',
            onTap: _handleLogout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}
