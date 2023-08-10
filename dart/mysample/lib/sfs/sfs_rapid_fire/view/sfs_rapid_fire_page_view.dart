import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:mysample/widgets/custom_bottom_bar_play.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../views/add_gun_home.dart';
// import '../../sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_flutter/shot_det_datasets/shot_det_datasets.dart';
import 'package:canik_flutter/shot_det_datasets/shot_det_conditions.dart';

import 'package:canik_lib/canik_lib.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';
import 'sfs_rapid_fire_page_4_view.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import 'dart:math';

List<Vector2> getAnglesYP(List<ShotInstance> shotInstances) {
  return shotInstances
      .map((e) => e.processedData.orientation.toEuler().zy)
      .toList(); //rpy->yp
}

double? calculateScore(List<ShotInstance> shotInstances, double distance,
    {double imseMultiplier = 10}) {
  if (shotInstances.length < 2) {
    return null;
  }
  List<Vector2> angles = getAnglesYP(shotInstances);
  int n = angles.length;

  Vector2 average =
      angles.reduce((value, element) => value + element) / n.toDouble();
  var angularDeflections = angles.map((e) => (e - average).length);
  var deflections = angularDeflections.map((e) => tan(e) * distance);
  var meanSquaredError = deflections
          .map((e) => e * e)
          .reduce((value, element) => value + element) /
      n;
  return meanSquaredError / 2;
}

class SfsRapidFirePageView extends StatefulWidget {
  final CanikDevice canikDevice;
  final SfsAllSettings allSettings;
  const SfsRapidFirePageView(
      {required this.allSettings, required this.canikDevice, Key? key})
      : super(key: key);

  @override
  State<SfsRapidFirePageView> createState() => _SfsRapidFirePageViewState();
}

class _SfsRapidFirePageViewState extends State<SfsRapidFirePageView> {
  double _value = 0;

  final String _counterImagePath = 'assets/images/rapid_fire_arch_image.png';
  final ScrollController controller = ScrollController();
  final Color _linearTextColor = Colors.white;
  final CarouselController _carouselController = CarouselController();
  int activeIndex = 0;
  final List<ShotInstance> shotInstances = <ShotInstance>[];
  final List<double?> scores = <double>[];
  late final List<Widget> items;

  @override
  void initState() {
    super.initState();
    items = [
      _CarouselOne(this),
      _CarouselTwo(this),
      _CarouselThree(this),
      _CarouselFour(),
    ];
    widget.canikDevice.shotInstanceStream.listen((event) {
      setState(() {
        shotInstances.add(event);
        scores.add(calculateScore(shotInstances,
            widget.allSettings.advancedSettings.distanceToTarget));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
          appBar: const _CustomAppBarRapidFire(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: _SfsRapidPadding.allPadding30,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _ArchOfMovement(),
                  Image.asset(_counterImagePath),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ProjectColors().black,
                          border: Border.all(color: projectColors.black3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index),
                              height: 40.h,
                              autoPlay: false,
                              viewportFraction: 1,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: items,
                            carouselController: _carouselController,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: buildIndicator(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 10.h,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        controller: controller,
                        children: [
                          Container(
                            height: 8.h,
                            width: 125.w,
                            color: ProjectColors().black,
                            child: SfLinearGauge(
                              minimum: 0,
                              maximum: 15,
                              // labelOffset: 15,
                              // labelOffset: 6,
                              // maximumLabels: 6,
                              minorTicksPerInterval: 2,
                              // showAxisTrack: true,
                              // showTicks: true

                              useRangeColorForAxis: true,
                              axisTrackStyle: const LinearAxisTrackStyle(
                                  color: Colors.transparent, thickness: 1),
                              majorTickStyle: const LinearTickStyle(
                                  color: Colors.white,
                                  thickness: 1,
                                  length: 15),
                              minorTickStyle: LinearTickStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  thickness: 1),

                              markerPointers: [
                                LinearWidgetPointer(
                                    animationType: LinearAnimationType.linear,
                                    dragBehavior: LinearMarkerDragBehavior.free,
                                    onChanged: (double value) {
                                      setState(() {
                                        _value = value;
                                        if (_value > 10) {
                                          controller.animateTo(175,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.fastOutSlowIn);
                                        }
                                        if (_value < 6) {
                                          controller.animateTo(0,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.fastOutSlowIn);
                                        }
                                      });
                                    },
                                    value: _value,
                                    child: Container(
                                      height: 8.h,
                                      width: 7.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ProjectColors().black,
                                          border: Border.all(
                                              color: ProjectColors().black3)),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(_value.toStringAsFixed(0),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: ProjectColors().blue)),
                                      ),
                                    ))
                              ],

                              animateRange: true,
                              animateAxis: true,
                              animationDuration: 1,
                              labelPosition: LinearLabelPosition.outside,
                              axisLabelStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: _linearTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: const CustomBottomBarPlay(),
        )
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: items.length,
        onDotClicked: animateToSlide,
        effect: SlideEffect(
            dotWidth: 15,
            dotHeight: 15,
            activeDotColor: projectColors.white,
            dotColor: projectColors.black3),
      );
  void animateToSlide(int index) => _carouselController.animateToPage(index);
}

class _CustomBottomBarPauseCancelFinish extends StatelessWidget {
  const _CustomBottomBarPauseCancelFinish({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('CANCEL', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(
                  onTap: () {},
                  child: Image.asset('assets/images/close-circle.png'))
            ],
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: ProjectColors().blue,
                shape: const CircleBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.pause_sharp,
                  color: Colors.black,
                ),
              )),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('FINISH', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(
                  onTap: () {},
                  child: Image.asset('assets/images/stop-circle.png'))
            ],
          )
        ],
      ),
    );
  }
}

abstract class IShotInstanceListOwner {
  void updateShotInstanceList(List<ShotInstance> shotInstances);
}

class _CarouselOne extends StatelessWidget {
  _SfsRapidFirePageViewState _sfsRapidFirePageViewState;
  _CarouselOne(
    this._sfsRapidFirePageViewState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late final List<Widget> items = [
    //   const Padding(
    //     padding: EdgeInsets.only(right: 10.0),
    //     child: _CarouselOne(),
    //   ),
    // ];
    final controller = CarouselController();

    double? score = _sfsRapidFirePageViewState.scores.isEmpty
        ? null
        : _sfsRapidFirePageViewState.scores.last;

    String scoreString = score == null ? "-" : score.toString();
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 50.h,
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CustomContainer(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.shot_score,
                          textAlign: TextAlign.center,
                          style: _SfsRapidTextStyles.akhand14,
                        ),
                        Text(
                          scoreString,
                          textAlign: TextAlign.center,
                          style: _SfsRapidTextStyles.akhand14,
                        ),
                      ],
                    ),
                  )),
                  Text(
                    AppLocalizations.of(context)!.shot_correction_chart,
                    style: _SfsRapidTextStyles.akhand17,
                  ),
                  _CustomContainer(
                      child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.anticipating_recoil,
                      textAlign: TextAlign.center,
                      style: _SfsRapidTextStyles.akhand10,
                    ),
                  )),
                ],
              ),
              const _RapidFireCenterImageText(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CustomContainer(
                    child:
                        Image.asset('assets/images/rapid_fire_gun_image.png'),
                  ),
                  //77
                  const _CustomContainer(
                      child: Center(
                    child: Text(
                      '03:08:12',
                      style: _SfsRapidTextStyles.akhand12,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselTwo extends StatelessWidget {
  final _SfsRapidFirePageViewState _sfsRapidFirePageViewState;
  _CarouselTwo(this._sfsRapidFirePageViewState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? score = _sfsRapidFirePageViewState.scores.isEmpty
        ? null
        : _sfsRapidFirePageViewState.scores.last;
    String scoreString = score == null ? "-" : score.toString();

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 40.h,
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CustomContainer(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.shot_score,
                          textAlign: TextAlign.center,
                          style: _SfsRapidTextStyles.akhand14,
                        ),
                        Text(
                          scoreString,
                          textAlign: TextAlign.center,
                          style: _SfsRapidTextStyles.akhand14,
                        ),
                      ],
                    ),
                  )),
                  Text(
                    AppLocalizations.of(context)!.end_point,
                    style: _SfsRapidTextStyles.akhand17,
                  ),
                  _CustomContainer(
                      child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.anticipating_recoil,
                      textAlign: TextAlign.center,
                      style: _SfsRapidTextStyles.akhand10,
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 20.h,
                      width: 30.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Frame219.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CustomContainer(
                    child:
                        Image.asset('assets/images/rapid_fire_gun_image.png'),
                  ),
                  //77
                  const _CustomContainer(
                      child: Center(
                    child: Text(
                      '03:08:12',
                      style: _SfsRapidTextStyles.akhand12,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselThree extends StatefulWidget {
  final _SfsRapidFirePageViewState _sfsRapidFirePageViewState;
  _CarouselThree(this._sfsRapidFirePageViewState, {Key? key}) : super(key: key);

  @override
  State<_CarouselThree> createState() => __CarouselThreeState();
}

class __CarouselThreeState extends State<_CarouselThree> {
  String titleText = "How fix incorrect trigger pull";
  String SubText1 =
      "This occurs when the shooter exerts excessive forward pressure with the heel of the hand as the gun is fired. This pressure forces the front sight up just as the trigger trips the sear. It will usually result in a shot group high near the 12:00 position on the target.";
  String SubText2 =
      "Diagnosing and fixing trigger control heeling errors (as well as any of these errors) is not an exact science because several other factors may be involved, like problems with proper grip, sight alignment, sight picture, stable stance, etc. A complete and deliberate focus on the front sight, both mentally and visually, will usually help cure this error.";
  String errorText =
      "do not anticipate recoil, do not push the heel of the hand forward when the shot breaks, and do not break your wrist upward.";

  // List<int> mockListData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  List<bool> isClick = [];
  @override
  void initState() {
    isClick = List<bool>.filled(shotInstances.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isClick = List<bool>.filled(shotInstances.length, false);
    return Padding(
      padding: _SfsRapidPadding.vertical15,
      child: SizedBox(
        height: 40.h,
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      AppLocalizations.of(context)!.sfs_page3_title,
                      style: TextStyle(
                          color: ProjectColors().white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                            AppLocalizations.of(context)!.sfs_page3_shot,
                            style: TextStyle(
                                color: ProjectColors().black3,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 1,
                        child: Text(
                            AppLocalizations.of(context)!.sfs_page3_score,
                            style: TextStyle(
                                color: ProjectColors().black3,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 1,
                        child: Text(
                            AppLocalizations.of(context)!.sfs_page3_time,
                            style: TextStyle(
                                color: ProjectColors().black3,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center)),
                    Expanded(
                        flex: 1,
                        child: Text(
                            AppLocalizations.of(context)!.sfs_page3_split,
                            style: TextStyle(
                                color: ProjectColors().black3,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center)),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: shotInstances.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isClick[index]) {
                              isClick[index] = true;
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => buildSheet(),
                              );
                            } else {
                              isClick[index] = false;
                            }
                          });
                        },
                        child: Container(
                          decoration: isClick[index]
                              ? BoxDecoration(color: ProjectColors().blue)
                              : (index + 1) % 2 != 0
                                  ? BoxDecoration(color: ProjectColors().black2)
                                  : BoxDecoration(color: ProjectColors().black),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text((index + 1).toString(),
                                      style: TextStyle(
                                          color: ProjectColors().white,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      widget._sfsRapidFirePageViewState
                                                  .scores[index] ==
                                              null
                                          ? "-"
                                          : widget._sfsRapidFirePageViewState
                                              .scores[index]
                                              .toString(),
                                      style: TextStyle(
                                          color: ProjectColors().white,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      shotInstances[index].time.toString(),
                                      style: TextStyle(
                                          color: ProjectColors().white,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      shotInstances[index].deltaT == null
                                          ? "-"
                                          : shotInstances[index]
                                              .deltaT
                                              .toString(),
                                      style: TextStyle(
                                          color: ProjectColors().white,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              //77
            ],
          ),
        ),
      ),
    );
  }

  List<ShotInstance> get shotInstances {
    return widget._sfsRapidFirePageViewState.shotInstances;
  }

  Widget buildSheet() => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: projectColors.black,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 40, right: 150, left: 150),
                    child: Container(
                      width: 70,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 100.h > 1200 ? 15.h : 10.h,
                      decoration: BoxDecoration(
                          color: projectColors.black2,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, top: 10, left: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Do",
                              style: TextStyle(
                                  color: projectColors.blue,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/Vector.png",
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      right: 22,
                                      top: 42,
                                      child: Image.asset(
                                        "assets/images/Rectangle 95.png",
                                        fit: BoxFit.cover,
                                      )),
                                  Positioned(
                                      right: 2,
                                      top: 30,
                                      child: Image.asset(
                                        "assets/images/Rectangle 96.png",
                                        fit: BoxFit.cover,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100.h > 1200 ? 15.h : 10.h,
                    decoration: BoxDecoration(
                        color: projectColors.black2,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, top: 10, left: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don't",
                            style: TextStyle(
                                color: projectColors.black3,
                                fontSize: 40,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/images/Vector.png",
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    right: 2,
                                    top: 32,
                                    child: Image.asset(
                                      "assets/images/Rectangle 93.png",
                                      fit: BoxFit.cover,
                                    )),
                                Positioned(
                                    right: 2,
                                    top: 32,
                                    child: Image.asset(
                                      "assets/images/Rectangle 94.png",
                                      fit: BoxFit.cover,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      titleText,
                      style: TextStyle(
                          color: projectColors.white,
                          fontSize: 100.h > 1200 ? 35 : 24,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(
                      SubText1,
                      style: TextStyle(
                          color: projectColors.white1,
                          fontSize: 100.h > 1200 ? 30 : 17,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    height: 100.h > 1200 ? 8.h : 11.h,
                    decoration: BoxDecoration(
                        color: projectColors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                              flex: 1,
                              child: Icon(Icons.error_outline_outlined)),
                          Expanded(
                              flex: 6,
                              child: Text(
                                errorText,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 100.h > 1200 ? 28 : 15,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(
                      SubText2,
                      style: TextStyle(
                          color: projectColors.white1,
                          fontSize: 100.h > 1200 ? 30 : 17,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: 100.h > 1200
                        ? EdgeInsets.only(top: 25)
                        : EdgeInsets.zero,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize:
                                100.h > 1200 ? Size(400, 70) : Size(400, 44),
                            primary: projectColors.black2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(
                                  color: projectColors.white, width: 1.5),
                            )),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              color: projectColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        )),
                  )
                ],
              ),
            ),
          );
        },
      );
}

class _CarouselFour extends StatefulWidget {
  _CarouselFour({Key? key}) : super(key: key);

  @override
  State<_CarouselFour> createState() => __CarouselFourState();
}

class __CarouselFourState extends State<_CarouselFour> {
  final List<ChartData> data = [
    ChartData(10, 190),
    ChartData(20, 20),
    ChartData(30, 158),
    ChartData(40, -150),
    ChartData(50, 200),
    ChartData(60, 300),
    ChartData(50, 200),
    ChartData(60, 300),
    ChartData(70, -150),
    ChartData(80, 200),
    ChartData(90, 300),
    ChartData(100, 200),
    ChartData(110, 300),
  ];
  final List<ChartData2nd> data2nd = [
    ChartData2nd(10, 95, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(10, -150, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(20, 181, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(20, -130, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(30, 230, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(30, -200, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(40, 70, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(40, -140, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(50, 120, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(50, -155, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(60, 130, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(60, -210, const Color.fromARGB(255, 255, 215, 207)),
    ChartData2nd(70, 40, const Color.fromARGB(255, 255, 80, 99)),
    ChartData2nd(70, -240, const Color.fromARGB(255, 255, 215, 207)),
  ];
  late ZoomPanBehavior _panBehavior;
  late TooltipBehavior _tooltipbehaviour;
  late TooltipBehavior _tooltipbehaviour2;
  late ZoomPanBehavior _panBehavior2;

  @override
  void initState() {
    _tooltipbehaviour = TooltipBehavior(enable: true);
    _panBehavior = ZoomPanBehavior(
        enablePinching: true,
        selectionRectBorderColor: projectColors.blue,
        selectionRectBorderWidth: 2,
        selectionRectColor: projectColors.black2,
        enablePanning: true,
        zoomMode: ZoomMode.x);
    _tooltipbehaviour2 = TooltipBehavior(enable: true);
    _panBehavior2 = ZoomPanBehavior(
        enablePinching: true,
        selectionRectBorderColor: projectColors.blue,
        selectionRectBorderWidth: 2,
        selectionRectColor: projectColors.black2,
        enablePanning: true,
        zoomMode: ZoomMode.x);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: _SfsRapidPadding.vertical15,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Chartsbackground.png"),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.sfs_page4_title,
                      style: TextStyle(
                          color: projectColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          flex: 10,
                          child: SfCartesianChart(
                              tooltipBehavior: _tooltipbehaviour,
                              enableAxisAnimation: true,
                              zoomPanBehavior: _panBehavior,
                              backgroundColor: Colors.transparent,
                              plotAreaBorderColor: Colors.transparent,
                              plotAreaBackgroundColor: Colors.transparent,
                              primaryXAxis: NumericAxis(
                                  crossesAt: 0,
                                  isVisible: true,
                                  axisLine: AxisLine(
                                      color: projectColors.blue,
                                      dashArray: [3, 6]),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  rangePadding: ChartRangePadding.none,
                                  maximumLabels: 0,
                                  // Ekranda X ekseninde max deger verisi ona göre sağa scroll olabiliyor.
                                  visibleMaximum: 60),
                              primaryYAxis: NumericAxis(
                                crossesAt: 0,
                                isVisible: false,
                                maximum: 450,
                                minimum: -350,
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                rangePadding: ChartRangePadding.none,
                              ),
                              series: <ChartSeries>[
                                SplineSeries<ChartData, int>(
                                    color: projectColors.black3,
                                    enableTooltip: true,
                                    dataSource: data,
                                    markerSettings: MarkerSettings(
                                        isVisible: true,
                                        height: 7,
                                        width: 7,
                                        color: projectColors.black2,
                                        shape: DataMarkerType.circle),
                                    // Type of spline

                                    xValueMapper: (ChartData data, _) =>
                                        data.xval,
                                    yValueMapper: (ChartData data, _) =>
                                        data.yval,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        alignment: ChartAlignment.center,
                                        labelAlignment:
                                            ChartDataLabelAlignment.outer,
                                        textStyle: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: projectColors.white)))
                              ])),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: projectColors.black2,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 4,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 80, 99),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.sfs_grip,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 4,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 215, 207),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.sfs_pull,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),

                      Expanded(
                          flex: 10,
                          child: SfCartesianChart(
                              tooltipBehavior: _tooltipbehaviour2,
                              enableAxisAnimation: true,
                              zoomPanBehavior: _panBehavior2,
                              backgroundColor: Colors.transparent,
                              plotAreaBorderColor: Colors.transparent,
                              plotAreaBackgroundColor: Colors.transparent,
                              primaryXAxis: NumericAxis(
                                  crossesAt: 0,
                                  isVisible: true,
                                  axisLine:
                                      AxisLine(color: projectColors.black3),
                                  edgeLabelPlacement: EdgeLabelPlacement.none,
                                  rangePadding: ChartRangePadding.auto,
                                  maximumLabels: 0,
                                  // Ekranda X ekseninde max deger verisi ona göre sağa scroll olabiliyor.
                                  visibleMaximum: 60),
                              primaryYAxis: NumericAxis(
                                visibleMaximum: 250,
                                visibleMinimum: -250,
                                crossesAt: 0,
                                isVisible: false,
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                rangePadding: ChartRangePadding.auto,
                              ),
                              series: <ChartSeries>[
                                ColumnSeries<ChartData2nd, int>(
                                    pointColorMapper: (datum, index) =>
                                        datum.color,
                                    color: projectColors.black3,
                                    enableTooltip: true,
                                    dataSource: data2nd,

                                    // Type of spline

                                    xValueMapper: (ChartData2nd data, _) =>
                                        data.xval,
                                    yValueMapper: (ChartData2nd data, _) =>
                                        data.yval,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    spacing: 0.8
                                    // dataLabelSettings: DataLabelSettings(
                                    //   isVisible: true,
                                    //   alignment: ChartAlignment.far,
                                    //   labelAlignment: ChartDataLabelAlignment.top,
                                    //   textStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: projectColors.white)

                                    //   )
                                    )
                              ])),

                      //  Expanded(
                      //     flex: 1,
                      //     child: SfSparkLineChart.custom(

                      //       labelStyle: TextStyle(color: Colors.white,fontSize: 10),
                      //       axisLineDashArray: <double>[2,5],
                      //       color: projectColors.black3,
                      //       axisLineColor: projectColors.blue,
                      //       trackball: SparkChartTrackball(
                      //         borderColor: projectColors.blue,
                      //         activationMode: SparkChartActivationMode.tap
                      //       ),
                      //       marker: SparkChartMarker(
                      //         color: projectColors.black3,
                      //         size: 5,
                      //         displayMode: SparkChartMarkerDisplayMode.all
                      //       ),
                      //      labelDisplayMode:
                      //      SparkChartLabelDisplayMode.all,
                      //      dataCount: data.length,
                      //       xValueMapper: (index) => data[index].xval,
                      //       yValueMapper: (index) => data[index].yval,

                      //     ),
                      //   )
                    ],
                  ),
                ),
                //77
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RapidFireCenterImageText extends StatelessWidget {
  const _RapidFireCenterImageText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 20.h,
            width: 30.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/rapid_fire_center_icon.png'),
                  fit: BoxFit.contain),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 5.w, top: 3.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                        width: 10.w,
                        child: const Text('Overall Score',
                            textAlign: TextAlign.center,
                            style: _SfsRapidTextStyles.akhand14)),
                  ),
                  const Text('72', style: _SfsRapidTextStyles.akhand17)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomContainer extends StatefulWidget {
  const _CustomContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  State<_CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<_CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          const BoxDecoration(color: Color(0xff657981), shape: BoxShape.circle),
      child: widget.child,
    );
  }
}

class _ArchOfMovement extends StatelessWidget {
  const _ArchOfMovement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.arch_of_movenent,
          style: _SfsRapidTextStyles.akhand17,
        ),
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.white,
              size: 12,
            ))
      ],
    );
  }
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
      title: Image.asset('assets/images/rapid_fire_app_bar_image.png'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.h, top: 5.h),
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

class _SfsRapidTextStyles {
  static const TextStyle akhand57 =
      TextStyle(fontSize: 57, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle akhand17 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle akhand14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand12 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand10 =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle built17 = TextStyle(
      fontFamily: 'Built',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.white);
}

class _SfsRapidPadding {
  static const EdgeInsets allPadding30 =
      EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20);
  static const EdgeInsets vertical15 = EdgeInsets.symmetric(vertical: 15);
}

class ChartData {
  int xval;
  int yval;

  ChartData(this.xval, this.yval);
}

class ChartData2nd {
  int xval;
  int yval;
  Color color;
  ChartData2nd(this.xval, this.yval, this.color);
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
