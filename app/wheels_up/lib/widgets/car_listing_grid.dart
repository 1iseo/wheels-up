import 'package:flutter/material.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/widgets/car_listing_card.dart';
import 'package:wheels_up/pages/view_listing.dart';

class CarListingGrid extends StatelessWidget {
  final List<CarListing> listings;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(CarListing listing) onCardTap;
  final bool hasMore;

  const CarListingGrid({
    super.key,
    required this.listings,
    required this.isLoading,
    required this.scrollController,
    required this.onCardTap,
    this.hasMore = true,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty && !isLoading) {
      return const Center(
        child: Text('No listings found'),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: listings.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == listings.length) {
          return isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox();
        }
        return CarListingCard(
          listing: listings[index],
          onTap: () => onCardTap(listings[index]),
        );
      },
    );
  }
}
