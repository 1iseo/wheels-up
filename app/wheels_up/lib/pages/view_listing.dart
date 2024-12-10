import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wheels_up/config/api_config.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/widgets/home_profile_display.dart';

class ImageDisplay extends StatelessWidget {
  final String imageUrl;

  const ImageDisplay({super.key, required this.imageUrl});

  Image base64ImageStringToImage() {
    return Image.memory(base64Decode(imageUrl), fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      // Create a border for the image
      return Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
    return const Placeholder();
  }
}

class ViewListing extends StatelessWidget {
  final CarListing2 listing;

  const ViewListing({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40,
        scrolledUnderElevation: 0.0,
        title: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: SvgPicture.asset('assets/wheelsup_text_logo.svg'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const HomeProfileDisplay(),
              const SizedBox(height: 24),
              Flexible(
                  child: ListView(children: [
                ImageDisplay(
                  imageUrl:
                      "${ApiConfig.pocketbaseUrl}/api/files/listings/${listing.id}/${listing.thumbnail}",
                )
              ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Harga",
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 14),
                        ),
                        Text(
                          "Rp ${listing.pricePerHour.toStringAsFixed(0)}",
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 1.2,
                              height: 1.1,
                              color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Pesan"),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 20)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
