import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      toolbarHeight: 80,
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.white,
      title: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: SvgPicture.asset('assets/wheelsup_text_logo.svg')),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
