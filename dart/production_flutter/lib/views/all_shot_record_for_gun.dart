import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysample/constants/constan_text_styles.dart';
import 'package:mysample/cubit/shot_record_cubit.dart';
import 'package:mysample/entities/shot_record.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';

class AllShotRecordForGun extends StatefulWidget {
  List<ShotRecordModel> shotRecords;
  String? serialNumber;
  String? name;
  String? canikId;
  AllShotRecordForGun({Key? key, required this.shotRecords, this.name, this.serialNumber, this.canikId})
      : super(key: key);
  ShotList temp = ShotList();
  String? selectedPolygons;
  String? resetPolygons;

  ProjectColors projectColors = ProjectColors();

  @override
  State<AllShotRecordForGun> createState() => _AllShotRecordForGun();
}

class _AllShotRecordForGun extends State<AllShotRecordForGun> {
  BuildContext? dialogContext;
  DateTime cuportinoDate = DateTime.now();
  void refresh() {
    setState(() {});
  }

  String calculateToTalShotRecords() {
    int counter = 0;
    for (var e in widget.shotRecords) {
      counter += int.parse(e.numberShots);
    }

    return counter.toString();
  }

  getAllShotRecord() async {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    ShotRecordListRequestModel requestShotRecord =
        ShotRecordListRequestModel(canikId: widget.canikId!, serialNumber: widget.serialNumber!);

    var res = await context
        .read<ShotRecordCubit>()
        .listShotRecords(requestShotRecord)
        .then((value) => widget.shotRecords = value.shotRecords);
    widget.shotRecords.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      cuportinoDate = DateTime.now();
    });
  }

  getAllShotRecordv2() async {
    Navigator.pop(context);
    ShotRecordListRequestModel requestShotRecord =
        ShotRecordListRequestModel(canikId: widget.canikId!, serialNumber: widget.serialNumber!);

    await context
        .read<ShotRecordCubit>()
        .listShotRecords(requestShotRecord)
        .then((value) => widget.shotRecords = value.shotRecords);
    widget.shotRecords.sort((a, b) => b.date.compareTo(a.date));
    setState(() {});
  }

  final TextEditingController shotRecEditingController = TextEditingController();
  final TextEditingController shotCounterTextEditingController = TextEditingController();
  final TextEditingController shotDetailTextEditingController = TextEditingController();
  final TextEditingController shotPolygonTextEditingController = TextEditingController();
  var textStyle = const TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.bold, color: Colors.white);
  var textStyle2 = const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300);
  var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);
  var popUpTitleTextStyle =
      const TextStyle(fontSize: 18, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
  var popUpTextStyle2 = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);

  getSearch(String name) async {
    ShotRecordListRequestModel requestShotRecord =
        ShotRecordListRequestModel(canikId: widget.canikId!, serialNumber: widget.serialNumber!);

    var res = await context.read<ShotRecordCubit>().listShotRecords(requestShotRecord).then((value) => {
          widget.shotRecords =
              value.shotRecords.where((element) => element.polygon.toLowerCase().contains(name.toLowerCase())).toList()
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(text: AppLocalizations.of(context)!.all_shots),
          body: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: projectColors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            dialogContext = context;
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: AlertWithCupertino(popUpTitleTextStyle, popUpTextStyle2, context),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(285, 34),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                              primary: projectColors.blue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.add),
                              Text(
                                AppLocalizations.of(context)!.add_shot_record,
                                style: ProjectTextStyles.built17Bold,
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SizedBox(
                          height: 47,
                          child: TextField(
                            onChanged: (value) async => await getSearch(value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10),
                              alignLabelWithHint: false,
                              fillColor: projectColors.black,
                              filled: false,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55),
                                borderSide: BorderSide(color: projectColors.blue, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55),
                                borderSide: BorderSide(color: projectColors.black3, width: 1),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                              ),
                              prefixIconColor: Colors.white,
                              hintText: AppLocalizations.of(context)!.shot_record_hint,
                              hintStyle:
                                  TextStyle(fontSize: 17, color: projectColors.black3, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          height: 26,
                          color: projectColors.black2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/crosshairs.svg'),
                              Text(
                                ' ${AppLocalizations.of(context)!.shot_count} ',
                                style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                calculateToTalShotRecords(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: widget.shotRecords.length,
                        itemBuilder: (context, index) {
                          var shotRecord = widget.shotRecords[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              height: 41,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SizedBox(
                                        width: 77,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              shotRecord.polygon.length.toInt() < 10
                                                  ? shotRecord.polygon
                                                  : "${shotRecord.polygon.substring(0, 10)}...",
                                              style: TextStyle(
                                                color: projectColors.white1,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              shotRecord.date.substring(0, 10).split('-').reversed.join('.'),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 31,
                                      width: 77,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5), color: projectColors.black),
                                      child: Center(
                                        child: Text(shotRecord.numberShots,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        shotRecEditingController.text = widget.shotRecords[index].recordId;
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                return AlertDialog(
                                                  backgroundColor: ProjectColors().black,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                  title: Text(
                                                    AppLocalizations.of(context)!.general_features,
                                                    style: popUpTitleTextStyle,
                                                  ),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(context)!.name,
                                                        style: textStyle3,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        widget.name!,
                                                        style: popUpTitleTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(context)!.record_number,
                                                        style: textStyle3,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        widget.shotRecords[index].recordId,
                                                        style: popUpTitleTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(context)!.explanation,
                                                        style: textStyle3,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        widget.shotRecords[index].explanation == ""
                                                            ? " - "
                                                            : widget.shotRecords[index].explanation,
                                                        style: popUpTitleTextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: const Color(0xff4F545A),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40),
                                                                      side: const BorderSide(
                                                                          color: Colors.white, width: 1.5),
                                                                    )),
                                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                child: Text(AppLocalizations.of(context)!.close),
                                                              ),
                                                              const SizedBox(
                                                                width: 11,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    primary: projectColors.red,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40),
                                                                    )),
                                                                onPressed: () async {
                                                                  EasyLoading.show(dismissOnTap: false);
                                                                  ShotRecordUpdateRequestModel
                                                                      recordUpdateRequestModel =
                                                                      ShotRecordUpdateRequestModel(
                                                                          date: DateTime.now()
                                                                              .toString()
                                                                              .substring(0, 10),
                                                                          explanation: shotRecord.explanation,
                                                                          isDeleted: true,
                                                                          numberShots: shotRecord.numberShots,
                                                                          polygon: shotRecord.polygon,
                                                                          recordID: shotRecord.recordId);
                                                                  bool res = await context
                                                                      .read<ShotRecordCubit>()
                                                                      .updateShotRecord(recordUpdateRequestModel);
                                                                  if (res == true) {
                                                                    EasyLoading.dismiss();
                                                                    //  Navigator.push(context, MaterialPageRoute(builder: (context){
                                                                    //   return TabBarPage(index: 1,);
                                                                    //  }));
                                                                    await getAllShotRecordv2();
                                                                  } else {
                                                                    Navigator.pop(context);
                                                                  }
                                                                },
                                                                child: Text(AppLocalizations.of(context)!.delete),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              });
                                            });
                                      },
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  AlertDialog AlertWithCupertino(TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(15),
      actionsOverflowButtonSpacing: 10,
      backgroundColor: ProjectColors().black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.choose_date,
            style: popUpTitleTextStyle,
          ),
          Text(
            '1/3',
            style: popUpTextStyle2,
          )
        ],
      ),
      content: SizedBox(
        height: 400,
        width: 315,
        child: CupertinoTheme(
          data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
          child: CupertinoDatePicker(
            initialDateTime: cuportinoDate,
            mode: CupertinoDatePickerMode.date,
            backgroundColor: Colors.transparent,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                cuportinoDate = newDate;
              });
            },
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize:  Size(24.w, 5.h),
                      primary: const Color(0xff4F545A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(color: Colors.white, width: 1.5),
                      )),
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: Text(AppLocalizations.of(context)!.close),
                ),
                 SizedBox(
                  width: 1.w,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(24.w, 5.h),
                      primary: projectColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      )),
                  onPressed: () => {
                    widget.temp.dateTime = cuportinoDate,
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertWithTextfield(popUpTitleTextStyle, popUpTextStyle2, context);
                      },
                    )
                  },
                  child: Text(AppLocalizations.of(context)!.continue_button),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  StatefulBuilder AlertWithTextfield(TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: ProjectColors().black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.shot_count_enter,
                style: popUpTitleTextStyle,
              ),
              Text(
                '2/3',
                style: popUpTextStyle2,
              )
            ],
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.how_many_shot_count,
                      style: TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500)),
                  TextField(
                    onChanged: (value) => setState(() => {}),
                    controller: shotCounterTextEditingController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      counterStyle:const TextStyle(color: Colors.white),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: projectColors.blue),
                      ),
                      hintText: AppLocalizations.of(context)!.shot_count_enter,
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(24.w, 5.h),
                            primary: const Color(0xff4F545A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: const BorderSide(color: Colors.white, width: 1.5),
                            )),
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text(AppLocalizations.of(context)!.back),
                      ),
                       SizedBox(
                        width: 1.w,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(24.w, 5.h),
                            primary: projectColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            )),
                        onPressed: shotCounterTextEditingController.text == ''
                            ? null
                            : () => {
                                  widget.temp.shotCounter = int.parse(shotCounterTextEditingController.text),
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertWithPoligons(popUpTitleTextStyle, popUpTextStyle2, context);
                                    },
                                  ),
                                },
                        child: Text(AppLocalizations.of(context)!.continue_button),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  StatefulBuilder AlertWithPoligons(TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: ProjectColors().black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.shot_details,
                style: popUpTitleTextStyle,
              ),
              Text(
                '3/3',
                style: popUpTextStyle2,
              )
            ],
          ),
          content: SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.shot_record_name,
                    style: TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500)),
                TextField(
                  onChanged: (value) => setState(() => {}),
                  controller: shotPolygonTextEditingController,
                  maxLength: 20,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    counterStyle:const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: projectColors.blue),
                    ),
                    hintText: AppLocalizations.of(context)!.shot_record_hint,
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(AppLocalizations.of(context)!.explanation,
                    style: TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500)),
                TextField(
                  onChanged: (value) => setState(() => {}),
                  maxLength: 50,
                  controller: shotDetailTextEditingController,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    counterStyle:const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: projectColors.blue),
                    ),
                    hintText: AppLocalizations.of(context)!.explanation,
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(24.w, 5.h),
                            primary: const Color(0xff4F545A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: const BorderSide(color: Colors.white, width: 1.5),
                            )),
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text(AppLocalizations.of(context)!.back),
                      ),
                       SizedBox(
                        width: 1.w,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(24.w, 5.h),
                            primary: projectColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            )),
                        onPressed: shotPolygonTextEditingController.text == ''
                            ? null
                            : () async {
                                EasyLoading.show(dismissOnTap: false);

                                ShotRecordAddRequestModel request = ShotRecordAddRequestModel(
                                    serialNumber: widget.serialNumber!,
                                    canikId: widget.canikId!,
                                    polygon: shotPolygonTextEditingController.text,
                                    explanation: shotDetailTextEditingController.text,
                                    numberShots: shotCounterTextEditingController.text,
                                    date: cuportinoDate.toString().substring(0, 10));

                                var res = await context.read<ShotRecordCubit>().addShotRecord(request);
                                if (res.isError == false) {
                                  EasyLoading.dismiss();
                                  await getAllShotRecord();
                                }

                                widget.temp.shotDetailName = widget.selectedPolygons;
                                widget.temp.shotDetailDesc = shotDetailTextEditingController.text;

                                shotPolygonTextEditingController.text = '';
                                shotDetailTextEditingController.text = '';
                                shotCounterTextEditingController.text = '';
                              },
                        child: Text(AppLocalizations.of(context)!.save),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ShotList {
  DateTime? dateTime;
  int? shotCounter;
  String? shotDetailName;
  String? shotDetailDesc;
  ShotList({
    this.dateTime,
    this.shotCounter,
    this.shotDetailName,
    this.shotDetailDesc,
  });
}
