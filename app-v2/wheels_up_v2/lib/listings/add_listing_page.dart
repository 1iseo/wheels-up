import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/listings/listings_provider.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';

class AddListingPage extends HookConsumerWidget {
  const AddListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final requirements = useState<List<String>>([]);
    final thumbnailImage = useState<XFile?>(null);
    final isLoading = useState<bool>(false);
    final picker = ImagePicker();

    final listingsService = ref.read(listingServiceProvider);
    final authService = ref.read(authServiceProvider);

    Future<void> pickImage() async {
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          thumbnailImage.value = image;
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }

    void addRequirement(String requirement) {
      if (requirement.isNotEmpty) {
        requirements.value = [...requirements.value, requirement];
        formKey.currentState!.fields['requirement']!.didChange('');
      }
    }

    void removeRequirement(String requirement) {
      requirements.value =
          requirements.value.where((r) => r != requirement).toList();
    }

    Future<void> submitListing() async {
      if (formKey.currentState!.saveAndValidate()) {
        if (thumbnailImage.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add a thumbnail image')),
          );
          return;
        }

        if (requirements.value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please add at least one requirement')),
          );
          return;
        }

        isLoading.value = true;

        try {
          final bytes = await thumbnailImage.value!.readAsBytes();
          final fileName = thumbnailImage.value!.path.split('/').last;

          final createListingData = CreateListingRequest(
            title: formKey.currentState!.value['carName'],
            description: formKey.currentState!.value['description'],
            location: formKey.currentState!.value['location'],
            pricePerHour: int.parse(formKey.currentState!.value['price']),
            requirements: requirements.value,
            thumbnail: bytes,
            thumbnailFileName: fileName,
            posterId: (await authService.loadLoggedInUser())!.id,
          );

          await listingsService.createListing(createListingData);
          ref.invalidate(currentUserListingsNotifierProvider);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing created successfully')),
          );
          Navigator.pop(context, true);
        } catch (e) {
          var errString = e.toString();
          if (e is ClientException) {
            errString = e.response["message"];
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errString)),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Car Name
                FormBuilderTextField(
                  name: 'carName',
                  decoration: InputDecoration(
                    hintText: 'Nama Mobil',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),

                // Description
                FormBuilderTextField(
                  name: 'description',
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  maxLines: 3,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),

                // Price
                FormBuilderTextField(
                  name: 'price',
                  decoration: InputDecoration(
                    hintText: 'Harga (Rp)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),

                // Location
                FormBuilderTextField(
                  name: 'location',
                  decoration: InputDecoration(
                    hintText: 'Lokasi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),

                // Requirements
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'requirement',
                        decoration: InputDecoration(
                          hintText: 'Syarat-syarat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        final requirement =
                            formKey.currentState!.fields['requirement']!.value;
                        if (requirement != null && requirement.isNotEmpty) {
                          addRequirement(requirement);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: requirements.value.isEmpty ? 0 : 8),
                Wrap(
                  spacing: 8,
                  children: requirements.value
                      .map((requirement) => Chip(
                            label: Text(requirement),
                            onDeleted: () => removeRequirement(requirement),
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
                  child: thumbnailImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(File(thumbnailImage.value!.path),
                              fit: BoxFit.cover),
                        )
                      : Center(
                          child: TextButton.icon(
                            onPressed: pickImage,
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
                    onPressed: isLoading.value ? null : submitListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading.value
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
