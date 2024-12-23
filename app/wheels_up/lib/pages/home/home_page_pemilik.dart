import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/pages/add_listing.dart';
import 'package:wheels_up/pages/edit_listing.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/widgets/home_profile_display.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/services/car_listing_service.dart';
import 'package:wheels_up/widgets/car_listing_grid.dart';

class HomePagePemilik extends StatefulWidget {
  const HomePagePemilik({super.key});

  @override
  State<HomePagePemilik> createState() => _HomePagePemilikState();
}

class _HomePagePemilikState extends State<HomePagePemilik> {
  late final CarListingService _listingService;
  late final AuthService _authService;
  final ScrollController _scrollController = ScrollController();
  final List<CarListingWithPoster> _listings = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _listingService = Provider.of<CarListingService>(context, listen: false);
    _authService = Provider.of<AuthService>(context, listen: false);
    _loadListings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadListings() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = await _authService.getCurrentUser();
      final response = await _listingService
          .getListingsWithPosterFromPoster(currentUser!.id, page: _currentPage);
      print(response);
      final List<CarListingWithPoster> newListings = response.items;

      setState(() {
        _listings.addAll(newListings);
        _currentPage++;
        _hasMore = newListings.length == response.perPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadListings();
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _listings.clear();
                      _currentPage = 1;
                      _hasMore = true;
                    });
                    await _loadListings();
                  },
                  child: _listings.isEmpty && !_isLoading
                      ? Center(
                          child: Text(
                            "Anda belum memiliki listing. Ketik tombol + untuk membuat listing.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        )
                      : CarListingGrid(
                          listings: _listings,
                          isLoading: _isLoading,
                          hasMore: _hasMore,
                          scrollController: _scrollController,
                          onCardTap: (listing) async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditListingPage(listing: listing.listing),
                              ),
                            );
                            if (result == true && mounted) {
                              setState(() {
                                _listings.clear();
                                _currentPage = 1;
                                _hasMore = true;
                              });
                              _loadListings();
                            }
                          },
                        ),
                ),
              ),
            ],
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
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddListingPage()),
          );
          if (result == true && mounted) {
            setState(() {
              _listings.clear();
              _currentPage = 1;
              _hasMore = true;
            });
            _loadListings();
          }
        },
      ),
    );
  }
}
