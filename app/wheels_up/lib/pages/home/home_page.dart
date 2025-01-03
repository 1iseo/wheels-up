import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/utils/role_helper.dart';
import 'package:wheels_up/pages/home/home_page_pemilik.dart';
import 'package:wheels_up/pages/home/home_page_penyewa.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<RoleHelper>(context, listen: false).roleBasedBuilder(
      pemilikBuilder: () => const HomePagePemilik(),
      penyewaBuilder: () => const HomePagePenyewa(),
    );
  }
}
