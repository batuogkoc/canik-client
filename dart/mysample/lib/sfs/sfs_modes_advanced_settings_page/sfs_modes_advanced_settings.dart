import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/sfs/sfs_home_page/view/sfs_home_page_view.dart';
import 'package:mysample/sfs/sfs_modes_advanced_settings_page/sfs_modes_settings_page.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// import '../sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_lib/canik_lib.dart';

class SfsModesAdvancedSettings extends StatefulWidget {
  final CanikDevice canikDevice;
  final SfsModesSettings datas;
  const SfsModesAdvancedSettings(
      {required this.canikDevice, required this.datas, Key? key})
      : super(key: key);

  @override
  State<SfsModesAdvancedSettings> createState() =>
      _SfsModesAdvancedSettingsState();
}

class _SfsModesAdvancedSettingsState extends State<SfsModesAdvancedSettings> {
  double magazineCapacity = 0;
  double countdownDurationSecs = 0;
  double distanceToTarget = 0;
  bool isClick = false;
  bool isClick2 = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/image_9.png",
          height: context.height,
          width: context.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: const _CustomAppBarRapidFire(),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 25.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        color: projectColors.white1,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: widget.datas.chosenGun.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: projectColors.black2),
                        color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/sfssettingsicon.png",
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.dryfire,
                                style: TextStyle(
                                    color: projectColors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SfsHomePage(
                                              allSettings: SfsAllSettings(
                                                modesSettings: widget.datas,
                                                advancedSettings: SfsAdvancedSettings(
                                                    detectorType:
                                                        SfsShotDetectorType
                                                            .dryFire,
                                                    magazineCapacity:
                                                        magazineCapacity
                                                            .toInt(),
                                                    countdownDurationSecs:
                                                        countdownDurationSecs,
                                                    distanceToTarget:
                                                        distanceToTarget),
                                              ),
                                              canikDevice: widget.canikDevice,
                                            )));
                              },
                              child: Image.asset(
                                  "assets/images/chevron-right.png",
                                  fit: BoxFit.cover))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: projectColors.black2),
                        color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/sfssettingsicon2.png",
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.simunition,
                                style: TextStyle(
                                    color: projectColors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Image.asset("assets/images/chevron-right.png",
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: projectColors.black2),
                        color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/sfssettingsicon3.png",
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.coolfire,
                                style: TextStyle(
                                    color: projectColors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Image.asset("assets/images/chevron-right.png",
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: projectColors.black2),
                        color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/sfssettingsicon4.png",
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.livefire,
                                style: TextStyle(
                                    color: projectColors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Image.asset("assets/images/chevron-right.png",
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: 80.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: projectColors.black2),
                        color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/sfssettingsicon5.png",
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.blankfire,
                                style: TextStyle(
                                    color: projectColors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Image.asset("assets/images/chevron-right.png",
                              fit: BoxFit.cover)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context, builder: (context) => buildSheet());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/setting-2.png",
                          color: projectColors.white,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!.advancedsettings,
                          style: TextStyle(
                              color: projectColors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildSheet() => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: projectColors.black,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 75,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .advancedsettings
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                        color: projectColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.shotcount,
                                        style: TextStyle(
                                            color: projectColors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Theme(
                                              child: Checkbox(
                                                checkColor: Colors.white,
                                                value: isClick,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isClick = value!;
                                                  });
                                                },
                                              ),
                                              data: ThemeData(
                                                  primarySwatch: Colors.blue,
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .infinite,
                                              style: TextStyle(
                                                  color: projectColors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SfLinearGauge(
                                  axisTrackStyle: LinearAxisTrackStyle(
                                      color: Color.fromARGB(255, 156, 171, 194),
                                      edgeStyle: LinearEdgeStyle.bothCurve,
                                      thickness: 10),
                                  markerPointers: [
                                    LinearWidgetPointer(
                                      value: magazineCapacity,
                                      markerAlignment:
                                          LinearMarkerAlignment.center,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: projectColors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 156, 171, 194),
                                                width: 2)),
                                        child: Center(
                                            child: Text(
                                          "III",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 156, 171, 194),
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          magazineCapacity = value;
                                        });
                                      },
                                    ),
                                  ],
                                  orientation:
                                      LinearGaugeOrientation.horizontal,
                                  animateAxis: true,
                                  minimum: 0,
                                  maximum: 20,
                                  showLabels: false,
                                  showTicks: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            magazineCapacity.toInt().toString(),
                            style: TextStyle(
                                color: projectColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 32),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .countdowntime,
                                        style: TextStyle(
                                            color: projectColors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Theme(
                                              child: Checkbox(
                                                checkColor: Colors.white,
                                                value: isClick2,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isClick2 = value!;
                                                  });
                                                },
                                              ),
                                              data: ThemeData(
                                                  primarySwatch: Colors.blue,
                                                  unselectedWidgetColor:
                                                      Colors.white),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .random,
                                              style: TextStyle(
                                                  color: projectColors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SfLinearGauge(
                                  axisTrackStyle: LinearAxisTrackStyle(
                                      color: Color.fromARGB(255, 156, 171, 194),
                                      edgeStyle: LinearEdgeStyle.bothCurve,
                                      thickness: 10),
                                  markerPointers: [
                                    LinearWidgetPointer(
                                      value: countdownDurationSecs,
                                      markerAlignment:
                                          LinearMarkerAlignment.center,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: projectColors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 156, 171, 194),
                                                width: 2)),
                                        child: Center(
                                            child: Text(
                                          "III",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 156, 171, 194),
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          countdownDurationSecs = value;
                                        });
                                      },
                                    ),
                                  ],
                                  orientation:
                                      LinearGaugeOrientation.horizontal,
                                  animateAxis: true,
                                  minimum: 0,
                                  maximum: 20,
                                  showLabels: false,
                                  showTicks: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            countdownDurationSecs.toInt().toString(),
                            style: TextStyle(
                                color: projectColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 32),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 4.h,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .targetdistance,
                                      style: TextStyle(
                                          color: projectColors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )),
                                SfLinearGauge(
                                  axisTrackStyle: LinearAxisTrackStyle(
                                      color: Color.fromARGB(255, 156, 171, 194),
                                      edgeStyle: LinearEdgeStyle.bothCurve,
                                      thickness: 10),
                                  markerPointers: [
                                    LinearWidgetPointer(
                                      value: distanceToTarget,
                                      markerAlignment:
                                          LinearMarkerAlignment.center,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: projectColors.black,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 156, 171, 194),
                                                width: 2)),
                                        child: Center(
                                            child: Text(
                                          "III",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 156, 171, 194),
                                              fontSize: 16),
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          distanceToTarget = value;
                                        });
                                      },
                                    ),
                                  ],
                                  orientation:
                                      LinearGaugeOrientation.horizontal,
                                  animateAxis: true,
                                  minimum: 0,
                                  maximum: 200,
                                  showLabels: false,
                                  showTicks: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "${distanceToTarget.toInt().toString()}m",
                            style: TextStyle(
                                color: projectColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 22),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: projectColors.white1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              fixedSize: const Size(140, 50),
                              primary: projectColors.black2),
                          child: Text(
                            AppLocalizations.of(context)!.close,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              fixedSize: const Size(140, 50),
                              primary: projectColors.blue),
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
}

class _CustomAppBarRapidFire extends StatelessWidget
    implements PreferredSizeWidget {
  const _CustomAppBarRapidFire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 10.h,
      title: Image.asset('assets/images/settings_app_bar.png'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Image.asset(
                'assets/images/close_icon.png',
              )),
        )
      ],
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(10.h);
}

class SfsAllSettings {
  SfsModesSettings modesSettings;
  SfsAdvancedSettings advancedSettings;
  SfsAllSettings({
    required this.modesSettings,
    required this.advancedSettings,
  });
}

enum SfsShotDetectorType { dryFire, liveFire, paintFire, coolFire, simulation }

class SfsAdvancedSettings {
  int magazineCapacity;
  double countdownDurationSecs;
  double distanceToTarget;
  SfsShotDetectorType detectorType;
  SfsAdvancedSettings({
    required this.magazineCapacity,
    required this.countdownDurationSecs,
    required this.distanceToTarget,
    required this.detectorType,
  });
}
