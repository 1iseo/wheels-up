import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

InputDecoration myInputDecoration({
  required String hintText,
  String suffixText = '*',
  Color hintColor = Colors.grey,
  Color fillColor = Colors.grey,
  Color borderColor = Colors.blue,
  double borderRadius = 15.0,
}) {
  return InputDecoration(
    hintStyle: TextStyle(color: Colors.grey.shade600),
    filled: true,
    fillColor: Colors.grey.shade200,
    hintText: hintText,
    suffix: Text(
      suffixText,
      style: const TextStyle(color: Colors.red, fontSize: 14, height: 2),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor),
    ),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Container(
  //         width: 360.0,
  //         height: 800.0,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.black),
  //         ),
  //         child: Stack(
  //           children: [
  //             Positioned(
  //               left: 20.0,
  //               top: 66.0,
  //               child: GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(context); // Navigate back when tapped
  //                 },
  //                 child: const Icon(
  //                   Icons.arrow_back,
  //                   size: 20, // Set width to 20
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //             const Positioned(
  //               left: 115.0,
  //               top: 63.0,
  //               child: Text(
  //                 "Wheels Up",
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 24.0,
  //                   fontWeight: FontWeight.w900,
  //                 ),
  //               ),
  //             ),
  //             const Positioned(
  //               left: 139.0,
  //               top: 115.0,
  //               child: Text(
  //                 "LOGIN",
  //                 style: TextStyle(
  //                   fontSize: 24,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w900,
  //                 ),
  //               ),
  //             ),
  //             const Positioned(
  //               left: 70.0,
  //               top: 162.0,
  //               child: Text(
  //                 "Siap Menikmati Perjalananmu?",
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               left: 20.0,
  //               top: 201.0,
  //               child: Container(
  //                 height: 48,
  //                 width: 320.0,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[200],
  //                   borderRadius: BorderRadius.circular(15.0),
  //                 ),
  //                 child: TextField(
  //                   controller: usernameController,
  //                   decoration: InputDecoration(
  //                     hintText: "username",
  //                     errorText: usernameError,
  //                     border: InputBorder.none,
  //                     contentPadding:
  //                         const EdgeInsets.symmetric(horizontal: 16.0),
  //                   ),
  //                   style: const TextStyle(color: Colors.black, fontSize: 18),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               left: 20.0,
  //               top: 265.0,
  //               child: Container(
  //                 height: 48,
  //                 width: 320.0,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[200],
  //                   borderRadius: BorderRadius.circular(15.0),
  //                 ),
  //                 child: TextField(
  //                   controller: passwordController,
  //                   obscureText: true,
  //                   decoration: InputDecoration(
  //                     hintText: "password",
  //                     errorText: passwordError,
  //                     border: InputBorder.none,
  //                     contentPadding:
  //                         const EdgeInsets.symmetric(horizontal: 16.0),
  //                   ),
  //                   style: const TextStyle(color: Colors.black, fontSize: 18),
  //                 ),
  //               ),
  //             ),
  //             const Positioned(
  //               left: 24.0,
  //               top: 329.0,
  //               child: Text(
  //                 "Lupa Password?",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               left: 105.0,
  //               top: 357.0,
  //               child: GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     usernameError = usernameController.text.isEmpty
  //                         ? 'Anda belum memasukkan data'
  //                         : null;
  //                     passwordError = passwordController.text.isEmpty
  //                         ? 'Anda belum memasukkan data'
  //                         : null;
  //                   });
  //                   if (usernameError == null && passwordError == null) {
  //                     // Navigator.push(
  //                     //   context,
  //                     //   MaterialPageRoute(builder: (context) => HomeFrame()),
  //                     // );
  //                   }
  //                 },
  //                 child: Container(
  //                   height: 48.0,
  //                   width: 150.0,
  //                   decoration: BoxDecoration(
  //                     color: Colors.black,
  //                     borderRadius: BorderRadius.circular(15.0),
  //                   ),
  //                   child: const Center(
  //                     child: Text(
  //                       "login",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 18.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               left: 99.0,
  //               top: 421.0,
  //               child: GestureDetector(
  //                 onTap: () {
  //                   // Navigate to the Sign Up page
  //                   // Navigator.push(
  //                   //   context,
  //                   //   MaterialPageRoute(builder: (context) => SignUP()),
  //                   // );
  //                 },
  //                 child: RichText(
  //                   text: const TextSpan(
  //                     text: "Belum punya akun? ",
  //                     style: TextStyle(
  //                       fontSize: 14.0,
  //                       color: Colors.black,
  //                     ),
  //                     children: [
  //                       TextSpan(
  //                         text: "Sign Up",
  //                         style: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Colors.blue,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
          SizedBox(height: 16,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                TextField(
                  controller: usernameController,
                  decoration: myInputDecoration(hintText: "Username"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: myInputDecoration(hintText: "Password"),
                ),
                const SizedBox(height: 8),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Lupa password?", textAlign: TextAlign.start),
                    )),
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
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                      onTap: () {},
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
