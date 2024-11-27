import 'package:flutter/material.dart';
import 'package:wheels_up/pages/home_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheels_up/components/custom_text_field.dart';
import 'package:wheels_up/pages/main_shell.dart';
import 'package:wheels_up/pages/signup_page.dart';
import 'package:wheels_up/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  String? usernameError;
  String? passwordError;

  Future<void> _handleLogin() async {
    setState(() {
      usernameError = null;
      passwordError = null;
      _isLoading = true;
    });

    if (usernameController.text.isEmpty) {
      setState(() {
        usernameError = 'Please enter username or email';
        _isLoading = false;
      });
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Please enter password';
        _isLoading = false;
      });
      return;
    }

    try {
      final token = await _authService.login(
        usernameController.text,
        passwordController.text,
      );

      if (token != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainAppShell()),
          );
        }
      }
    } catch (e) {
      setState(() {
        passwordError = e.toString();
      });
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
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                CustomTextField(
                  controller: usernameController,
                  hintText: "Username or Email",
                  errorText: usernameError,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  errorText: passwordError,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 8),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Lupa password?", textAlign: TextAlign.start),
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
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
                            'Login',
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
                  const Text("Belum punya akun? "),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                      },
                      child: const Text(
                        "Sign Up",
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
