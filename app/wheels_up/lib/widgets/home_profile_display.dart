import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/services/auth_service.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class HomeProfileDisplay extends StatefulWidget {
  const HomeProfileDisplay({super.key});

  @override
  State<HomeProfileDisplay> createState() => _HomeProfileDisplayState();
}

class _HomeProfileDisplayState extends State<HomeProfileDisplay> {
  late final AuthService2 _authService;
  User2? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService2>(context, listen: false);
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _authService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load user';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80'),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Halo!"),
                if (_isLoading)
                  const SizedBox(
                    width: 80,
                    child: LinearProgressIndicator(),
                  )
                else if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  )
                else
                  Text(
                    _user?.fullName ?? 'Guest',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
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
