import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';
import 'package:wheels_up/pages/main_shell.dart';
import 'package:wheels_up/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

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

  final _authService = AuthService();
  bool _isLoading = false;

  String? nameError;
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  String selectedRole = 'Penyewa'; // Default value

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
      final token = await _authService.register(
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
        username: usernameController.text,
        role: selectedRole,
      );

      if (token != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainAppShell()),
        );
      }
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
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: SvgPicture.asset('assets/wheelsup_text_logo.svg')),
      ),
      body: Column(
        children: [
          const Center(
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
          ),
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
                    DropdownMenuItem(value: 'Penyewa', child: Text('Penyewa')),
                    DropdownMenuItem(value: 'Pemilik', child: Text('Pemilik')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
    );
  }
}
