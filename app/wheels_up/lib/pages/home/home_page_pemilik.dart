import 'package:flutter/material.dart';
import 'package:wheels_up/widgets/home_profile_display.dart';

class HomePagePemilik extends StatelessWidget {
  const HomePagePemilik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const HomeProfileDisplay(),
              const SizedBox(height: 24),
              // Add pemilik (owner) specific content here
            ],
          ),
        ),
      ),
    );
  }
}
