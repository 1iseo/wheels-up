import 'package:flutter/material.dart';
import 'package:wheels_up/utils/role_helper.dart';
import 'package:wheels_up/pages/home/home_page_pemilik.dart';
import 'package:wheels_up/pages/home/home_page_penyewa.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleHelper.roleBasedBuilder(
      pemilikBuilder: () => HomePagePemilik(),
      penyewaBuilder: () => HomePagePenyewa(),
    );
  }
}
