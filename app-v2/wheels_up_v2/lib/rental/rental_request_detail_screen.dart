import 'package:flutter/material.dart';
import 'package:wheels_up_v2/rental/rental_service.dart';

class RentalRequestDetailScreen extends StatelessWidget {
  final RentalRequestWithRelations rentalRequest;

  const RentalRequestDetailScreen({
    super.key,
    required this.rentalRequest,
  });

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
                    Text('Submitted: ${request.createdAt ?? 'N/A'}'),
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