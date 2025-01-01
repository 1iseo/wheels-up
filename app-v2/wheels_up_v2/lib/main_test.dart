import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/service_providers.dart';

import 'package:wheels_up_v2/utils.dart';
import 'package:wheels_up_v2/theme.dart';

void main() {
  runApp(ProviderScope(child: _EagerInitialization(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");
    // MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      // theme: theme.lightHighContrast(),
      // home: EditProfilePage(
      //     onSave: ((d) async {}),
      //     initialUser: User(
      //         id: "dasda",
      //         username: "My Username",
      //         fullName: "Full name",
      //         email: "email@test.com",
      //         emailVisibility: true,
      //         verified: true,
      //         role: "pemilik",
      //         picture: "filename.jpg",
      //         createdAt: DateTime.now(),
      //         updatedAt: DateTime.now())),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    ref.watch(authServiceProvider);
    ref.watch(authNotifierProvider);
    return child;
  }
}
