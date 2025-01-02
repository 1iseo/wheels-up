import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/config/api_config.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:intl/intl.dart';
import 'package:wheels_up_v2/rental/rental_provider.dart';
import 'package:wheels_up_v2/rental/rental_service.dart'; // Untuk formatting tanggal

class RentalFormPage extends HookConsumerWidget {
  final ListingWithPoster data;
  const RentalFormPage({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final termsAccepted = useState(false);
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final price = useState<double>(0.0);

    Widget buildTextField({
      required String name,
      required String label,
      String? hint,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
    }) {
      return FormBuilderTextField(
        name: name,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      );
    }

    double calculatePrice(
        DateTime startDate, DateTime endDate, double pricePerHour) {
      final duration = endDate.difference(startDate);
      final days = duration.inHours;
      return days * pricePerHour;
    }

    Widget buildDateTimeField({
      required String name,
      required String label,
      String? hint,
    }) {
      return FormBuilderDateTimePicker(
        name: name,
        inputType: InputType.both, // Menampilkan tanggal dan waktu
        format: DateFormat('yyyy-MM-dd HH:mm'), // Format tanggal dan waktu
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) {
          if (name == 'start_date') {
            startDate.value = value;
          } else {
            endDate.value = value;
          }

          if (startDate.value != null && endDate.value != null) {
            price.value = calculatePrice(
              startDate.value!,
              endDate.value!,
              data.listing.pricePerHour,
            );
          }
        },
        validator: (value) {
          if (value == null) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      );
    }

    Widget _buildInfoTile(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Form Penyewaan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Lengkapi form berikut untuk melanjutkan pemesanan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    buildTextField(
                      name: 'email',
                      label: 'Email',
                      hint: 'Masukkan email Anda',
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      name: 'phone',
                      label: 'Nomor Telepon',
                      hint: 'Masukkan nomor telepon anda',
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      name: 'age',
                      label: 'Usia',
                      hint: 'Masukkan usia Anda',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      name: 'address',
                      label: 'Alamat',
                      hint: 'Masukkan alamat / domisili anda',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      name: 'reason',
                      label: 'Tujuan Penyewaan',
                      hint: 'Apa yang ingin anda lakukan dengan kendaraan ini?',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    buildDateTimeField(
                      name: 'start_date',
                      label: 'Waktu Mulai Penyewaan',
                      hint: 'Pilih tanggal dan waktu mulai',
                    ),
                    const SizedBox(height: 16),
                    buildDateTimeField(
                      name: 'end_date',
                      label: 'Waktu Selesai Penyewaan',
                      hint: 'Pilih tanggal dan waktu selesai',
                    ),
                    const SizedBox(height: 16),
                    if (startDate.value != null &&
                        endDate.value != null &&
                        price.value != 0.00)
                      Row(
                        children: [
                          Text(
                            'Total Harga: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(price.value)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      activeColor: Colors.black,
                      title: const Text(
                          'Saya sudah memenuhi syarat yang ditentukan di listing.'),
                      value: termsAccepted.value,
                      onChanged: (bool? value) {
                        termsAccepted.value = value ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // onPressed: () async {
                        //   if (formKey.currentState!.saveAndValidate()) {
                        //     if (!termsAccepted.value) {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //           content: Text(
                        //               'Anda harus memenuhi persyaratan yang ditentukan di listing.'),
                        //           duration: Duration(seconds: 2),
                        //         ),
                        //       );
                        //     } else {
                        //       final formData = formKey.currentState!.value;
                        //       final currentUser = ref
                        //           .read(authNotifierProvider)
                        //           .requireValue
                        //           .user!;

                        //       await ref
                        //           .read(rentalRequestServiceProvider)
                        //           .createRentalRequest(
                        //             CreateRentalRequestRequest(
                        //               listingId: data.listing.id,
                        //               posterUserId: data.poster.id,
                        //               renterUserId: currentUser.id,
                        //               email: formData['email'],
                        //               noTelepon: formData['phone'],
                        //               address: formData['address'],
                        //               reason: formData['reason'],
                        //               age: int.parse(formData['age']),
                        //               startDate: formData['start_date'],
                        //               endDate: formData['end_date'],
                        //             ),
                        //           );

                        //       if (!context.mounted) return;

                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //           content: Text(
                        //               'Permintaan penyewaan berhasil dikirim.'),
                        //           duration: Duration(seconds: 2),
                        //         ),
                        //       );

                        //       GoRouter.of(context).pop();
                        //     }
                        // }
                        // },
                        onPressed: () {
                          if (formKey.currentState!.saveAndValidate()) {
                            if (!termsAccepted.value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Anda harus memenuhi persyaratan yang ditentukan di listing.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              final formData = formKey.currentState!.value;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final totalHours = endDate.value!
                                      .difference(startDate.value!)
                                      .inHours;
                                  final totalPrice =
                                      totalHours * data.listing.pricePerHour;

                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    title: const Text(
                                      'Ringkasan Penyewaan',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: Container(
                                      width: 450,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Listing Preview Card
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: Image.network(
                                                          "${ApiConfig().pbApiUrl}/api/files/listings/${data.listing.id}/${data.listing.thumbnail}?thumb=800x500",
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context,
                                                              error, stackTrace) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[200],
                                                              child: const Icon(
                                                                  Icons.error),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data.listing.name,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Harga per jam: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(data.listing.pricePerHour)}',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                      
                                            // Personal Information Section
                                            const Text(
                                              'Data Anda',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            _buildInfoTile(Icons.email_outlined,
                                                'Email', formData['email']),
                                            _buildInfoTile(
                                                Icons.phone_outlined,
                                                'Nomor Telepon',
                                                formData['phone']),
                                            _buildInfoTile(
                                                Icons.person_outline,
                                                'Usia',
                                                '${formData['age']} tahun'),
                                            _buildInfoTile(Icons.home_outlined,
                                                'Alamat', formData['address']),
                                            _buildInfoTile(
                                                Icons.description_outlined,
                                                'Tujuan',
                                                formData['reason']),
                                      
                                            const SizedBox(height: 24),
                                      
                                            // Duration and Price Section
                                            const Text(
                                              'Durasi & Harga',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            _buildInfoTile(
                                                Icons.access_time,
                                                'Waktu Mulai',
                                                DateFormat.yMMMMd().add_jm().format(formData['start_date'])),
                                            _buildInfoTile(
                                                Icons.access_time,
                                                'Waktu Selesai',
                                                DateFormat.yMMMMd().add_jm().format(formData['end_date'])),
                                            _buildInfoTile(Icons.timelapse,
                                                'Durasi', '$totalHours jam'),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Total Harga',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    NumberFormat.currency(
                                                            locale: 'id_ID',
                                                            symbol: 'Rp ')
                                                        .format(totalPrice),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Batal',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                          final currentUser = ref
                                              .read(authNotifierProvider)
                                              .requireValue
                                              .user!;

                                          await ref
                                              .read(
                                                  rentalRequestServiceProvider)
                                              .createRentalRequest(
                                                CreateRentalRequestRequest(
                                                  listingId: data.listing.id,
                                                  posterUserId: data.poster.id,
                                                  renterUserId: currentUser.id,
                                                  email: formData['email'],
                                                  noTelepon: formData['phone'],
                                                  address: formData['address'],
                                                  reason: formData['reason'],
                                                  age: int.parse(
                                                      formData['age']),
                                                  startDate:
                                                      formData['start_date'],
                                                  endDate: formData['end_date'],
                                                  totalHours: totalHours,
                                                  totalPrice: totalPrice,
                                                ),
                                              );

                                          ref.invalidate(
                                              sentRentalNotifierProvider);

                                          if (!context.mounted) return;

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Permintaan penyewaan berhasil dikirim.',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                          GoRouter.of(context)
                                              .pop(); // Navigate back
                                          } catch (e) {
                                            var errMsg = e.toString();
                                            if (e is ClientException) {
                                              errMsg = e.response['message'];
                                            }
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Terjadi kesalahan: $errMsg',
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Kirim',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Kirim',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
