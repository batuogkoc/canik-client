import 'package:flutter/material.dart';

class CustomAppBarForSfs extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarForSfs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/images/canik_sfs_app_bar.png';
    const String _closeIconPath = 'assets/images/close_icon.png';
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Image.asset(_imagePath),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(_closeIconPath),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
