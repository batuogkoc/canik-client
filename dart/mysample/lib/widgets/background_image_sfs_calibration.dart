import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class BackgroundImageForSfsCalibration1 extends StatelessWidget {
  const BackgroundImageForSfsCalibration1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/images/sfs/sfs-calibration-panel.png';
    const String _imagePathGun = 'assets/images/sfs/sfs-calibration-gun.png';
    return Stack(
      children: [
        Image.asset(
          _imagePath,
          width: context.width,    
        ),
              Image.asset(
          _imagePathGun,
    
          width: context.width,
        
        ),
      ],
    );
  }
}

class BackgroundImageForSfsCalibration2 extends StatelessWidget {
  const BackgroundImageForSfsCalibration2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = 'assets/images/sfs/sfs-calibration-panel.png';
    const String _imagePathGun = 'assets/images/sfs/sfs-calibration-gun.png';
    return Stack(
      children: [
              Image.asset(
                _imagePath,
              ),
              Center(
                child: Image.asset(_imagePathGun, ),
              ),
      ],
    );
  }
}