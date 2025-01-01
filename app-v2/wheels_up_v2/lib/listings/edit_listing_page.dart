import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_up_v2/common/service_providers.dart';
import 'package:wheels_up_v2/listings/listings_provider.dart';
import 'dart:io';

import 'package:wheels_up_v2/listings/listings_service.dart';

class EditListingPage extends HookConsumerWidget {
  final Listing listing;

  const EditListingPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final requirements = useState<List<String>>(listing.requirements);
    final thumbnailImage = useState<File?>(null);
    final isLoading = useState<bool>(false);
    final picker = ImagePicker();

    final listingService = ref.read(listingServiceProvider);

    Future<void> pickImage() async {
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null) {
          thumbnailImage.value = File(image.path);
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
      requirements.value = requirements.value.where((r) => r != requirement).toList();
    }

    Future<void> handleUpdate() async {
      if (formKey.currentState!.saveAndValidate()) {
        isLoading.value = true;

        try {
          final priceText = formKey.currentState!.value['price'];
          if (priceText.isEmpty) {
            throw 'Price cannot be empty';
          }

          List<int>? thumbnailBytes;
          String? thumbnailFileName;
          if (thumbnailImage.value != null) {
            thumbnailBytes = await thumbnailImage.value!.readAsBytes();
            thumbnailFileName = thumbnailImage.value!.path.split('/').last;
          }

          final request = UpdateListingRequest(
            title: formKey.currentState!.value['carName'],
            description: formKey.currentState!.value['description'],
            pricePerHour: int.parse(priceText),
            location: formKey.currentState!.value['location'],
            requirements: requirements.value,
            thumbnail: thumbnailBytes,
            thumbnailFileName: thumbnailFileName,
          );

          await listingService.updateListing(listing.id, request);
          ref.invalidate(currentUserListingsNotifierProvider);
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        } finally {
          if (context.mounted) {
            isLoading.value = false;
          }
        }
      }
    }

    Future<void> handleDelete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Listing'),
          content: const Text(
              'Are you sure you want to delete this listing? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        isLoading.value = true;
        try {
          await listingService.deleteListing(listing.id);
          ref.invalidate(currentUserListingsNotifierProvider);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Listing deleted successfully'),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to delete listing. Please try again.'),
              ),
            );
          }
        } finally {
          if (context.mounted) {
            isLoading.value = false;
          }
        }
      }
    }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: formKey,
            initialValue: {
              'carName': listing.name,
              'description': listing.description,
              'price': listing.pricePerHour.toStringAsFixed(0),
              'location': listing.location,
            },
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

                // Thumbnail
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: thumbnailImage.value != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(thumbnailImage.value!,
                                  fit: BoxFit.cover, width: double.infinity),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: pickImage,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: TextButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.add_photo_alternate,
                                color: Colors.black),
                            label: const Text('Change Thumbnail',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
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
                        final requirement = formKey.currentState!.fields['requirement']!.value;
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
                const SizedBox(height: 24),

                // Update Button
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isLoading.value ? null : handleUpdate,
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
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Delete Button
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isLoading.value ? null : handleDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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