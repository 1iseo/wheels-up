import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_application_3/components/input_decoration.dart';

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

  String? usernameError;
  String? passwordError;

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
                TextField(
                  controller: nameController,
                  decoration: outlinedInputDecoration(hintText: "Nama"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: outlinedInputDecoration(hintText: "Email"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  decoration: outlinedInputDecoration(hintText: "Username"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: outlinedInputDecoration(hintText: "Password"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 20),
                      textStyle: const TextStyle(fontSize: 18),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black),
                  child: const Text('Sign Up'),
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
