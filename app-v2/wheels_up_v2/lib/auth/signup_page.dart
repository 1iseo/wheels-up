import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/user/user_service.dart';

final formKey = GlobalKey<FormBuilderState>(debugLabel: "signUpForm");

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void showErrorMessage(String errMsg) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errMsg),
      ));
    }

    final authState = ref.watch(authNotifierProvider);
    final authStateNotifier = ref.read(authNotifierProvider.notifier);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        error: (error, __) => showErrorMessage(error.toString()),
      );
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            const SignUpHeaderText(),
            const SizedBox(
              height: 16,
            ),
            SignUpForm(
              formKey: formKey,
              isLoading: isLoading,
              onSignUp: () async {
                if (formKey.currentState!.saveAndValidate()) {
                  final fullName = formKey.currentState!.value['fullName'];
                  final username = formKey.currentState!.value['username'];
                  final email = formKey.currentState!.value['email'];
                  final password = formKey.currentState!.value['password'];
                  final confirmPassword =
                      formKey.currentState!.value['confirmPassword'];
                  final role = formKey.currentState!.value['role'];

                  final request = UserRegistrationRequest(
                    fullName: fullName,
                    username: username,
                    email: email,
                    password: password,
                    passwordConfirm: confirmPassword,
                    role: role,
                  );

                  try {
                    await authStateNotifier.signUp(request);
                  } catch (e) {
                    showErrorMessage(e.toString());
                  }
                } else {
                  showErrorMessage("Form tidak valid!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpHeaderText extends StatelessWidget {
  const SignUpHeaderText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Siap Menikmati Perjalananmu?",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isLoading;
  final VoidCallback onSignUp;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'fullName',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Full Name',
                hoverColor: Colors.transparent,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Please enter your full name'),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Email',
                hoverColor: Colors.transparent,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Please enter your email'),
                FormBuilderValidators.email(
                    errorText: 'Please enter a valid email'),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'username',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Username',
                hoverColor: Colors.transparent,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Please enter a username'),
                FormBuilderValidators.minLength(4,
                    errorText: 'Username must be at least 4 characters'),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Password',
                hoverColor: Colors.transparent,
              ),
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Please enter a password'),
                FormBuilderValidators.minLength(8,
                    errorText: 'Password must be at least 8 characters'),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'confirmPassword',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Confirm Password',
                hoverColor: Colors.transparent,
              ),
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Please enter a confirm password'),
                (value) {
                  if (value !=
                      formKey.currentState!.fields['password']?.value) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderDropdown(
              name: 'role',
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'penyewa', child: Text('Penyewa')),
                DropdownMenuItem(value: 'pemilik', child: Text('Pemilik')),
              ],
              validator: FormBuilderValidators.required(
                  errorText: 'Please select a role'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : () => onSignUp(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Sudah punya akun? "),
              GestureDetector(
                  onTap: () {
                    // We can only go to this page from the login page.
                    GoRouter.of(context).pop();
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(color: Colors.blue),
                  ))
            ])
          ],
        ),
      ),
    );
  }
}
