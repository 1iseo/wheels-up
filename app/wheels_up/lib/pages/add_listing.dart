import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_up/widgets/custom_text_field.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _featureController = TextEditingController();
  final _requirementController = TextEditingController();

  List<String> _features = [];
  List<String> _requirements = [];
  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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

  @override
  void dispose() {
    _carNameController.dispose();
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
                        hintText: 'Requirements',
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement form submission
                        print('Form is valid');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
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
