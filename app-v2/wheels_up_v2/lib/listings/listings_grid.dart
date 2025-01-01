import 'package:flutter/material.dart';
import 'package:wheels_up_v2/listings/listing_card.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';

class ListingGrid extends StatelessWidget {
  final List<ListingWithPoster> listings;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(ListingWithPoster listing) onCardTap;
  final bool hasMore;
  final bool isPemilik;

  const ListingGrid({
    super.key,
    required this.listings,
    required this.isLoading,
    required this.scrollController,
    required this.onCardTap,
    this.hasMore = true,
    this.isPemilik = false,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty && !isLoading) {
      if (isPemilik) return const Center(child: Text('Anda belum membuat listing. Silahkan buat listing terlebih dahulu.', textAlign: TextAlign.center,));
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
        return ListingCard(
          data: listings[index],
          onTap: () => onCardTap(listings[index]),
        );
      },
    );
  }
}
