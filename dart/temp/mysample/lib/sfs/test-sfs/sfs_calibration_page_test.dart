import 'package:flutter/material.dart';
import 'package:mysample/sfs/sfs_core/canik_backend.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/sfs/test-sfs/sfs_home_page_test.dart';
import 'package:mysample/widgets/background_image_sfs_calibration.dart';
import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../widgets/app_bar_sfs.dart';

class SfsCalibrationTestPage extends StatefulWidget {
  const SfsCalibrationTestPage({Key? key}) : super(key: key);
  @override
  State<SfsCalibrationTestPage> createState() => _SfsCalibrationPageState();
}

class _SfsCalibrationPageState extends State<SfsCalibrationTestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBarForSfs(),
            body: Column(
              children: [
                const BackgroundImageForSfsCalibration2(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(AppLocalizations.of(context)!.calibration_questioning,
                      style: _SfsCalibrationTextStyles.built32),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Opacity(
                      opacity: 0.6,
                      child: Text(
                          AppLocalizations.of(context)!.calibration_ins,
                          style: _SfsCalibrationTextStyles.akhand16)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                      onPressed: () {
                 Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SfsHomeTestPage();}));
                 
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize:const Size(315, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          primary: ProjectColors().blue),
                      child: Text(
                        AppLocalizations.of(context)!.start,
                        style: _SfsCalibrationTextStyles.built17,
                      )),
                ),
              ],
            )),
              Positioned(
          top: 40.h,
          left: 45.w,
          child: SizedBox(
            width: 13.w,
            height: 6.h,
            child: Container(
          
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(decoration: TextDecoration.underline,color: Colors.white),)
            ),
          ),
        ),
      ],
    );
  }
}

class _SfsCalibrationTextStyles {
  static const TextStyle built32 = TextStyle(
      fontSize: 32,
      fontFamily: 'Built',
      fontWeight: FontWeight.w500,
      color: Colors.white);
  static const TextStyle akhand16 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white);
  static const TextStyle built17 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white);
}
