import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/loading_page.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/routing/routing.dart';
import 'package:wheels_up_v2/utils.dart';
import 'package:wheels_up_v2/theme.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      builder: (context, child) {
        return _EagerInitialization(
          onLoaded: (_) => child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light.copyWith(textTheme: textTheme),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  final WidgetBuilder onLoaded;
  const _EagerInitialization({required this.onLoaded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    ref.watch(authServiceProvider);
    final authNotifier = ref.watch(authNotifierProvider);

    return authNotifier.when(
      loading: () => const LoadingPage(),
      error: (err, stackTrace) => AppStartupErrorPage(
        message: err.toString(),
        onRetry: () => ref.invalidate(authNotifierProvider),
      ),
      data: (_) => onLoaded(context),
    );
  }
}

class AppStartupErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const AppStartupErrorPage(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Text('Error initializing app: $message'),
          TextButton(onPressed: onRetry, child: const Text('Retry'))
        ],
      ),
    );
  }
}
