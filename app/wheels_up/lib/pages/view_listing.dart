import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wheels_up/config/api_config.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/models/user.dart';
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
  final CarListingWithPoster data;

  const ViewListing({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final listing = data.listing;
    final poster = data.poster;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeProfileDisplay(),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ImageDisplay(
                        imageUrl:
                            "${ApiConfig.pocketbaseUrl}/api/files/listings/${listing.id}/${listing.thumbnail}",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    listing.location,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Harga Sewa",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(listing.pricePerHour),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const Text(
                              "per jam",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Deskripsi",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              listing.description,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Syarat",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: listing.requirements
                                  .map((requirement) =>
                                      _buildRequirementItem(requirement))
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Owner",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://via.placeholder.com/150'), // Replace with user avatar
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        poster.fullName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        poster.username,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      GoRouter.of(context).push("/rentalform", extra: data);
                    },
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black),
                    child: const Text("Sewa Sekarang"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarListingWidget extends StatefulWidget {
  final CarListing2 listing;

  const CarListingWidget({Key? key, required this.listing}) : super(key: key);

  @override
  _CarListingWidgetState createState() => _CarListingWidgetState();
}

class _CarListingWidgetState extends State<CarListingWidget> {
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WheelsUp'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with user avatar
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Baby Zoo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Image.network(
                "${ApiConfig.pocketbaseUrl}/api/files/listings/${widget.listing.id}/${widget.listing.thumbnail}"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.listing.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Rp. ${widget.listing.pricePerHour.toStringAsFixed(0)},00',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(
                        5, (index) => Icon(Icons.star, color: Colors.amber)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    isDescriptionExpanded
                        ? widget.listing.description
                        : widget.listing.description.length > 100
                            ? widget.listing.description.substring(0, 100) +
                                '...'
                            : widget.listing.description,
                  ),
                  if (widget.listing.description.length > 100)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isDescriptionExpanded = !isDescriptionExpanded;
                        });
                      },
                      child: Text(
                          isDescriptionExpanded ? 'Read Less' : 'Read More'),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Syarat Peminjaman',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.listing.requirements.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.check),
                        title: Text(widget.listing.requirements[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Lokasi: ${widget.listing.location}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Pesan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
