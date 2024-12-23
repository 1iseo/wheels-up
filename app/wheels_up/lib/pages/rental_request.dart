import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/services/rental_request_service.dart';

class RentalRequestListScreen extends StatefulWidget {
  const RentalRequestListScreen({super.key});

  @override
  _RentalRequestListScreenState createState() =>
      _RentalRequestListScreenState();
}

class _RentalRequestListScreenState extends State<RentalRequestListScreen> {
  List<RentalRequestWithRelations> _rentalRequests = [];
  bool _isLoading = true;
  String? _error;
  late final AuthService _authService;
  late final RentalRequestService _rentalRequestService;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _rentalRequestService =
        Provider.of<RentalRequestService>(context, listen: false);
    _fetchRentalRequests();
  }

  Future<void> _fetchRentalRequests() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null; // Reset error state
      });

      final user = await _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not found');
      }

      final userId = user.id;
      final userRole = user.role;

      final requests = userRole == 'pemilik'
          ? await _rentalRequestService.getUserRentalRequestsReceived(userId)
          : await _rentalRequestService.getUserRentalRequestsSent(userId);

      setState(() {
        _rentalRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Helper method to calculate time ago
  String _getTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Unknown';

    final DateTime createdDate = DateTime.parse(createdAt);
    final Duration difference = DateTime.now().difference(createdDate);

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365}y ago';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rental Requests'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchRentalRequests,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Error: $_error'))
                : _rentalRequests.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Text('No rental requests found'),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _rentalRequests.length,
                        itemBuilder: (context, index) {
                          final request = _rentalRequests[index];
                          return ListTile(
                            title:
                                Text(request.listing.name ?? 'Unnamed Listing'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Requested ${_getTimeAgo(request.rentalRequest.created)}'),
                                Text(
                                    'Status: Pending'), // You might want to add a status field
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // GoRouter.of(context)
                              //     .push('/detail', extra: request);
                            },
                          );
                        },
                      ),
      ),
    );
  }
}

class RentalRequestDetailScreen extends StatelessWidget {
  final RentalRequestWithRelations rentalRequest;

  const RentalRequestDetailScreen({
    Key? key,
    required this.rentalRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = rentalRequest.rentalRequest;
    final listing = rentalRequest.listing;
    final user = rentalRequest.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Listing Information
            Card(
              child: ListTile(
                title: const Text('Listing Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${listing.name ?? 'N/A'}'),
                    Text('Location: ${listing.location ?? 'N/A'}'),
                    Text('Price per Hour: ${listing.pricePerHour ?? 'N/A'}'),
                  ],
                ),
              ),
            ),

            // Request Information
            Card(
              child: ListTile(
                title: const Text('Request Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Submitted: ${request.created ?? 'N/A'}'),
                    Text('Reason: ${request.reason ?? 'No reason provided'}'),
                    Text('Age: ${request.age ?? 'N/A'}'),
                  ],
                ),
              ),
            ),

            // Contact Information
            Card(
              child: ListTile(
                title: const Text('Contact Information'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${request.email ?? 'N/A'}'),
                    Text('Phone: ${request.noTelepon ?? 'N/A'}'),
                    Text('Address: ${request.address ?? 'N/A'}'),
                  ],
                ),
              ),
            ),

            // User Information
            Card(
              child: ListTile(
                title: const Text('Requester Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${user.fullName ?? 'N/A'}'),
                    // Add more user details as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
