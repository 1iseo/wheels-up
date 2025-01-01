import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/user/user_service.dart';

class HomeProfileDisplay extends HookConsumerWidget {
  const HomeProfileDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final error = authState.error?.toString();
    final user = authState.value?.user;

    return Row(
      children: [
        if (user == null) ...[
          const Center(child: CircularProgressIndicator())
        ] else
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.picture.isNotEmpty
                    ? NetworkImage(
                        UserService.getUserProfilePictureUrl(user, null)
                            .toString())
                    : null,
                child: user.picture.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Halo!"),
                  if (isLoading)
                    const SizedBox(
                      width: 80,
                      child: LinearProgressIndicator(),
                    )
                  else if (error != null)
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    Text(
                      user.fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                ],
              ),
            ],
          ),
        const Spacer(),
      ],
    );
  }
}
