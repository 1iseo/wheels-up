import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';
import 'package:wheels_up/services/car_listing_service.dart';

class CarListingPayload {
  final String name;
  final String description;
  final double price;
  final String thumbnail;
  final List<String> features;
  final List<String> requirements;
  final String location;

  CarListingPayload({
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.features,
    required this.requirements,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'thumbnail': thumbnail,
    'features': features,
    'requirements': requirements,
    'location': location,
  };
}

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _featureController = TextEditingController();
  final _requirementController = TextEditingController();
  final _listingService = CarListingService();

  final List<String> _features = [];
  final List<String> _requirements = [];
  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _thumbnailImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _addRequirement() {
    if (_requirementController.text.isNotEmpty) {
      setState(() {
        _requirements.add(_requirementController.text);
        _requirementController.clear();
      });
    }
  }

  void _removeFeature(String feature) {
    setState(() {
      _features.remove(feature);
    });
  }

  void _removeRequirement(String requirement) {
    setState(() {
      _requirements.remove(requirement);
    });
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    if (_thumbnailImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a thumbnail image')),
      );
      return;
    }

    if (_features.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one feature')),
      );
      return;
    }

    if (_requirements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one requirement')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await _thumbnailImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final listingData = {
        'name': _carNameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text.replaceAll(RegExp(r'[^0-9]'), '')),
        'thumbnail': base64Image,
        'features': _features,
        'requirements': _requirements,
        'location': _locationController.text,
      };

      await _listingService.createListing(listingData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing created successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _featureController.dispose();
    _requirementController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.grey.shade800,
        title: const Text(
          "Tambah Listing Baru",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Car Name
                CustomTextField(
                  controller: _carNameController,
                  hintText: 'Nama Mobil',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Description
                CustomTextField(
                  controller: _descriptionController,
                  hintText: 'Deskripsi',
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),

                // Price
                CustomTextField(
                  controller: _priceController,
                  hintText: 'Harga (Rp)',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                // Location
                CustomTextField(
                  controller: _locationController,
                  hintText: 'Lokasi',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Features
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _featureController,
                        hintText: 'Fitur-fitur',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: _addFeature,
                    ),
                  ],
                ),
                SizedBox(height: _features.isEmpty ? 0 : 8),
                Wrap(
                  spacing: 8,
                  children: _features
                      .map((feature) => Chip(
                            label: Text(feature),
                            onDeleted: () => _removeFeature(feature),
                            deleteIconColor: Colors.black,
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Requirements
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _requirementController,
                        hintText: 'Syarat-syarat',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: _addRequirement,
                    ),
                  ],
                ),
                SizedBox(height: _requirements.isEmpty ? 0 : 8),
                Wrap(
                  spacing: 8,
                  children: _requirements
                      .map((requirement) => Chip(
                            label: Text(requirement),
                            onDeleted: () => _removeRequirement(requirement),
                            deleteIconColor: Colors.black,
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Thumbnail
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _thumbnailImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:
                              Image.file(_thumbnailImage!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.add_photo_alternate,
                                color: Colors.black),
                            label: const Text('Add Thumbnail',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
