import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class BackgroundImageForSfs extends StatelessWidget {
  const BackgroundImageForSfs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/images/background_image_sfs.png';
    return Stack(
      children: [
        Image.asset(
          _imagePath,
          height: context.height,
          width: context.width,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
