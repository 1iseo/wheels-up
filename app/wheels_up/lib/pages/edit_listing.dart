import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/services/car_listing_service.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';

class EditListingPage extends StatefulWidget {
  final CarListing listing;

  const EditListingPage({Key? key, required this.listing}) : super(key: key);

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _featureController = TextEditingController();
  final _requirementController = TextEditingController();
  final _listingService = CarListingService();

  List<String> _features = [];
  List<String> _requirements = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _carNameController.text = widget.listing.name;
    _descriptionController.text = widget.listing.description;
    _priceController.text = widget.listing.price.toStringAsFixed(0);
    _locationController.text = widget.listing.location;
    _features = List<String>.from(widget.listing.features);
    _requirements = List<String>.from(widget.listing.requirements);
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _removeFeature(String feature) {
    setState(() {
      _features.remove(feature);
    });
  }

  void _addRequirement() {
    if (_requirementController.text.isNotEmpty) {
      setState(() {
        _requirements.add(_requirementController.text);
        _requirementController.clear();
      });
    }
  }

  void _removeRequirement(String requirement) {
    setState(() {
      _requirements.remove(requirement);
    });
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Remove any non-digit characters from the price
        final priceText = _priceController.text;
        if (priceText.isEmpty) {
          throw 'Price cannot be empty';
        }

        final updatedListing = {
          'carName': _carNameController.text,
          'description': _descriptionController.text,
          'price': int.parse(priceText),
          'location': _locationController.text,
          'features': _features,
          'requirements': _requirements,
        };

        await _listingService.updateListing(widget.listing.id, updatedListing);
        
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _carNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _featureController.dispose();
    _requirementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.grey.shade800,
        title: const Text(
          "Edit Listing",
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
                const SizedBox(height: 24),

                // Update Button
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpdate,
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Update',
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
