import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';

final formKey = GlobalKey<FormBuilderState>(debugLabel: "loginForm");

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

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
        error: (error, __) => {showErrorMessage(error.toString())},
      );
    });

    Future<void> handleLogin() async {
      if (formKey.currentState!.saveAndValidate()) {
        final usernameOrEmail = formKey.currentState!.value['username'];
        final password = formKey.currentState!.value['password'];

        try {
          await authStateNotifier.login(usernameOrEmail, password);
          log(authState.toString());
          if (!context.mounted) return;
          GoRouter.of(context).replace('/');
        } catch (e) {
          showErrorMessage(e.toString());
        }
      } else {
        // Form is invalid, show error
        showErrorMessage("Form tidak valid");
      }
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Header(),
          const SizedBox(height: 16),
          FormSection(
            formKey: formKey,
            isLoading: isLoading,
            loginFunc: handleLogin,
          ),
          const SizedBox(height: 16),
          Footer(),
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 100),
      child: SvgPicture.asset('assets/wheelsup_text_logo.svg'),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            "Login",
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

class FormSection extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isLoading;
  final VoidCallback loginFunc;

  const FormSection(
      {super.key,
      required this.formKey,
      required this.isLoading,
      required this.loginFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'username',
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Username or Email',
                hoverColor: Colors.transparent,
              ),
              validator: FormBuilderValidators.required(
                  errorText: "Username atau email tidak boleh kososng"),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: InputDecoration(
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                labelText: 'Password',
                hoverColor: Colors.transparent,
              ),
              validator: FormBuilderValidators.required(
                  errorText: "Password tidak boleh kosong"),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Lupa password?", textAlign: TextAlign.start),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : loginFunc,
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
                      'Login',
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
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Belum punya akun? "),
      GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/signup');
        },
        child: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.blue),
        ),
      )
    ]);
  }
}
