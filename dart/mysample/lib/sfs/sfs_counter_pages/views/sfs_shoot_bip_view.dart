import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/widgets/app_bar_sfs_only_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

// import '../../sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_lib/canik_lib.dart';
import '../../sfs_holster_draw_page/view/sfs_holster_draw_page_view.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';
import '../../sfs_rapid_fire/view/sfs_rapid_fire_page_view.dart';

class SfsShootBipView extends StatefulWidget {
  static const Duration waitDuration = Duration(seconds: 1);
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
  State<SfsShootBipView> createState() => _SfsShootBipViewState();
}

class _SfsShootBipViewState extends State<SfsShootBipView> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(SfsShootBipView.waitDuration, () {
      widget.trainingMode == SfsTrainingMode.fastDraw
          ? Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SfsHolsterDrawPageView(
                  allSettings: widget.allSettings,
                  canikDevice: widget.canikDevice);
            }))
          : Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SfsRapidFirePageView(
                  allSettings: widget.allSettings,
                  canikDevice: widget.canikDevice);
            }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors().blue,
      appBar: const CustomAppBarForSfsOnlyIcon(),
      body: Center(
        child: Column(
          children: const [
            Text(
              'SHOOT',
              style: TextStyle(
                  fontSize: 117,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
