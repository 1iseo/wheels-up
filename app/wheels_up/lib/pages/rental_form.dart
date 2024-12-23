import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/services/rental_request_service.dart';

class RentalFormPage extends StatefulWidget {
  final CarListingWithPoster data;
  const RentalFormPage({super.key, required this.data});

  @override
  State<RentalFormPage> createState() => _RentalFormPageState();
}

class _RentalFormPageState extends State<RentalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _noHpController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        scrolledUnderElevation: 0.0,
        title: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: SvgPicture.asset('assets/wheelsup_text_logo.svg'),
        ),
      ),
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Masukkan email Anda',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Nomor Telepon',
                      hint: 'Masukkan nomor telepon anda',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _ageController,
                      label: 'Usia',
                      hint: 'Masukkan usia Anda',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Alamat',
                      hint: 'Masukkan alamat / domisili anda',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _reasonController,
                      label: 'Tujuan Penyewaan',
                      hint: 'Apa yang ingin anda lakukan dengan kendaraan ini?',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      activeColor: Colors.black,
                      title: const Text(
                          'Saya sudah memenuhi syarat yang ditentukan di listing.'),
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!_termsAccepted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Anda harus memenuhi persyaratan yang ditentukan di listing.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              final currentUser =
                                  await Provider.of<AuthService>(context,
                                          listen: false)
                                      .getCurrentUser();
                              await Provider.of<RentalRequestService>(context,
                                      listen: false)
                                  .createRentalRequest(
                                CreateRentalRequestRequest(
                                  listingId: widget.data.listing.id,
                                  posterUserId: widget.data.poster.id,
                                  renterUserId: currentUser!.id,
                                  email: _emailController.text,
                                  noTelepon: _phoneController.text,
                                  address: _addressController.text,
                                  reason: _reasonController.text,
                                  age: int.parse(_ageController.text),
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Permintaan penyewaan berhasil dikirim.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              GoRouter.of(context).pop();
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
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
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
}
