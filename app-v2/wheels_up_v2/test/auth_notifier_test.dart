// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:wheels_up_v2/auth/auth_provider.dart';
// import 'package:wheels_up_v2/auth/auth_service.dart';
// import 'package:wheels_up_v2/common/service_providers.dart';
// import 'package:wheels_up_v2/user/user_model.dart';

// class MockAuthService extends Mock implements AuthService {}

// void main() {
//   late MockAuthService mockAuthService;
//   late ProviderContainer container;

//   setUp(() {
//     mockAuthService = MockAuthService();
//     container = ProviderContainer(
//       overrides: [
//         authServiceProvider.overrideWithValue(mockAuthService),
//       ],
//     );
//   });

//   tearDown(() {
//     container.dispose();
//   });

//   test('initial state is unauthenticated when no user is logged in', () async {
//     when(() => mockAuthService.loadLoggedInUser())
//         .thenAnswer((_) async => null);

//     final authNotifier = container.read(authNotifierProvider.notifier);
//     final authState = await authNotifier.build();

//     expect(authState.status, AuthStatus.unauthenticated);
//     expect(authState.user, isNull);
//   });

//   test('login updates state to authenticated with user data', () async {
//     final user = User(
//       id: 'user_123456',
//       username: 'username_123456',
//       fullName: 'Full Name 123456',
//       email: 'email_123456@example.com',
//       emailVisibility: true,
//       verified: true,
//       role: 'penyewa',
//       picture: 'picture_123456.jpg',
//       createdAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
//       updatedAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
//     );

//     when(() => mockAuthService.login('test@example.com', 'password'))
//         .thenAnswer((_) async => user);

//     final authNotifier = container.listen<AuthNotifier>(
//         authNotifierProvider.notifier, (_, __) {});
//     await authNotifier.read().login('test@example.com', 'password');

//     final state = container.read(authNotifierProvider);
//     expect(state.value?.status, AuthStatus.authenticated);
//     expect(state.value?.user, user);
//   });

//   test('logout updates state to unauthenticated', () async {
//     when(() => mockAuthService.logout()).thenAnswer((_) async {});

//     final authNotifier = container.read(authNotifierProvider.notifier);
//     await authNotifier.logout();

//     final state = container.read(authNotifierProvider);
//     expect(state.value?.status, AuthStatus.unauthenticated);
//     expect(state.value?.user, isNull);
//   });

//   test('handles exception in initialization', () async {
//     when(() => mockAuthService.loadLoggedInUser())
//         .thenThrow(Exception('Error'));

//     final authNotifier = container.read(authNotifierProvider.notifier);
//     final authState = await authNotifier.build();

//     expect(authState.status, AuthStatus.unauthenticated);
//     expect(authState.user, isNull);
//   });

//   test('provider starts in loading state and transitions to value', () async {
//     final user = User(
//       id: 'user_123456',
//       username: 'username_123456',
//       fullName: 'Full Name 123456',
//       email: 'email_123456@example.com',
//       emailVisibility: true,
//       verified: true,
//       role: 'penyewa',
//       picture: 'picture_123456.jpg',
//       createdAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
//       updatedAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
//     );

//     when(() => mockAuthService.loadLoggedInUser())
//         .thenAnswer((_) async => user);

//     final authNotifier = container.read(authNotifierProvider.notifier);

//     // Initial state: Loading
//     expect(container.read(authNotifierProvider),
//         const AsyncValue<AuthState>.loading());

//     // Wait for the provider to complete initialization
//     await container.read(authNotifierProvider.notifier).build();

//     // After loading: Authenticated with user
//     final state = container.read(authNotifierProvider);
//     expect(state, isA<AsyncValue<AuthState>>());
//     expect(state.value?.status, AuthStatus.authenticated);
//     expect(state.value?.user, user);
//   });
// }
