import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/listings/listings_provider.dart';
import 'package:wheels_up_v2/listings/listings_grid.dart';
import 'package:wheels_up_v2/home/home_profile_display.dart';

class HomePagePenyewa extends HookConsumerWidget {
  const HomePagePenyewa({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final listingsAsync = ref.watch(listingsNotifierProvider);
    final searchController = useTextEditingController();
    final priceRangeStart = useState(0.0);
    final priceRangeEnd = useState(10000000.0);
    final searchQuery = useState('');

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(listingsNotifierProvider.notifier).loadMore(
                minPrice: priceRangeStart.value,
                maxPrice: priceRangeEnd.value,
                query: searchQuery.value,
              );
        }
      });
      return null;
    }, []);

    void showFilterBottomSheet() {
      final minPriceController = TextEditingController(
        text: priceRangeStart.value.toStringAsFixed(0),
      );
      final maxPriceController = TextEditingController(
        text: priceRangeEnd.value.toStringAsFixed(0),
      );

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Listings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text('Harga Per Jam',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Min Price',
                              prefixText: 'Rp ',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final parsedValue = double.tryParse(value) ?? 0.0;
                              setState(() {
                                priceRangeStart.value = parsedValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: maxPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Max Price',
                              prefixText: 'Rp ',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final parsedValue =
                                  double.tryParse(value) ?? 10000.0;
                              setState(() {
                                priceRangeEnd.value = parsedValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(
                          priceRangeStart.value, priceRangeEnd.value),
                      min: 0,
                      max: 10000000,
                      divisions: 1000,
                      labels: RangeLabels(
                        'Rp ${priceRangeStart.value.toStringAsFixed(0)}',
                        'Rp ${priceRangeEnd.value.toStringAsFixed(0)}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          priceRangeStart.value = values.start;
                          priceRangeEnd.value = values.end;
                          minPriceController.text =
                              values.start.toStringAsFixed(0);
                          maxPriceController.text =
                              values.end.toStringAsFixed(0);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              priceRangeStart.value = 0.0;
                              priceRangeEnd.value = 10000000.0;
                              minPriceController.text = '0';
                              maxPriceController.text = '10000000';
                            });
                            ref
                                .read(listingsNotifierProvider.notifier)
                                .resetFilters();
                          },
                          child: const Text('Clear Filters',
                              style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(listingsNotifierProvider.notifier)
                                .applyFilters(
                                  minPrice: priceRangeStart.value,
                                  maxPrice: priceRangeEnd.value,
                                  query: searchQuery.value,
                                );
                            GoRouter.of(context).pop();
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(listingsNotifierProvider.notifier).refreshListings(
                  minPrice: priceRangeStart.value,
                  maxPrice: priceRangeEnd.value,
                  query: searchQuery.value,
                ),
        child: SafeArea(
          child: listingsAsync.when(
            data: (listingsState) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const HomeProfileDisplay(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search listings...',
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (query) {
                            searchQuery.value = query;
                            ref
                                .read(listingsNotifierProvider.notifier)
                                .applyFilters(
                                  minPrice: priceRangeStart.value,
                                  maxPrice: priceRangeEnd.value,
                                  query: query,
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: showFilterBottomSheet,
                        tooltip: 'Filter Listings',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListingGrid(
                      listings: listingsState.listings?.items ?? [],
                      isLoading: listingsAsync.isLoading,
                      scrollController: scrollController,
                      onCardTap: (listing) => GoRouter.of(context).push(
                        './listing',
                        extra: listing,
                      ),
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
      ),
    );
  }
}
