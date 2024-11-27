import 'package:flutter/material.dart';
import 'package:wheels_up/widgets/home_profile_display.dart';
import 'package:wheels_up/widgets/search_bar.dart' as search_bar;
import 'package:wheels_up/widgets/car_listing_card.dart';

class HomePagePenyewa extends StatelessWidget {
  const HomePagePenyewa({super.key});

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
              const search_bar.SearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const CarListingCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
