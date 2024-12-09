import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wheels_up/pages/login_page.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Draw the rectangle from the top to the middle
    path.lineTo(0,
        size.height * 0.65); // Go from top-left to slightly above bottom-left
    path.lineTo(size.width / 2, size.height); // Go to the bottom center
    path.lineTo(
        size.width, size.height * 0.65); // Go to slightly above bottom-right
    path.lineTo(size.width, 0); // Go to top-right
    path.close(); // Complete the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 500),
      child: Transform.translate(
        offset: const Offset(0, 0),
        child: ClipPath(
          clipper: TriangleClipper(),
          child: Image.asset(
            'assets/jeep.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class LandingWelcome extends StatelessWidget {
  const LandingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // space between
        children: [
          const HeroImage(),
          const SizedBox(height: 12),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Center(
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 24),
                child: Column(
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 30, maxWidth: 250),
                      child: SvgPicture.asset(
                        'assets/wheelsup_text_logo.svg',
                      ),
                    ),
                    const Text(
                      'Offroad Anytime, Anywhere. \nBooking Mudah, Petualangan Tak Terbatas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 42),
                          shape: const StadiumBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black),
                      child: const Text(
                        'Let\'s Go!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'User Manual',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
