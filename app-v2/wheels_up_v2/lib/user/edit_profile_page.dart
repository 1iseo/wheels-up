import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/common/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wheels_up_v2/user/user_provider.dart';
import 'package:wheels_up_v2/user/user_service.dart'; // Import the package

class EditProfilePage extends HookConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  EditProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.requireValue.user!;
    final isLoading = authState.isLoading;
    final pickedImage = useState<XFile?>(null);
    final profilePictureUrl = useState<String?>(null);

    Future<void> onSave(Map<String, dynamic> formData) async {
      UpdateUser updateUser = UpdateUser(
        username: formData['username'],
        fullName: formData['fullName'],
        picture: pickedImage.value,
      );
      await ref.read(updateUserProfileProvider(updateUser).future);
    }

    Future<void> editProfilePicture(BuildContext context) async {
      final ImagePicker picker = ImagePicker();

      final String? source = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Profile Picture'),
            content: Text('Choose an option to update your profile picture.'),
            actions: [
              TextButton(
                onPressed: () => GoRouter.of(context).pop('gallery'),
                child: Text('Gallery'),
              ),
              TextButton(
                onPressed: () => GoRouter.of(context).pop('camera'),
                child: Text('Camera'),
              ),
            ],
          );
        },
      );

      if (source == null) return;

      final XFile? image = await (source == 'gallery'
          ? picker.pickImage(source: ImageSource.gallery)
          : picker.pickImage(source: ImageSource.camera));

      if (image != null) {
        pickedImage.value = image;
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture telah anda ganti. Klik simpan untuk menyimpan perubahan.')),
        );
      }
    }

    void loadProfilePicture() {
      if (user.picture.isNotEmpty) {
        profilePictureUrl.value =
            UserService.getUserProfilePictureUrl(user, null).toString();
      }
    }

    useEffect(() {
      loadProfilePicture();
      return null;
    }, [user.picture]);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(children: [
          FormBuilder(
            key: _formKey,
            initialValue: {
              'fullName': user.fullName,
              'email': user.email,
              'username': user.username,
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                const Text(
                  'Edit Profilmu',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => editProfilePicture(context),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: pickedImage.value != null
                              ? FileImage(File(pickedImage.value!.path))
                              : profilePictureUrl.value != null
                                  ? NetworkImage(profilePictureUrl.value!)
                                      as ImageProvider
                                  : null,
                          child: pickedImage.value == null &&
                                  (profilePictureUrl.value == null ||
                                      profilePictureUrl.value!.isEmpty)
                              ? Icon(Icons.person, size: 60)
                              : null,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FormBuilderTextField(
                  enabled: false,
                  name: 'email',
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'username',
                  decoration: const InputDecoration(
                      hintText: "Username",
                      label: Text("Username"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'fullName',
                  decoration: const InputDecoration(
                      hintText: 'Nama',
                      label: Text("Nama"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      )),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final formState = _formKey.currentState;
                    if (formState == null || !formState.saveAndValidate()) {
                      return;
                    }

                    final formData = formState.value;

                    await onSave(formData);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
