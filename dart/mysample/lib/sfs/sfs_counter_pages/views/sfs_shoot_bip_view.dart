import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/widgets/app_bar_sfs_only_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../../sfs_core/canik_backend.dart';
import '../../sfs_holster_draw_page/view/sfs_holster_draw_page_view.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';
import '../../sfs_rapid_fire/view/sfs_rapid_fire_page_view.dart';

class SfsShootBipView extends StatelessWidget {
  final CanikDevice canikDevice;
  final SfsTrainingMode trainingMode;
  final SfsAllSettings allSettings;
  const SfsShootBipView(
      {required this.allSettings,
      required this.canikDevice,
      required this.trainingMode,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors().blue,
      appBar: const CustomAppBarForSfsOnlyIcon(),
      body: Center(
        child: Column(
          children: [
            const Text(
              'SHOOT',
              style: TextStyle(
                  fontSize: 117,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xff686F76),
                    shape: RoundedRectangleBorder(
                        borderRadius: context.normalBorderRadius,
                        side: const BorderSide(color: Colors.white))),
                onPressed: () {
                  trainingMode == "Fast Draw"
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return SfsHolsterDrawPageView(
                              allSettings: allSettings,
                              canikDevice: canikDevice);
                        }))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return SfsRapidFirePageView(
                              allSettings: allSettings,
                              canikDevice: canikDevice);
                        }));
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h),
                  child: Text(AppLocalizations.of(context)!.cancel,
                      textAlign: TextAlign.center),
                )),
          ],
        ),
      ),
    );
  }
}
