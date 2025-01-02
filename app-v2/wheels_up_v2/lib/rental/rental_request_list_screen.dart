import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/auth/auth_service.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/config/api_config.dart';
import 'package:wheels_up_v2/rental/rental_service.dart';

class RentalRequestListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider);
    final rentalRequestService = ref.watch(rentalRequestServiceProvider);

    final rentalRequests = useState<List<RentalRequestWithRelations>>([]);
    final isLoading = useState<bool>(true);
    final error = useState<String?>(null);

    Future<void> fetchRentalRequests() async {
      try {
        isLoading.value = true;
        error.value = null; // Reset error state

        final user = authNotifier.value?.user;
        if (user == null) {
          throw Exception('User not found');
        }

        final userId = user.id;
        final userRole = user.role;

        final requests = userRole == 'pemilik'
            ? await rentalRequestService.getUserRentalRequestsReceived(userId)
            : await rentalRequestService.getUserRentalRequestsSent(userId);

        rentalRequests.value = requests;
        isLoading.value = false;
      } catch (e) {
        error.value = e.toString();
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchRentalRequests();
      return null;
    }, []);

    // Helper method to calculate time ago
    String getTimeAgo(DateTime? createdAt) {
      if (createdAt == null) return 'Unknown';

      final Duration difference = DateTime.now().difference(createdAt);

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

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchRentalRequests,
        child: isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : error.value != null
                ? Center(child: Text('Error: ${error.value}'))
                : rentalRequests.value.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Text(
                                'No rental requests found',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Request Sewa - ${authNotifier.value?.user?.role == 'pemilik' ? 'Diterima' : 'Terkirim'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: rentalRequests.value.length,
                              itemBuilder: (context, index) {
                                final request = rentalRequests.value[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // GoRouter.of(context).push('/detail', extra: request);
                                      if (authNotifier.value?.user?.role ==
                                          'penyewa') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RentalRequestDetailPenyewa(
                                                    request: request),
                                          ),
                                        );
                                      } else if (authNotifier
                                              .value?.user?.role ==
                                          'pemilik') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RentalRequestDetailPemilik(
                                                    request: request),
                                          ),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Listing thumbnail
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    '${ApiConfig().pbApiUrl}/api/files/listings/${request.listing.id}/${request.listing.thumbnail}?thumb=800x500'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Listing details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  request.listing.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Requested ${getTimeAgo(request.rentalRequest.createdAt)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Status: ${request.rentalRequest.status?.capitalize}', // You might want to add a status field
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Chevron icon
                                          Icon(Icons.chevron_right, size: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}

class RentalRequestDetailPenyewa extends StatelessWidget {
  final RentalRequestWithRelations request;

  const RentalRequestDetailPenyewa({Key? key, required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Permintaan Sewa'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing Thumbnail
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    '${ApiConfig().pbApiUrl}/api/files/listings/${request.listing.id}/${request.listing.thumbnail}?thumb=800x500',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Listing Name
            Text(
              request.listing.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Request Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Status: ${request.rentalRequest.status?.capitalize}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange.shade800,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Section: Informasi Penyewa
            Text(
              'Informasi Penyewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildDetailItem('Nama', request.user.fullName),
            _buildDetailItem('Email', request.rentalRequest.email),
            _buildDetailItem('No. Telepon', request.rentalRequest.noTelepon),
            _buildDetailItem('Alamat', request.rentalRequest.address),
            const SizedBox(height: 16),

            // Section: Detail Sewa
            Text(
              'Detail Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildDetailItem(
                'Tanggal Mulai',
                DateFormat.yMMMMd()
                    .add_jm()
                    .format(request.rentalRequest.startDate!)),
            _buildDetailItem(
                'Tanggal Selesai',
                DateFormat.yMMMMd()
                    .add_jm()
                    .format(request.rentalRequest.endDate!)),
            _buildDetailItem(
                'Total Jam', '${request.rentalRequest.totalHours ?? '-'} jam'),
            _buildDetailItem(
                'Total Harga',
                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
                    .format(request.rentalRequest.totalPrice ?? 0)),
            const SizedBox(height: 16),

            // Section: Alasan Sewa
            Text(
              'Alasan Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              request.rentalRequest.reason ?? '-',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Section: Persyaratan Sewa
            Text(
              'Persyaratan Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: request.listing.requirements
                  .map((requirement) => Text(
                        '• $requirement',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail item
  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value ?? '-',
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RentalRequestDetailPemilik extends ConsumerWidget {
  final RentalRequestWithRelations request;

  const RentalRequestDetailPemilik({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rentalRequestService = ref.read(rentalRequestServiceProvider);

    // Handle approve request
    void handleAcceptRequest(BuildContext context, String requestId) async {
      try {
        await rentalRequestService.updateRentalRequestStatus(
            requestId, 'accepted');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permintaan disetujui!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyetujui permintaan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    // Handle reject request
    void handleRejectRequest(BuildContext context, String requestId) async {
      try {
        await rentalRequestService.updateRentalRequestStatus(
            requestId, 'rejected');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permintaan ditolak!'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyetujui permintaan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Permintaan Sewa'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listing Thumbnail
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    '${ApiConfig().pbApiUrl}/api/files/listings/${request.listing.id}/${request.listing.thumbnail}?thumb=800x500',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Listing Name
            Text(
              request.listing.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Request Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Status: Pending',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange.shade800,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Section: Informasi Penyewa
            Text(
              'Informasi Penyewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildDetailItem('Nama', request.user.fullName),
            _buildDetailItem('Email', request.rentalRequest.email),
            _buildDetailItem('No. Telepon', request.rentalRequest.noTelepon),
            _buildDetailItem('Alamat', request.rentalRequest.address),
            const SizedBox(height: 16),

            // Section: Detail Sewa
            Text(
              'Detail Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildDetailItem('Tanggal Mulai',
                request.rentalRequest.startDate?.toString() ?? '-'),
            _buildDetailItem('Tanggal Selesai',
                request.rentalRequest.endDate?.toString() ?? '-'),
            _buildDetailItem(
                'Total Jam', '${request.rentalRequest.totalHours ?? '-'} jam'),
            _buildDetailItem('Total Harga',
                'Rp ${request.rentalRequest.totalPrice?.toStringAsFixed(2) ?? '-'}'),
            const SizedBox(height: 16),

            // Section: Alasan Sewa
            Text(
              'Alasan Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              request.rentalRequest.reason ?? '-',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Section: Persyaratan Sewa
            Text(
              'Persyaratan Sewa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: request.listing.requirements
                  .map((requirement) => Text(
                        '• $requirement',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            if (request.rentalRequest.status == 'pending') ...[
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle approve action
                        handleAcceptRequest(context, request.rentalRequest.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Setujui',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle reject action
                        handleRejectRequest(context, request.rentalRequest.id!);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text(
                        'Tolak',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail item
  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value ?? '-',
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
