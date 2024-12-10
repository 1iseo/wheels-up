import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/config/api_config.dart';
import 'package:wheels_up/models/user.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';
import 'package:wheels_up/pages/main_shell.dart';
import 'package:wheels_up/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  final void Function(bool) notifyAuthChanged;
  const SignUpPage({super.key, required this.notifyAuthChanged});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _authService = AuthService2();
  final pb = PocketBase(ApiConfig.pocketbaseUrl);

  bool _isLoading = false;

  String? nameError;
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  String selectedRole = 'penyewa'; // Default value

  Future<void> _handleSignup() async {
    setState(() {
      nameError = null;
      emailError = null;
      usernameError = null;
      passwordError = null;
      confirmPasswordError = null;
      _isLoading = true;
    });

    // Validate inputs
    bool hasError = false;
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = 'Please enter your full name';
        hasError = true;
      });
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Please enter your email';
        hasError = true;
      });
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      setState(() {
        emailError = 'Please enter a valid email';
        hasError = true;
      });
    }

    if (usernameController.text.isEmpty) {
      setState(() {
        usernameError = 'Please enter a username';
        hasError = true;
      });
    } else if (usernameController.text.length < 4) {
      setState(() {
        usernameError = 'Username must be at least 4 characters';
        hasError = true;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
        hasError = true;
      });
    } else if (passwordController.text.length < 8) {
      setState(() {
        passwordError = 'Password must be at least 8 characters';
        hasError = true;
      });
    }

    if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
        hasError = true;
      });
    }

    if (hasError) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final payload = CreateUserRequest(
          fullName: nameController.text,
          email: emailController.text,
          username: usernameController.text,
          password: passwordController.text,
          passwordConfirm: confirmPasswordController.text,
          role: selectedRole);
      await _authService.register(payload);

      widget.notifyAuthChanged(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: SvgPicture.asset('assets/wheelsup_text_logo.svg')),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SignUpHeaderText(),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    errorText: nameError,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    errorText: emailError,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: usernameController,
                    hintText: "Username",
                    errorText: usernameError,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    errorText: passwordError,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    errorText: confirmPasswordError,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'penyewa', child: Text('Penyewa')),
                      DropdownMenuItem(
                          value: 'pemilik', child: Text('Pemilik')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 48),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
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
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ])
                ],
              ),
            )
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
