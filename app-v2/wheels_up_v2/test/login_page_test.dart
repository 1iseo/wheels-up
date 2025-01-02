// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:wheels_up_v2/auth/login_page.dart';
// import 'package:wheels_up_v2/auth/auth_provider.dart';
// import 'package:wheels_up_v2/auth/auth_service.dart';
// import 'package:wheels_up_v2/common/service_providers.dart';
// import 'package:wheels_up_v2/user/user_model.dart';

// class MockAuthService extends Mock implements AuthService {}

// class MockAuthNotifier extends Mock implements AuthNotifier {}

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

//   testWidgets('Login page test', (tester) async {
//     when(() => mockAuthService.loadLoggedInUser()).thenAnswer((_) async => null);

//     await tester.pumpWidget(
//       ProviderScope(
//         child: MaterialApp(
//           home: LoginPage(),
//         ),
//       ),
//     );

//     // Test that the login form is displayed
//     expect(find.byType(FormBuilder), findsOneWidget);

//     // Test that the login button is displayed
//     expect(find.byType(ElevatedButton), findsOneWidget);

//     // Test that the login button is disabled when the form is invalid
//     await tester.tap(find.byType(ElevatedButton));
//     expect(find.byType(ElevatedButton), findsOneWidget);

//     // Test that the login button is enabled when the form is valid
//     await tester.enterText(find.byType(FormBuilderTextField).first, 'username');
//     await tester.enterText(find.byType(FormBuilderTextField).last, 'password');
//     await tester.tap(find.byType(ElevatedButton));
//     expect(find.byType(ElevatedButton), findsOneWidget);

//     // Test that the login button calls the login function when clicked
//     when(() => mockAuthService.login('username', 'password')).thenAnswer(
//         (_) async => User(
//             id: "dasda",
//             username: "username",
//             fullName: "Full name",
//             email: "email@test.com",
//             emailVisibility: true,
//             verified: true,
//             role: "pemilik",
//             picture: "filename.jpg",
//             createdAt: DateTime.now(),
//             updatedAt: DateTime.now()));
//     await tester.tap(find.byType(ElevatedButton));
//     verify(() => mockAuthService.login('username', 'password')).called(1);
//   });
// }
