import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/home/home_profile_display.dart';
import 'package:wheels_up_v2/listings/add_listing_page.dart';
import 'package:wheels_up_v2/listings/edit_listing_page.dart';
import 'package:wheels_up_v2/listings/listings_grid.dart';
import 'package:wheels_up_v2/listings/listings_provider.dart';

class HomePagePemilik extends HookConsumerWidget {
  const HomePagePemilik({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final currentUserListingsAsync =
        ref.watch(currentUserListingsNotifierProvider);
    

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(currentUserListingsNotifierProvider.notifier).loadMore();
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: currentUserListingsAsync.when(
          data: (listingsState) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const HomeProfileDisplay(),
                const SizedBox(height: 24),
                Expanded(
                  child: ListingGrid(
                    listings: listingsState.listings?.items ?? [],
                    isLoading: currentUserListingsAsync.isLoading,
                    scrollController: scrollController,
                    isPemilik: true,
                    onCardTap: (listing) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditListingPage(listing: listing.listing),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading listings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(listingsNotifierProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddListingPage(),
            ),
          );
        },
      ),
    );
  }
}
