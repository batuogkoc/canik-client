import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/constants/paddings.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/shot_record.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../constants/constan_text_styles.dart';
import '../cubit/all_shot_record_cubit.dart';
import '../cubit/shot_record_cubit.dart';
import '../cubit/weapon_list_cubit.dart';
import '../cubit/weapon_to_user_get_cubit.dart';
import '../entities/response/shot_record_response.dart';
import '../entities/weapon.dart';
import 'package:collection/collection.dart';

class AllShotRecords extends StatefulWidget {
  const AllShotRecords({Key? key}) : super(key: key);

  @override
  State<AllShotRecords> createState() => _AllShotRecordsState();
}

ShotRecordListWithCanikIdResponse shotRecordList =
    ShotRecordListWithCanikIdResponse(isError: false, message: "", shotRecords: []);
final ProjectColors _projectColors = ProjectColors();
final ProjectTextStyles _projectStyles = ProjectTextStyles();

class _AllShotRecordsState extends State<AllShotRecords> {
  BuildContext? dialogContext;
  DateTime? dateTime;
  int? shotCounter;
  String? shotDetailName;
  String? shotDetailDesc;

  final TextEditingController shotCounterTextEditingController = TextEditingController();
  final TextEditingController shotDetailTextEditingController = TextEditingController();
  final TextEditingController shotPolygonTextEditingController = TextEditingController();
  String? selectedPolygons;
  List<String> gunsForUser = ['OTHER'];
  String? selectedGun;

  final popUpTitleTextStyle =
      const TextStyle(fontSize: 18, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
  final popUpTextStyle2 = const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);
  String? canikId;

  getAllShotRecord() async {
    getCanikId().then((value) => context
            .read<AllShotRecordCubit>()
            .listShotRecords(ShotRecordListWithCanikIdRequestModel(canikId: canikId ?? ''))
            .then((value) {
          setState(() {
            shotRecordList = value;
            shotRecordList.shotRecords.sort((a, b) => b.date.compareTo(a.date));
          });
        }));
  }

  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();

    canikId = prefs.getString('canikId');
    return canikId;
  }
  ButtonStyle _addShotRecordButtonStyle() {
    return ElevatedButton.styleFrom(fixedSize: Size(50.w, 5.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), primary: _projectColors.blue);
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCanikId().then((value) => context
            .read<AllShotRecordCubit>()
            .listShotRecords(ShotRecordListWithCanikIdRequestModel(canikId: canikId ?? ''))
            .then((value) {
          setState(() {
            shotRecordList = value;
            shotRecordList.shotRecords.sort((a, b) => b.date.compareTo(a.date));
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          appBar: CustomAppBarWithText(text: AppLocalizations.of(context)!.all_shots),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: ProjectPadding.paddingLRT30,
            child: Container(
              height: height,
              decoration: _blackCircularDecoration(),
              child: BlocBuilder<AllShotRecordCubit,ShotRecordListWithCanikIdResponse>(builder: (context, response) {
                if (response.shotRecords.isNotEmpty) {
                  return _ShotRecordCard(
                      height: height,
                      onPressed: () {
                        dialogContext = context;
                        showDialog<String>(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: AlertWithCupertino(popUpTitleTextStyle, popUpTextStyle2, context),
                            );
                          },
                        );
                      },
                      allShotRecords: response);
                  
                }
                else{
                 return Center(
                   child: ElevatedButton(
              onPressed: () {
                          dialogContext = context;
                          showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: AlertWithCupertino(popUpTitleTextStyle, popUpTextStyle2, context),
                              );
                            },
                          );
                        },
              child: Padding(
                padding: _ShotRecordPadding().buttonPadding,
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
                ),
              ),
              style: _addShotRecordButtonStyle(),
            ),
                 );
                }
              },
            )
              
              // shotRecordList.shotRecords.isNotEmpty
              //     ? _ShotRecordCard(
              //         height: height,
              //         onPressed: () {
              //           dialogContext = context;
              //           showDialog<String>(
              //             barrierDismissible: false,
              //             context: context,
              //             builder: (BuildContext context) {
              //               return Padding(
              //                 padding: const EdgeInsets.all(30.0),
              //                 child: AlertWithCupertino(popUpTitleTextStyle, popUpTextStyle2, context),
              //               );
              //             },
              //           );
              //         },
              //         allShotRecords: shotRecordList)
              //     : const Center(),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration _blackCircularDecoration() {
    return BoxDecoration(
      color: _projectColors.black,
      borderRadius: BorderRadius.circular(15),
    );
  }

  AlertDialog AlertWithCupertino(TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(15),
      actionsOverflowButtonSpacing: 10,
      backgroundColor: projectColors.black,
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
      actions: <Widget>[
        Row(
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
              onPressed: () => Navigator.pop(context, AppLocalizations.of(context)!.close),
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
                dateTime = cuportinoDate,
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: AlertWithTextfield(popUpTitleTextStyle, popUpTextStyle2, context));
                  },
                )
              },
              child: Text(AppLocalizations.of(context)!.continue_button),
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
          backgroundColor: projectColors.black,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.how_many_shot_count,
                    style: TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500)),
                TextFormField(
                  onChanged: (text) => setState(() => {}),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: shotCounterTextEditingController,
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
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<WeaponListCubit, WeaponToUserListResponse>(
                  builder: (context, response) {
                    if (response.weaponToUsers.isEmpty) {
                      return DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: selectedGun,
                        onChanged: (String? newValue) => setState(() => {
                              selectedGun = newValue!,
                            }),
                        isExpanded: true,
                        hint: Text(AppLocalizations.of(context)!.choose_weapon,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                        iconSize: 24,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        items: gunsForUser.map(buildMenuItem).toList(),
                      );
                    } else {
                      var weaponToUser = response.weaponToUsers.map<String>((e) => e.serialNumber).toList();
                      return DropdownButton<String>(
                        dropdownColor: Colors.black,
                        value: selectedGun,
                        onChanged: (String? newValue) => setState(() => {
                              selectedGun = newValue!,
                            }),
                        isExpanded: true,
                        hint: Text(AppLocalizations.of(context)!.choose_weapon,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                        iconSize: 24,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        items: weaponToUser.map(buildMenuItem).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
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
                        onPressed:
                            shotCounterTextEditingController.text == "" || (selectedGun == null || selectedGun == "")
                                ? null
                                : () {
                                    showDialog<String>(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertWithPoligons(popUpTitleTextStyle, popUpTextStyle2, context);
                                      },
                                    );
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
          backgroundColor: projectColors.black,
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
                  onChanged: (text) => setState(() => {}),
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
                  onChanged: (text) => setState(() => {}),
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
          actions: <Widget>[
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
                        onPressed: shotPolygonTextEditingController.text == ""
                            ? null
                            : () async {
                                EasyLoading.show(dismissOnTap: false);

                                ShotRecordAddRequestModel request = ShotRecordAddRequestModel(
                                    serialNumber: selectedGun ?? '',
                                    canikId: canikId ?? '',
                                    polygon: shotPolygonTextEditingController.text,
                                    explanation: shotDetailTextEditingController.text,
                                    numberShots: shotCounterTextEditingController.text,
                                    date: cuportinoDate.toString().substring(0, 10));
                                var res = await context.read<ShotRecordCubit>().addShotRecord(request);

                                shotDetailName = shotPolygonTextEditingController.text;
                                shotDetailDesc = shotDetailTextEditingController.text;

                                cuportinoDate = DateTime.now();
                                shotCounterTextEditingController.text = '';
                                shotDetailTextEditingController.text = '';
                                shotPolygonTextEditingController.text = '';
                                selectedGun = null;
                                // widget.selectedPolygons = widget.resetPolygons,

                                if (res.isError == false) {
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await getAllShotRecord();
                                } else {
                                  EasyLoading.dismiss();
                                }
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

class _ShotRecordCard extends StatefulWidget {
  _ShotRecordCard({
    Key? key,
    required this.height,
    required this.onPressed,
    required this.allShotRecords,
  }) : super(key: key);
  final double height;
  final void Function() onPressed;
  ShotRecordListWithCanikIdResponse allShotRecords;
  @override
  State<_ShotRecordCard> createState() => _ShotRecordCardState();
}

class _ShotRecordCardState extends State<_ShotRecordCard> {
  String? canikId;
  List<ShotRecordSummaryModel> modallist = [];
  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();
    canikId = prefs.getString('canikId');
    return canikId;
  }

  Future<List<ShotRecordSummaryModel>> mapRecords(ShotRecordListWithCanikIdResponse response) async {
    modallist = [];
    ShotRecordSummaryModel modal;
    var datas = response.shotRecords.groupListsBy((element) => element.serialNumber);
    int itaretion = -1;
    datas.forEach((key, value) {
      for (var element in value) {
        modal = ShotRecordSummaryModel(
            numberShots: element.numberShots, serialNumber: element.serialNumber, name: element.serialNumber);
        if (modallist.where((element) => element.serialNumber == modal.serialNumber).isNotEmpty) {
          int? num1 = int.tryParse(modal.numberShots)!;
          int? num2 = int.tryParse(modallist[itaretion].numberShots);
          int sum = num1 + num2!;
          modallist[itaretion].numberShots = sum.toString();
        } else {
          modallist.add(modal);
          itaretion++;
        }
      }
    });

    for (var element in modallist) {
      WeaponNameGetRequestModel modelName = WeaponNameGetRequestModel(serialNumber: element.serialNumber);
      await context
          .read<WeaponToUserGetCubit>()
          .getWeaponName(modelName)
          .then((value) => element.name = value.result.first.name);
    }

    setState(() {});

    return modallist;
  }

  getAllShotRecord() async {
    getCanikId().then((value) => context
            .read<AllShotRecordCubit>()
            .listShotRecords(ShotRecordListWithCanikIdRequestModel(canikId: canikId ?? ''))
            .then((value) {
          setState(() {
            value.shotRecords.sort((a, b) => b.date.compareTo(a.date),);
            widget.allShotRecords = value;
          });
        }));
  }

  String calculateToTalShotRecords(List shots) {
    int counter = 0;
    for (var e in shots) {
      counter += int.parse(e.numberShots);
    }

    return counter.toString();
  }

  Future<WeaponNameGetResponse> convertSerialNumberToGunName(String serialNumber) async {
    return context.read<WeaponToUserGetCubit>().getWeaponName(WeaponNameGetRequestModel(serialNumber: serialNumber));
  }

  @override
  void initState() {
    super.initState();

    getCanikId().then((value) {
      context.read<AllShotRecordCubit>().listShotRecords(ShotRecordListWithCanikIdRequestModel(canikId: canikId ?? ''));
      context.read<WeaponListCubit>().getAllWeaponToUsers(WeaponToUserListRequestModel(canikId: canikId ?? ''));
    });
  }

  String shotCount = '';
  String gunName = '';
  String? selectedGun;
  final popUpTitleTextStyle =
      const TextStyle(fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
  final popUpTextStyle2 = const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
  var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    const double _textfieldHeight = 47;
    const double _shotCounterHeight = 26;
    const double _heightOfContainer = 85.0;
    return Padding(
      padding: ProjectPadding.paddingAll15,
      child: SizedBox(
        height: widget.height,
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: widget.onPressed,
              child: Padding(
                padding: _ShotRecordPadding().buttonPadding,
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
                ),
              ),
              style: _addShotRecordButtonStyle(),
            ),

            //   Padding(
            //   padding: _ShotRecordPadding().shotCounterPadding,
            //   child: GestureDetector
            //   (
            //     onTap: () async{
            //         EasyLoading.show(dismissOnTap: false);
            //         await mapRecords(widget.allShotRecords);
            //         EasyLoading.dismiss();
            //         showDialog<String>(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return Padding(
            //             padding: const EdgeInsets.all(30.0),
            //             child: WeaponShotPopup(popUpTitleTextStyle, popUpTextStyle2, context,modallist),
            //           );
            //         },
            //       );
            //     },
            //     child: _totalShotCounterContainer(_shotCounterHeight, context,
            //     shotCount != "" ? shotCount : calculateToTalShotRecords(widget.allShotRecords.shotRecords),
            //     widget.allShotRecords,)),
            // ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.all(0),
                child: ExpansionTile(
                  title: _totalShotCounterContainer(
                    _shotCounterHeight,
                    context,
                    shotCount != "" ? shotCount : calculateToTalShotRecords(widget.allShotRecords.shotRecords),
                    widget.allShotRecords,
                  ),
                  collapsedBackgroundColor: projectColors.black2,
                  backgroundColor: projectColors.black2,
                  iconColor: projectColors.blue,
                  collapsedIconColor: projectColors.blue,
                  controlAffinity: ListTileControlAffinity.trailing,
                  onExpansionChanged: (value) async {
                    if (value) {
                      EasyLoading.show(dismissOnTap: false);
                      await mapRecords(widget.allShotRecords);
                      EasyLoading.dismiss();
                    } else {
                      setState(() {
                        modallist = [];
                      });
                    }
                  },
                  initiallyExpanded: false,
                  children: [
                    SizedBox(
                      height: modallist.isEmpty ? 64.0 : modallist.length * 64.0,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: modallist.length,
                        itemBuilder: (context, index) {
                          var shotRecord = modallist[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              height: 60,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black2),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                shotRecord.serialNumber,
                                                style: TextStyle(
                                                  color: projectColors.white1,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                shotRecord.name.length.toInt() < 10
                                                    ? shotRecord.name
                                                    : '${shotRecord.name.substring(0, 10)}...',
                                                style: TextStyle(
                                                  color: projectColors.white1,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
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
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: projectColors.black3,
                                      thickness: 1.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: widget.allShotRecords.shotRecords.length,
              itemBuilder: (context, index) {
                var shotRecord = widget.allShotRecords.shotRecords[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black2),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text(
                                  shotRecord.serialNumber,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 31,
                            width: 77,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black),
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
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        backgroundColor: ProjectColors().black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                                              shotRecord.serialNumber,
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
                                              shotRecord.recordId,
                                              style: popUpTitleTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.shot_record_name,
                                              style: textStyle3,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              shotRecord.polygon,
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
                                              shotRecord.explanation == "" ? " - " : shotRecord.explanation,
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
                                                            side: const BorderSide(color: Colors.white, width: 1.5),
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
                                                        ShotRecordUpdateRequestModel recordUpdateRequestModel =
                                                            ShotRecordUpdateRequestModel(
                                                                date: DateTime.now().toString().substring(0, 10),
                                                                explanation: shotRecord.explanation,
                                                                isDeleted: true,
                                                                numberShots: shotRecord.numberShots,
                                                                polygon: shotRecord.polygon,
                                                                recordID: shotRecord.recordId);
                                                        await context
                                                            .read<ShotRecordCubit>()
                                                            .updateShotRecord(recordUpdateRequestModel)
                                                            .then((value) {
                                                          if (value == true) {
                                                            EasyLoading.dismiss();
                                                            getAllShotRecord();
                                                            Navigator.pop(context);
                                                          } else {
                                                            EasyLoading.dismiss();
                                                            Navigator.pop(context);
                                                          }
                                                        });
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
                                  }).then((value) => setState(() {}));
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
            ),
          ],
        ),
      ),
    );
  }

  Container _totalShotCounterContainer(double _shotCounterHeight, BuildContext context, String shotCount,
      ShotRecordListWithCanikIdResponse shotRecords) {
    return Container(
      height: _shotCounterHeight,
      color: projectColors.black2,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset('assets/images/crosshairs.svg'),
        Text(
          ' ${AppLocalizations.of(context)!.shot_count} ',
          style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500),
        ),
        Text(
          shotCount,
          style: ProjectTextStyles.bold20,
        ),
      ]),
    );
  }

  AlertDialog WeaponShotPopup(TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, BuildContext context,
      List<ShotRecordSummaryModel> response) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(5),
      contentPadding: const EdgeInsets.all(5),
      actionsOverflowButtonSpacing: 10,
      backgroundColor: projectColors.black,
      title: Center(
          child: Text(
        AppLocalizations.of(context)!.weapon_shot_summary,
        style: const TextStyle(color: Colors.white),
      )),
      content: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemCount: response.length,
                itemBuilder: (context, index) {
                  final shotRecord = response[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      height: 41,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black2),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shotRecord.serialNumber,
                                    style: TextStyle(
                                      color: projectColors.white1,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    shotRecord.name,
                                    style: TextStyle(
                                      color: projectColors.white1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 31,
                              width: 77,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(5), color: projectColors.black),
                              child: Center(
                                child: Text(shotRecord.numberShots,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 27),
                primary: const Color(0xff4F545A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: const BorderSide(color: Colors.white, width: 1.5),
                )),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ),
      ],
    );
  }

  TextField _shotRecordTextfield(String hintText) {
    return TextField(
      style: TextStyle(color: _projectColors.white),
      decoration: InputDecoration(
        contentPadding: _ShotRecordPadding().textFieldContentPadding,
        alignLabelWithHint: false,
        fillColor: _projectColors.black,
        filled: false,
        focusedBorder: outlineBorderBlue(),
        enabledBorder: _outlineBorderBlack(),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.white,
        ),
        prefixIconColor: Colors.white,
        hintText: hintText,
        hintStyle: _projectStyles.black17bold,
      ),
    );
  }

  OutlineInputBorder outlineBorderBlue() {
    return OutlineInputBorder(
      borderRadius: _ShotRecordsBorder().borderRadius55,
      borderSide: _ShotRecordsBorder().borderSideBlue,
    );
  }

  OutlineInputBorder _outlineBorderBlack() {
    return OutlineInputBorder(
      borderRadius: _ShotRecordsBorder().borderRadius55,
      borderSide: _ShotRecordsBorder().borderSideBlack3,
    );
  }

  ButtonStyle _addShotRecordButtonStyle() {
    return ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), primary: _projectColors.blue);
  }
}

class _ShotRecordPadding {
  final buttonPadding = const EdgeInsets.symmetric(vertical: 8.0);
  final textFieldContentPadding = const EdgeInsets.only(top: 10);
  final shotCounterPadding = const EdgeInsets.symmetric(vertical: 15);
  final shotBottomPadding10 = const EdgeInsets.only(bottom: 10);
  final shotBottomPadding15 = const EdgeInsets.only(bottom: 15);
}

class _ShotRecordsBorder {
  final borderRadius55 = BorderRadius.circular(55);
  final borderSideBlack3 = BorderSide(color: _projectColors.black3, width: 1);
  final borderSideBlue = BorderSide(color: _projectColors.blue, width: 1);
}
