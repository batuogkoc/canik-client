import 'package:flutter/material.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/widgets/app_bar_sfs_only_icon.dart';

class SfsShootBipView extends StatelessWidget {
  const SfsShootBipView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors().blue,
      appBar: const CustomAppBarForSfsOnlyIcon(),
      body: const Center(
        child: Text(
          'SHOOT',
          style: TextStyle(fontSize: 117, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
