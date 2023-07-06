import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/sfs/sfs_holster_draw_page/model/improve_model.dart';
import 'package:mysample/widgets/legend_widget.dart';
import 'package:sizer/sizer.dart';

import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:mysample/widgets/custom_bottom_bar_play.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../constants/color_constants.dart';
// import '../../sfs_core/canik_backend.dart';
import 'package:canik_flutter/canik_backend.dart';
import 'package:canik_lib/canik_lib.dart';
import '../../sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';

class SfsHolsterDrawPageView extends StatefulWidget {
  final CanikDevice canikDevice;
  final SfsAllSettings allSettings;
  const SfsHolsterDrawPageView(
      {required this.allSettings, required this.canikDevice, Key? key})
      : super(key: key);

  @override
  State<SfsHolsterDrawPageView> createState() => _SfsHolsterDrawPageViewState();
}

class _SfsHolsterDrawPageViewState extends State<SfsHolsterDrawPageView> {
  static const betweenSpace = 0.2;
  static const Color _gripColor = Color(0xff6FC3EB);
  static const Color _pullColor = Color(0xffB7E2F5);
  static const Color _horizColor = Color(0xff1DA0D7);
  static const Color _aimColor = Color(0xff146A90);
  static const Color _shotColor = Colors.white;

  int touchedIndex = -1;
  Color clickedColor = Colors.transparent;
  final double _chartWidth = 5;
  BarChartGroupData generateGroupData(int x, double grip, double pull,
      double horizontal, double aim, double shot) {
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
        x: x,
        groupVertically: true,
        showingTooltipIndicators: isTouched ? [0] : [],
        barRods: [
          BarChartRodData(
              fromY: 0,
              toY: grip,
              color: _gripColor,
              width: _chartWidth,
              backDrawRodData: BackgroundBarChartRodData(
                color: clickedColor,
                show: true,
                fromY: 0,
                toY: grip,
              ),
              borderSide:
                  BorderSide(color: Colors.white, width: isTouched ? 1 : 0)),
          BarChartRodData(
              fromY: grip + betweenSpace,
              toY: grip + betweenSpace + pull,
              color: _pullColor,
              width: _chartWidth,
              borderSide:
                  BorderSide(color: Colors.white, width: isTouched ? 1 : 0)),
          BarChartRodData(
              fromY: grip + betweenSpace + pull + betweenSpace,
              toY: grip + betweenSpace + pull + betweenSpace + horizontal,
              color: _horizColor,
              width: _chartWidth,
              borderSide:
                  BorderSide(color: Colors.white, width: isTouched ? 1 : 0)),
          BarChartRodData(
              fromY: grip +
                  betweenSpace +
                  pull +
                  betweenSpace +
                  horizontal +
                  betweenSpace,
              toY: grip +
                  betweenSpace +
                  pull +
                  betweenSpace +
                  horizontal +
                  betweenSpace +
                  aim,
              color: _aimColor,
              width: _chartWidth,
              borderSide:
                  BorderSide(color: Colors.white, width: isTouched ? 1 : 0)),
          BarChartRodData(
              fromY: grip +
                  betweenSpace +
                  pull +
                  betweenSpace +
                  horizontal +
                  betweenSpace +
                  aim +
                  betweenSpace,
              toY: grip +
                  betweenSpace +
                  pull +
                  betweenSpace +
                  horizontal +
                  betweenSpace +
                  aim +
                  betweenSpace +
                  shot,
              color: _shotColor,
              width: _chartWidth,
              borderSide:
                  BorderSide(color: Colors.white, width: isTouched ? 1 : 0)),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      expansionExtent: 10,
      minExtent: 40.h,
      maxExtent: 80.h,
      backgroundWidget: Stack(
        children: [
          const BackgroundImageForSfs(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const _CustomHolsterDrawAppBar(),
            bottomNavigationBar: const CustomBottomBarPlay(),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: SizedBox(
                            height: 30.h,
                            width: 150.w,
                            child: BarChart(BarChartData(
                              backgroundColor: Colors.transparent,
                              alignment: BarChartAlignment.spaceBetween,
                              titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(),
                                  rightTitles: AxisTitles(),
                                  topTitles: AxisTitles(),
                                  bottomTitles: AxisTitles(
                                      axisNameSize: 20,
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(0),
                                            style: _SfsHolsterDrawTextStyles
                                                .akhand17,
                                          );
                                        },
                                      ))),
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.transparent,
                                    fitInsideVertically: true,
                                    direction: TooltipDirection.top),
                                enabled: true,
                                touchCallback:
                                    (FlTouchEvent event, barTouchResponse) {
                                  if (!event.isInterestedForInteractions ||
                                      barTouchResponse == null ||
                                      barTouchResponse.spot == null) {
                                    setState(() {
                                      touchedIndex = -1;
                                    });
                                    return;
                                  }
                                  final rodIndex = barTouchResponse
                                      .spot!.touchedRodDataIndex;
                                  if (isShadowBar(rodIndex)) {
                                    setState(() {
                                      touchedIndex = -1;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    touchedIndex = barTouchResponse
                                            .spot!.touchedBarGroupIndex +
                                        1;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              barGroups: [
                                generateGroupData(1, 10, 20, 30, 20, 10),
                                generateGroupData(2, 20, 50, 10, 10, 20),
                                generateGroupData(3, 30, 20, 30, 50, 30),
                                generateGroupData(4, 20, 30, 40, 30, 10),
                                generateGroupData(5, 10, 10, 50, 40, 40),
                                generateGroupData(6, 30, 10, 40, 50, 50),
                                generateGroupData(7, 40, 20, 50, 30, 20),
                                generateGroupData(8, 50, 40, 20, 10, 30),
                                generateGroupData(9, 20, 30, 30, 10, 10),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                        height: 5.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: ProjectColors().black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LegendWidget(
                                name: AppLocalizations.of(context)!.sfs_grip,
                                color: _gripColor),
                            LegendWidget(
                                name: AppLocalizations.of(context)!.sfs_pull,
                                color: _pullColor),
                            LegendWidget(
                                name: AppLocalizations.of(context)!
                                    .sfs_horizontal,
                                color: _horizColor),
                            LegendWidget(
                                name: AppLocalizations.of(context)!.sfs_aim,
                                color: _aimColor),
                            LegendWidget(
                                name: AppLocalizations.of(context)!.sfs_shot,
                                color: _shotColor),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      expandedChild: _expandedWidget(),
      previewChild: _previewWidget(),
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;
  Widget _previewWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors().black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              AppLocalizations.of(context)!.stand_by,
              style: _SfsHolsterDrawTextStyles.akhand57,
            ),
          ),
          const CustomBottomBarPlay(),
        ],
      ),
    );
  }

  Widget _expandedWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColors().black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PercentColumn(),
              const _CustomContainerTotalShot(),
              const _MedalContainer(),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  AppLocalizations.of(context)!.improve_your_holster_skills,
                  style: _SfsHolsterDrawTextStyles.built17,
                ),
              ),
              const _CustomListViewBuilder(),
              const CustomBottomBarPlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListViewBuilder extends StatelessWidget {
  const _CustomListViewBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final improveModelList = [
      ImproveModel(
          imgPath: 'assets/images/holster_draw_lw_1.png',
          title: AppLocalizations.of(context)!.improve_your_holster_skills),
      ImproveModel(
          imgPath: 'assets/images/holster_draw_lw_1.png',
          title: AppLocalizations.of(context)!.improve_your_holster_skills),
      ImproveModel(
          imgPath: 'assets/images/holster_draw_lw_1.png',
          title: AppLocalizations.of(context)!.improve_your_holster_skills),
    ];
    return SizedBox(
      height: 30.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: improveModelList.length,
        itemBuilder: (BuildContext context, int index) {
          ImproveModel improve = improveModelList[index];
          return Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:
                          DecorationImage(image: AssetImage(improve.imgPath))),
                ),
                SizedBox(
                  width: 20.w,
                  child: Text(
                    improve.title,
                    style: _SfsHolsterDrawTextStyles.built17w400,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MedalContainer extends StatelessWidget {
  const _MedalContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
          color: const Color(0xff393E46),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50.w,
                  child: Text(
                    AppLocalizations.of(context)!.sfs_train_more,
                    style: _SfsHolsterDrawTextStyles.built17,
                  ),
                ),
                Text(AppLocalizations.of(context)!.badges,
                    style: _SfsHolsterDrawTextStyles.built17Grey),
              ],
            ),
          ),
          Image.asset('assets/images/holster_draw_medal.png')
        ],
      ),
    );
  }
}

class _CustomContainerTotalShot extends StatelessWidget {
  const _CustomContainerTotalShot({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        height: 10.h,
        decoration: BoxDecoration(
            color: const Color(0xff393E46),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.total,
                      style: _SfsHolsterDrawTextStyles.built14),
                  const Text('1,1527', style: _SfsHolsterDrawTextStyles.built17)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('%12,2', style: _SfsHolsterDrawTextStyles.built14),
                  Text(AppLocalizations.of(context)!.better_than_avg,
                      style: _SfsHolsterDrawTextStyles.built17)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PercentColumn extends StatelessWidget {
  const _PercentColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomRowForBottom(
          text: AppLocalizations.of(context)!.sfs_grip,
          containerWidth: 14.w,
          textOfPercent: '0.28',
          icon: const Icon(
            Icons.arrow_drop_down_sharp,
            color: Colors.green,
          ),
        ),
        _CustomRowForBottom(
          text: AppLocalizations.of(context)!.sfs_pull,
          containerWidth: 11.w,
          textOfPercent: '0,22',
          icon: const Icon(
            Icons.adjust,
            color: Color(0xff30445F),
          ),
        ),
        _CustomRowForBottom(
          text: AppLocalizations.of(context)!.sfs_horizontal,
          containerWidth: 23.w,
          textOfPercent: '0.46',
          icon: const Icon(
            Icons.arrow_drop_up_sharp,
            color: Colors.red,
          ),
        ),
        _CustomRowForBottom(
          text: AppLocalizations.of(context)!.sfs_aim,
          containerWidth: 31.w,
          textOfPercent: '0.62',
          icon: const Icon(
            Icons.arrow_drop_down_sharp,
            color: Colors.green,
          ),
        ),
        _CustomRowForBottom(
          text: AppLocalizations.of(context)!.sfs_shot,
          containerWidth: 5.w,
          textOfPercent: '0.10',
          icon: const Icon(
            Icons.arrow_drop_up_sharp,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}

class _CustomRowForBottom extends StatefulWidget {
  const _CustomRowForBottom({
    Key? key,
    required this.text,
    required this.containerWidth,
    required this.textOfPercent,
    required this.icon,
  }) : super(key: key);
  final String text;
  final double containerWidth;
  final String textOfPercent;
  final Icon icon;

  @override
  State<_CustomRowForBottom> createState() => _CustomRowForBottomState();
}

class _CustomRowForBottomState extends State<_CustomRowForBottom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 15.w,
              child: Text(
                widget.text,
                style: _SfsHolsterDrawTextStyles.akhand14,
              ),
            ),
            Container(
              height: 1.h,
              width: widget.containerWidth,
              decoration: BoxDecoration(
                color: const Color(0xff66758D),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              widget.textOfPercent,
              style: _SfsHolsterDrawTextStyles.akhand14,
            ),
            widget.icon
          ],
        )
      ],
    );
  }
}

class _CustomHolsterDrawAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CustomHolsterDrawAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Image.asset('assets/images/holster_draw_app_bar_icon.png'),
      actions: [
        InkWell(
            onTap: () {}, child: Image.asset('assets/images/close_icon.png'))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SfsHolsterDrawTextStyles {
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
  static const TextStyle built17w400 = TextStyle(
      fontFamily: 'Built',
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: Colors.white);
  static const TextStyle built17Grey = TextStyle(
      decoration: TextDecoration.underline,
      fontFamily: 'Built',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Color(0xff66758D));
  static const TextStyle built14 = TextStyle(
      fontFamily: 'Built',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0Xff9CABC2));
}
