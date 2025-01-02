import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/home/pemilik/home_page_pemilik.dart';
import 'package:wheels_up_v2/home/penyewa/home_page_penyewa.dart';


class HomePage extends ConsumerWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authNotifierProvider).requireValue;
    final user = authState.user!;

    if (user.role == "pemilik") {
      return const HomePagePemilik();
    } 
    else if (user.role == "penyewa") {
      return const HomePagePenyewa();
    } else {
      return const Text("Fatal: Role not found");
    }
  }
}