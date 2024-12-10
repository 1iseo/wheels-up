import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/widgets/home_profile_display.dart';
import 'package:wheels_up/widgets/search_bar.dart' as sb;
import 'package:wheels_up/widgets/car_listing_grid.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/services/car_listing_service.dart';
import 'package:wheels_up/utils/debouncer.dart';
import 'package:wheels_up/pages/view_listing.dart'; // Import ViewListing

class HomePagePenyewa extends StatefulWidget {
  const HomePagePenyewa({super.key});

  @override
  State<HomePagePenyewa> createState() => _HomePagePenyewaState();
}

class _HomePagePenyewaState extends State<HomePagePenyewa> {
  final ScrollController _scrollController = ScrollController();
  final List<CarListing2> _listings = [];
  late CarListingService _listingService;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _listingService = Provider.of<CarListingService>(context, listen: false);
    _loadListings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _loadListings() async {
    if (_isLoading || (!_hasMore && !_isSearching)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSearching) {
        // final searchResults =
        // await _listingService.searchListings(_searchController.text);
        setState(() {
          _listings.clear();
          // _listings.addAll(searchResults);
          _isLoading = false;
          _hasMore = false; // No pagination for search results yet
        });
      } else {
        final response = await _listingService.getListings(page: _currentPage);
        final List<CarListing2> newListings = response.items;

        setState(() {
          if (_currentPage == 1) {
            _listings.clear();
          }
          _listings.addAll(newListings);
          _currentPage++;
          _hasMore = newListings.length == response.perPage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadListings();
    }
  }

  void _handleSearch(String query) {
    final isQueryEmpty = query.isEmpty;
    final wasSearching = _isSearching;
    final isSearching = !isQueryEmpty;

    // Only update state if search status changed
    if (wasSearching != isSearching) {
      setState(() {
        _isSearching = isSearching;
        if (isQueryEmpty) {
          _currentPage = 1;
          _hasMore = true;
        }
      });
    }

    if (isQueryEmpty) {
      _loadListings(); // Clear the results immediately for empty queries
    } else {
      _debouncer(
          () => _loadListings()); // Throttle the search for non-empty queries
    }
  }

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
              sb.SearchBar(
                controller: _searchController,
                onChanged: _handleSearch,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _listings.clear();
                      _currentPage = 1;
                      _hasMore = true;
                      _isSearching = false;
                      _searchController.clear();
                    });
                    await _loadListings();
                  },
                  child: CarListingGrid(
                    listings: _listings,
                    isLoading: _isLoading,
                    hasMore: _hasMore,
                    scrollController: _scrollController,
                    onCardTap: (listing) {
                      GoRouter.of(context).go('/listing', extra: listing);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
