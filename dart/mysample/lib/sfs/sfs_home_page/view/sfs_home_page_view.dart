import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
// import 'package:mysample/sfs/sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_lib/canik_lib.dart';
import 'package:mysample/sfs/sfs_counter_pages/views/sfs_waiting_page_view.dart';
import 'package:mysample/sfs/sfs_home_page/model/sfs_home_model.dart';
import 'package:mysample/sfs/sfs_home_page/viewmodel/sfs_home_page_view_model.dart';
import 'package:mysample/widgets/app_bar_sfs.dart';
import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:canik_flutter/shot_det_datasets/shot_det_datasets.dart';
import 'package:canik_flutter/shot_det_datasets/shot_det_conditions.dart'
    as conditions;
import '../../../constants/color_constants.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';

enum SfsTrainingMode { fastDraw, rapidFire, shotTimer }

class SfsHomePage extends StatefulWidget {
  final SfsAllSettings allSettings;
  final CanikDevice canikDevice;
  SfsHomePage({required this.allSettings, required this.canikDevice, Key? key})
      : super(key: key) {
    switch (allSettings.advancedSettings.detectorType) {
      case SfsShotDetectorType.paintFire:
        canikDevice.updateShotConditionsAndDataset(
            conditions.paintFireConditions,
            ShotDataset()..fillFromList(paintFireSetList));
        break;
      case SfsShotDetectorType.dryFire:
        canikDevice.updateShotConditionsAndDataset(conditions.dryFireConditions,
            ShotDataset()..fillFromList(dryFireSetList));
        break;
      case SfsShotDetectorType.liveFire:
        canikDevice.updateShotConditionsAndDataset(
            conditions.liveFireConditions,
            ShotDataset()..fillFromList(liveFireSetList));
        break;
      //TODO: blank fire dataset does not exist
      // case SfsShotDetectorType.blankFire:
      //     canikDevice.updateShotConditionsAndDataset(conditions.blankFireConditions, ShotDataset()..fillFromList(--));
      //   break;
      //TODO: cool fire dataset does not exist
      // case SfsShotDetectorType.coolFire:
      //     canikDevice.updateShotConditionsAndDataset(conditions.coolFireConditions, ShotDataset()..fillFromList(--));
      // break;
      default:
    }
  }

  @override
  State<SfsHomePage> createState() => _SfsHomePageState();
}

class _SfsHomePageState extends State<SfsHomePage> {
  final Color _borderColor = SfsHomePageColors.seaMariner;
  List<bool> allIndex = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    allIndex = List<bool>.filled(homeCardList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBarForSfs(),
          body: Padding(
            padding: const SfsHomePagePadding.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CustomTextTraining(),
                SizedBox(
                  height: 60.h,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        mainAxisExtent: 28.h),
                    itemCount: homeCardList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _CustomCard(
                          isVisible: allIndex[index] == true ? true : false,
                          borderColor: allIndex[index] == false
                              ? _borderColor
                              : ProjectColors().blue,
                          function: () {
                            setState(() {
                              allIndex =
                                  List<bool>.filled(homeCardList.length, false);
                              _currentIndex = SfsHomePageViewModel()
                                  .findToCurrentIndexHomePage(
                                      homeCardList[index].title);
                              allIndex[_currentIndex] = true;
                            });
                          },
                          explanation: homeCardList[index].explanation,
                          title: homeCardList[index].title,
                          subtitle: homeCardList[index].subtitle,
                          index: index);
                    },
                  ),
                ),
                _ContinueButton(
                  canikDevice: widget.canikDevice,
                  trainingMode: _currentIndex == 0
                      ? SfsTrainingMode.fastDraw
                      : _currentIndex == 1
                          ? SfsTrainingMode.rapidFire
                          : SfsTrainingMode.shotTimer,
                  allSettings: widget.allSettings,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomShareCard extends StatefulWidget {
  const _CustomShareCard({Key? key, required this.borderCOlor})
      : super(key: key);
  final Color borderCOlor;

  @override
  State<_CustomShareCard> createState() => _CustomShareCardState();
}

class _CustomShareCardState extends State<_CustomShareCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: 40.w,
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/share_sfs.png'),
              fit: BoxFit.cover),
          borderRadius: context.normalBorderRadius,
          color: ProjectColors().black,
          border: Border.all(width: 2, color: widget.borderCOlor)),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final SfsTrainingMode trainingMode;
  final SfsAllSettings allSettings;
  final CanikDevice canikDevice;
  const _ContinueButton({
    required this.allSettings,
    required this.trainingMode,
    required this.canikDevice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context.navigateToPage(SfsWaitingPageView(
            canikDevice: canikDevice,
            allSettings: allSettings,
            trainingMode: trainingMode,
          ));
        },
        style: ElevatedButton.styleFrom(
            primary: ProjectColors().blue,
            shape: RoundedRectangleBorder(
                borderRadius: context.normalBorderRadius)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  AppLocalizations.of(context)!.continue_button,
                  style: _SfsHomePageTextStyles.builtw600,
                ),
              ),
              const Icon(Icons.arrow_right_alt)
            ],
          ),
        ));
  }
}

class _CustomCard extends StatefulWidget {
  const _CustomCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.explanation,
      required this.index,
      required this.function,
      required this.borderColor,
      required this.isVisible})
      : super(key: key);
  final String title;
  final String subtitle;
  final String explanation;
  final int index;
  final Function() function;
  final Color borderColor;
  final bool isVisible;
  @override
  State<_CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<_CustomCard> {
  @override
  Widget build(BuildContext context) {
    return widget.title != ''
        ? InkWell(
            borderRadius: context.normalBorderRadius,
            onTap: widget.function,
            child: Container(
              width: 50.w,
              decoration: BoxDecoration(
                  borderRadius: context.normalBorderRadius,
                  color: ProjectColors().black,
                  border: Border.all(width: 2, color: widget.borderColor)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outlined,
                            color: ProjectColors().blue)
                        .toVisible(widget.isVisible),
                    Text(
                      widget.title,
                      style: _SfsHomePageTextStyles.built30,
                    ),
                    Text(widget.subtitle,
                        style: _SfsHomePageTextStyles.akhandBold),
                    Text(widget.explanation,
                        style: widget.index == 2
                            ? _SfsHomePageTextStyles.akhand12Normal
                            : _SfsHomePageTextStyles.akhand17Normal),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Read more',
                          style: _SfsHomePageTextStyles.akhand17,
                        ))
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            borderRadius: context.normalBorderRadius,
            onTap: widget.function,
            child: _CustomShareCard(
              borderCOlor: widget.borderColor,
            ));
  }
}

class _CustomTextTraining extends StatelessWidget {
  const _CustomTextTraining({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CustomText(
            chooseYourTraining:
                AppLocalizations.of(context)!.choose_your_training),
        Container()
      ],
    );
  }
}

class _CustomText extends StatelessWidget {
  const _CustomText({
    Key? key,
    required String chooseYourTraining,
  })  : _chooseYourTraining = chooseYourTraining,
        super(key: key);

  final String _chooseYourTraining;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      child: Text(
        _chooseYourTraining,
        textAlign: TextAlign.center,
        style: _SfsHomePageTextStyles.built32,
      ),
    );
  }
}

class SfsHomePagePadding extends EdgeInsets {
  const SfsHomePagePadding.all(double value) : super.all(value);
}

class _SfsHomePageTextStyles {
  static const built32 = TextStyle(
      color: Colors.white,
      fontFamily: 'Built',
      fontSize: 32,
      fontWeight: FontWeight.w600);
  static const builtw600 = TextStyle(
      color: Colors.white,
      fontFamily: 'Built',
      fontSize: 17,
      fontWeight: FontWeight.w600);
  static final akhand17 = TextStyle(
      decoration: TextDecoration.underline,
      color: ProjectColors().blue,
      fontSize: 17,
      fontWeight: FontWeight.normal);
  static const built30 = TextStyle(
      color: Colors.white,
      fontFamily: 'Built',
      fontSize: 30,
      fontWeight: FontWeight.w400);
  static const akhandBold = TextStyle(
      color: SfsHomePageColors.seaMariner,
      fontSize: 10,
      fontWeight: FontWeight.bold);
  static const akhand17Normal = TextStyle(
      color: SfsHomePageColors.zenBlue,
      fontSize: 17,
      fontWeight: FontWeight.normal);
  static const akhand12Normal = TextStyle(
      color: SfsHomePageColors.zenBlue,
      fontSize: 12,
      fontWeight: FontWeight.normal);
}

class SfsHomePageColors {
  static const seaMariner = Color(0xff424B54);
  static const zenBlue = Color(0xff9FAAC0);
}
