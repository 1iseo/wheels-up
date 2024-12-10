import 'package:flutter/material.dart';
import 'package:wheels_up/providers/user_profile_provider.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';
import 'package:wheels_up/services/user_service.dart';
import 'package:wheels_up/models/user.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  late final AuthService2 _authService;
  late final UserService _userService;
  late final ProfileChangeNotifier _profileChangeNotifier;
 

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService2>(context, listen: false);
    _userService = Provider.of<UserService>(context, listen: false);
    _profileChangeNotifier =
        Provider.of<ProfileChangeNotifier>(context, listen: false);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _nameController.text = currentUser.fullName ?? '';
        _emailController.text = currentUser.email ?? '';
        _usernameController.text = currentUser.username ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = UpdateProfileRequest(
        fullName: _nameController.text,
        email: _emailController.text,
        username: _usernameController.text,
      );

      await _profileChangeNotifier.updateProfile(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profilmu'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(Icons.person, size: 60),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              hintText: 'Nama',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _usernameController,
              hintText: 'Username',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
