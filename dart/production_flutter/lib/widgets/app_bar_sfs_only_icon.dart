import 'package:flutter/material.dart';

class CustomAppBarForSfsOnlyIcon extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarForSfsOnlyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/images/canik_sfs_app_bar.png';
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Image.asset(_imagePath),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
