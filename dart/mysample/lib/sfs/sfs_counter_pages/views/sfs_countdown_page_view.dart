import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/sfs/sfs_counter_pages/views/sfs_shoot_bip_view.dart';
import 'package:mysample/sfs/sfs_holster_draw_page/view/sfs_holster_draw_page_view.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/app_bar_sfs_only_icon.dart';
// import 'package:mysample/sfs/sfs_core/canik_lib.dart';
import "package:canik_flutter/canik_backend.dart";
import 'package:canik_lib/canik_lib.dart';

class SfsCountDownPage extends StatefulWidget {
  const SfsCountDownPage({Key? key}) : super(key: key);

  @override
  State<SfsCountDownPage> createState() => _SfsCountDownPageState();
}

class _SfsCountDownPageState extends State<SfsCountDownPage> {
  Timer? countdownTimer;
  Duration duration = const Duration(seconds: 5);

  void setCountDown() {
    const reduceSecondsBy = 1;

    setState(() {
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SfsShootBipView()));
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));
    final microSeconds = strDigits(duration.inMicroseconds.remainder(60));

    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBarForSfsOnlyIcon(),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.stand_by,
                        style: _SfsCountDownTextStyles.akhand57,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.starting_in,
                        style: _SfsCountDownTextStyles.akhand14),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Text(
                        '$minutes:$seconds:$microSeconds',
                        style: _SfsCountDownTextStyles.akhand57,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff686F76),
                            shape: RoundedRectangleBorder(
                                borderRadius: context.normalBorderRadius,
                                side: const BorderSide(color: Colors.white))),
                        onPressed: () {
                          countdownTimer!.cancel();
                          List<HolsterDrawResult> hdResults =
                              <HolsterDrawResult>[
                            HolsterDrawResult.notBegun(DateTime.now()),
                            HolsterDrawResult.rotatingTimeout(
                                DateTime.now(), 1, 1, 1),
                            HolsterDrawResult.targetingTimeout(
                                DateTime.now(), 1, 1, 1, 1),
                            HolsterDrawResult.shotWhileTargeting(
                                DateTime.now(), 1, 1, 1, 1),
                            HolsterDrawResult.shotTimeout(
                                DateTime.now(), 1, 1, 1, 1, 1),
                            HolsterDrawResult.shot(
                                DateTime.now(), 1, 1, 1, 1, 1)
                          ];
                          context.navigateToPage(
                              SfsHolsterDrawPageView(results: hdResults));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          child: Text(AppLocalizations.of(context)!.cancel,
                              textAlign: TextAlign.center),
                        )),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _SfsCountDownTextStyles {
  static const TextStyle akhand57 =
      TextStyle(fontSize: 57, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle akhand14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white);
}
