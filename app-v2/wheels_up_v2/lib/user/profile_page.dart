import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/user/user_model.dart';
import 'package:wheels_up_v2/user/user_service.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: authState.when(
        data: (authData) => authData.user != null
            ? ProfileContentView(
                user: authData.user!,
                onLogout: () async {
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (!context.mounted) return;
                  GoRouter.of(context).replace('/landing');
                })
            : const Center(child: Text('Please log in')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          error: error.toString(),
          onRetry: () => ref.invalidate(authNotifierProvider),
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class ProfileContentView extends StatelessWidget {
  final User? user;
  final VoidCallback onLogout;

  const ProfileContentView({super.key, this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    String? profilePictureUrl = null;
    if (user != null && user!.picture.isNotEmpty) {
      profilePictureUrl =
          UserService.getUserProfilePictureUrl(user!, null).toString();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatar(
              uri: profilePictureUrl,
            ),
            const SizedBox(height: 16),
            ProfileText(
              text: user?.fullName ?? 'User Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ProfileText(
              text: user?.email ?? 'user@example.com',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            ProfileText(
              text: '@${user?.username ?? 'username'}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            CustomListTile(
              title: 'Edit Profile',
              onTap: () {
                GoRouter.of(context).push('/profile/edit');
              },
            ),
            CustomListTile(
              title: 'Log out',
              onTap: onLogout,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String? uri;
  const ProfileAvatar({super.key, this.uri});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundImage: uri != null ? NetworkImage(uri!) : null,
      child: uri == null ? Icon(Icons.person, size: 60) : null,
    );
  }
}

class ProfileText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ProfileText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const CustomListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
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
