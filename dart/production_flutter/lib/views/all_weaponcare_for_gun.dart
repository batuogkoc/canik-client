import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mysample/constants/constan_text_styles.dart';
import 'package:mysample/cubit/shot_record_cubit.dart';
import 'package:mysample/cubit/weapon_care_cubit.dart';
import 'package:mysample/cubit/weapon_to_user_get_cubit.dart';
import 'package:mysample/entities/response/shot_record_response.dart';
import 'package:mysample/entities/shot_record.dart';
import 'package:mysample/entities/weapon_care.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/gun_home_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import '../entities/response/weapon_to_user_response.dart';
import '../entities/weapon.dart';

class AllWeaponCareForGun extends StatefulWidget {
  List<WeaponCareListResponseModel> weaponcarelist;
  String? serialnumber;
  String? canikId;
  String? name;
  AllWeaponCareForGun({Key? key, this.name, required this.weaponcarelist, this.serialnumber, this.canikId})
      : super(key: key);
  ShotList temp = ShotList();
  String? selectedPolygons;
  String? resetPolygons;

  Maintenance maintenance = Maintenance();
  ProjectColors projectColors = ProjectColors();

  @override
  State<AllWeaponCareForGun> createState() => _AllWeaponCareForGun();
}

class _AllWeaponCareForGun extends State<AllWeaponCareForGun> {
  DateTime changeDate = DateTime.now();
  BuildContext? dialogContext;
  int _selectedIndex = 0;
  DateTime cuportinoDate = DateTime.now();
  String _selectedCareText = '';
  bool _doneVisible = false;
  String editDateText = 'BAKIM TARİHİ';
  String partsReplacement = 'BAKIM TİPİ';
  List<String> _parts = ['Fabrika seviyesi bakım', 'Atış sonrası bakım', 'Parça değişimi'];
  getSearch(String name) async {
    WeaponCareListRequestModel requestWeaponCare =
        WeaponCareListRequestModel(serialNumber: widget.serialnumber!, canikId: widget.canikId!);

    var res = await context.read<WeaponCareCubit>().getAllWeaponCares(requestWeaponCare).then((value) => {
          widget.weaponcarelist =
              value.weaponCares.where((element) => element.careType.toLowerCase().contains(name.toLowerCase())).toList()
        });
    setState(() {});
  }

  getText() {
    Locale locale = Localizations.localeOf(context);
    String lc = locale.languageCode;
    weaponCareTextEditingController4.text = '';
    if (lc == 'tr') {
      setState(() {
        editDateText = "BAKIM TARİHİ";
        partsReplacement = "BAKIM TİPİ";
        _parts = ['Fabrika seviyesi bakım', 'Atış sonrası bakım', 'Parça değişimi'];
      });
    } else {
      setState(() {
        editDateText = "MAINTENANCE DATE";
        partsReplacement = "MAINTENANCE TYPE";
        _parts = ['Factory Level Maintenance', 'After Shot Maintenance', 'Replacement Parts'];
      });
    }
  }

  void refresh() {
    setState(() {});
  }

  getAllWeaponCareRecord() async {
    Navigator.pop(context);
    weaponCareTextEditingController4.text = '';
    WeaponCareListRequestModel requestWeaponCare =
        WeaponCareListRequestModel(serialNumber: widget.serialnumber!, canikId: widget.canikId!);

    var res = await context
        .read<WeaponCareCubit>()
        .getAllWeaponCares(requestWeaponCare)
        .then((value) => {widget.weaponcarelist = value.weaponCares});
    setState(() {});
  }

  String calculateToTalShotRecords() {
    int counter = 0;
    counter = widget.weaponcarelist.length;

    return counter.toString();
  }

  final TextEditingController shotRecEditingController = TextEditingController();
  final TextEditingController shotCounterTextEditingController = TextEditingController();
  final TextEditingController shotDetailTextEditingController = TextEditingController();
  final TextEditingController shotPolygonTextEditingController = TextEditingController();
  final TextEditingController shotCareExplanationTextController = TextEditingController();
  final TextEditingController weaponCareTextEditingController4 = TextEditingController();
  var textStyle = const TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.bold, color: Colors.white);
  var textStyle2 = const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300);
  var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);
  var popUpTitleTextStyle =
      const TextStyle(fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
  var popUpTextStyle2 = const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(text: AppLocalizations.of(context)!.maintenance_all),
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
                            getText();
                            dialogContext = context;
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                  return weaponCareAlert(textStyle, textStyle3, context, popUpTitleTextStyle,
                                      popUpTextStyle2, setState, textStyle2);
                                });
                              },
                            ).then((value) => setState(
                                  () {},
                                ));
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
                                AppLocalizations.of(context)!.maintenance_add,
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
                              hintText: AppLocalizations.of(context)!.maintenance_search_hint,
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
                                ' ${AppLocalizations.of(context)!.maintenance_count} ',
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
                        itemCount: widget.weaponcarelist.length,
                        itemBuilder: (context, index) {
                          var weaponCare = widget.weaponcarelist[index];

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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            weaponCare.careType,
                                            style: TextStyle(
                                              color: projectColors.white1,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            weaponCare.careDate.substring(0, 10).split('-').reversed.join('.'),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   height: 31,
                                    //   width: 77,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(5), color: projectColors.black),
                                    //   child: Center(
                                    //     child: Text(weaponCare.,
                                    //         style: const TextStyle(
                                    //           fontSize: 14,
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.bold,
                                    //         )),
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        shotRecEditingController.text = widget.weaponcarelist[index].recordId;
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
                                                        AppLocalizations.of(context)!.maintenance_type,
                                                        style: textStyle3,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        widget.weaponcarelist[index].careType,
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
                                                        widget.weaponcarelist[index].recordId,
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
                                                        widget.weaponcarelist[index].explanation == ""
                                                            ? " - "
                                                            : widget.weaponcarelist[index].explanation,
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
                                                                    fixedSize:  Size(24.w, 5.h),
                                                                    primary: const Color(0xff4F545A),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40),
                                                                      side: const BorderSide(
                                                                          color: Colors.white, width: 1.5),
                                                                    )),
                                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                child: Text(AppLocalizations.of(context)!.close),
                                                              ),
                                                               SizedBox(
                                                                width: 1.w,
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    fixedSize:  Size(24.w, 5.h),
                                                                    primary: projectColors.red,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(40),
                                                                    )),
                                                                onPressed: () async {
                                                                  EasyLoading.show(dismissOnTap: false);
                                                                  WeaponCareUpdateRequestModel request =
                                                                      WeaponCareUpdateRequestModel(
                                                                          careDate:
                                                                              widget.weaponcarelist[index].careDate,
                                                                          careType:
                                                                              widget.weaponcarelist[index].careType,
                                                                          explanation:
                                                                              widget.weaponcarelist[index].explanation,
                                                                          recordID:
                                                                              widget.weaponcarelist[index].recordId,
                                                                          isDeleted: true);

                                                                  bool res = await context
                                                                      .read<WeaponCareCubit>()
                                                                      .updateWeaponCare(request);
                                                                  if (res == true) {
                                                                    EasyLoading.dismiss();
                                                                    // Navigator.push(context, MaterialPageRoute(builder: (context){
                                                                    //   return TabBarPage(index: 1);
                                                                    // }));
                                                                    await getAllWeaponCareRecord();
                                                                  } else {
                                                                    Navigator.pop(context, 'Cancel');
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

  AlertDialog weaponCareAlert(TextStyle textStyle, TextStyle textStyle3, BuildContext context,
      TextStyle popUpTitleTextStyle, TextStyle popUpTextStyle2, StateSetter setState, TextStyle textStyle2) {
    return AlertDialog(
      backgroundColor: ProjectColors().black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        AppLocalizations.of(context)!.maintenance_add,
        style: textStyle,
      ),
      content: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.maintenance_type,
              style: textStyle3,
            ),
            InkWell(
              onTap: (() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: ProjectColors().black,
                          title: Center(
                            child: Text(
                              AppLocalizations.of(context)!.maintenance_types,
                              style: popUpTitleTextStyle,
                            ),
                          ),
                          content: SizedBox(
                            height: 300,
                            width: 300,
                            child: ListView.builder(
                                physics: const ScrollPhysics(),
                                itemCount: _parts.length,
                                itemBuilder: ((context, index) => ListTile(
                                      title: Text(
                                        _parts[index],
                                        style: popUpTextStyle2,
                                      ),
                                      selected: index == _selectedIndex,
                                      trailing: Visibility(visible: _doneVisible, child: const Icon(Icons.done)),
                                      onTap: () {
                                        setState(
                                          () {
                                            _selectedCareText = _parts[index];
                                            _selectedIndex = index;
                                            _doneVisible = true;
                                          },
                                        );
                                      },
                                    ))),
                          ),
                          actions: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.close,
                                      style: const TextStyle(color: Colors.white),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          partsReplacement = _selectedCareText;
                                          widget.maintenance.maintenanceType = partsReplacement;
                                        },
                                      );
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: Text(AppLocalizations.of(context)!.complete))
                              ],
                            )
                          ],
                        );
                      });
                    }).then((value) => setState(
                      () {},
                    ));
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partsReplacement,
                    style: textStyle2,
                  ),
                  const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Text(AppLocalizations.of(context)!.maintenance_date, style: textStyle3),
            InkWell(
              onTap: (() {
                showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: ProjectColors().black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: SizedBox(
                          height: 180,
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle:
                                        TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500))),
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                              backgroundColor: Colors.transparent,
                              use24hFormat: true,
                              onDateTimeChanged: (DateTime newDate) {
                                changeDate = newDate;
                              },
                            ),
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
                                          fixedSize:  Size(24.w, 5.h),
                                          primary: const Color(0xff4F545A),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            side: const BorderSide(color: Colors.white, width: 1.5),
                                          )),
                                      onPressed: () {
                                        Navigator.pop(context, 'Cancel');
                                      },
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
                                        setState(() {
                                          editDateText = DateFormat('yyyy-MM-dd').format(changeDate);
                                          widget.maintenance.maintenanceDate = editDateText;
                                        }),
                                        Navigator.pop(context, 'Cancel'),
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
                    }).then((value) => setState(() {}));
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    editDateText,
                    style: textStyle2,
                  ),
                  const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Text(AppLocalizations.of(context)!.explanation_short, style: textStyle3),
            TextField(
              maxLength: 50,
              onChanged: (value) => setState(() => {}),
              controller: weaponCareTextEditingController4,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                counterStyle:const TextStyle(color: Colors.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: projectColors.blue),
                ),
                hintText: AppLocalizations.of(context)!.explanation_short,
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
                        fixedSize: const Size(100, 27),
                        primary: const Color(0xff4F545A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(color: Colors.white, width: 1.5),
                        )),
                    onPressed: () {
                      setState(
                          () => {widget.maintenance.maintenanceType = "", widget.maintenance.maintenanceDate = null});
                      Navigator.pop(context, 'Cancel');
                    },
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 27),
                        primary: projectColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        )),
                    onPressed: widget.maintenance.maintenanceDate == null ||
                            (widget.maintenance.maintenanceType == null || widget.maintenance.maintenanceType == "")
                        ? null
                        : () async {
                            EasyLoading.show(dismissOnTap: false);

                            WeaponCareAddRequestModel request = WeaponCareAddRequestModel(
                                careDate: widget.maintenance.maintenanceDate!.toString().substring(0, 10),
                                careType: widget.maintenance.maintenanceType!,
                                explanation: weaponCareTextEditingController4.text,
                                canikId: canikId!,
                                serialNumber: widget.serialnumber!);
                            var res = await context.read<WeaponCareCubit>().addWeaponCare(request);
                            if (res.isError == false) {
                              EasyLoading.dismiss();

                              widget.maintenance.maintenanceDate = null;
                              widget.maintenance.maintenanceType = "";
                              await getAllWeaponCareRecord();
                            }
                          },
                    child: Text(AppLocalizations.of(context)!.complete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
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
