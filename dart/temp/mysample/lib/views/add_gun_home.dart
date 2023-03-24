import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/cubit/weapon_care_cubit.dart';
import 'package:mysample/entities/response/shot_record_response.dart';
import 'package:mysample/entities/response/weapon_care_response.dart';
import 'package:mysample/entities/weapon.dart';
import 'package:mysample/entities/weapon_care.dart';
import 'package:mysample/views/all_weaponcare_for_gun.dart';

import 'package:mysample/widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../cubit/shot_record_cubit.dart';
import '../entities/shot_record.dart';
import '../widgets/app_bar_icon_widget.dart';
import 'all_shot_record_for_gun.dart';

class AddGunHome extends StatefulWidget {
  WeaponToUserGetResponseModel weaponToUserGetResponseModel;

  String? series;
  String subMete = 'TUB9 SUB METE';
  String? selectedPolygons;
  Temp temp = Temp();
  Maintenance maintenance = Maintenance();
  List<Maintenance> maintenances = [];
  AddGunHome({
    Key? key,
    this.series,
    this.selectedPolygons,
    required this.weaponToUserGetResponseModel,
  }) : super(key: key);

  @override
  State<AddGunHome> createState() => _AddGunHomeState();
}

DateTime cuportinoDate = DateTime.now();
DateTime changeDate = DateTime.now();
String editDateText = 'BAKIM TARİHİ';
String partsReplacement = 'BAKIM TİPİ';
List<String> _parts = ['Fabrika seviyesi bakım', 'Atış sonrası bakım', 'Parça değişimi'];

// ShotRecord Update için gereken parametre
String recordId = "";

int _selectedIndex = 0;

bool _doneVisible = false;

String _selectedCareText = '';
late Maintenance maintenance;
String? canikId;
final ProjectColors projectColors = ProjectColors();
String number = "";

@override
class _AddGunHomeState extends State<AddGunHome> {
  final TextEditingController shotCounterTextEditingController = TextEditingController();
  final TextEditingController shotDetailTextEditingController = TextEditingController();
  final TextEditingController seriesTextEditingController = TextEditingController();
  final TextEditingController seriesTextEditingController2 = TextEditingController();
  final TextEditingController seriesTextEditingController3 = TextEditingController();
  final TextEditingController weaponCareTextEditingController4 = TextEditingController();
  BuildContext? dialogContext;
  final TextEditingController shotPolygonTextEditingController = TextEditingController();

  final TextEditingController shotCareExplanationTextController = TextEditingController();

  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('canikId');
  }

  getText() {
    Locale locale = Localizations.localeOf(context);
    String lc = locale.languageCode;
    weaponCareTextEditingController4.text = "";
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
  // getParts(){
  //   Locale locale = Localizations.localeOf(context);
  //   String lc = locale.languageCode;
  //   if(lc == 'tr'){
  //       setState(() {
  //         _parts = ['Fabrika seviyesi bakım', 'Atış sonrası bakım', 'Parça değişimi'];
  //       });
  //   }
  //   else{
  //     setState(() {
  //         _parts = ['Factory Level Maintenance', 'After Shot Maintenance', 'Replacement Parts'];
  //       });
  //   }
  // }

  getAllShotRecord() async {
    await getCanikId().then((value) {
      canikId = value;
      ShotRecordListRequestModel requestShotRecord =
          ShotRecordListRequestModel(canikId: value!, serialNumber: widget.weaponToUserGetResponseModel.serialNumber);
      WeaponCareListRequestModel requestWeaponCare =
          WeaponCareListRequestModel(serialNumber: widget.weaponToUserGetResponseModel.serialNumber, canikId: value);
      context.read<ShotRecordCubit>().listShotRecords(requestShotRecord);
      context.read<WeaponCareCubit>().getAllWeaponCares(requestWeaponCare);
    });
  }

  String calculateToTalShotRecords(List<ShotRecordModel> shotRecords) {
    int counter = 0;

    for (var e in shotRecords) {
      counter += int.parse(e.numberShots);
    }

    return counter.toString();
  }

  @override
  void initState() {
    super.initState();
    getAllShotRecord();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.bold, color: Colors.white);
    const textStyle2 = TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300);
    var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);
    var popUpTitleTextStyle =
        const TextStyle(fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);
    var popUpTextStyle2 = const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
    final ScrollController _scrollController = ScrollController();
    return Stack(
      children: [
        const BackgroundImage(),
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBarWithImage(index: 1, imagePath: 'assets/images/canik_super.png'),
            // appBar:AppBar(actions:[IconButton(onPressed: () => {
            //         Navigator.push(context,MaterialPageRoute(builder: (context) => TabBarPage(index: 0)))}, icon: const Icon(Icons.home,color: Colors.white,size: 30,)),] ) ,
            body: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 37, top: 30),
              child: ListView(children: [
                // SizedBox(
                //   width: 220,
                //   height: 72,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: [
                //       buildListview(),
                //     ],
                //   ),
                // ),

                Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: ProjectColors().black,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: ProjectColors().black,
                        width: 2,
                      ),
                    ),
                    child: widget.weaponToUserGetResponseModel.imageUrl != ''
                        ? Image.network(widget.weaponToUserGetResponseModel.imageUrl)
                        : Image.asset('assets/images/homepage_gun_2.png')),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 82,
                  decoration: BoxDecoration(
                    color: ProjectColors().black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ProjectColors().black,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                            child: Text(
                              widget.weaponToUserGetResponseModel.serialNumber,
                              style: textStyle3,
                            ),
                          ),
                          // Tarih Datası geldiği zaman güncellenecek.
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              widget.weaponToUserGetResponseModel.date != ""
                                  ? widget.weaponToUserGetResponseModel.date.substring(0, 10)
                                  : DateTime.now().toString().substring(0, 10),
                              style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.weaponToUserGetResponseModel.name,
                              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                seriesTextEditingController.text = widget.weaponToUserGetResponseModel.serialNumber;
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
                                                AppLocalizations.of(context)!.serial_number,
                                                style: textStyle3,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                widget.weaponToUserGetResponseModel.serialNumber,
                                                style: popUpTitleTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!.name,
                                                style: textStyle3,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                widget.weaponToUserGetResponseModel.name,
                                                style: popUpTitleTextStyle,
                                              ),
                                            ],
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
                                                            fixedSize: const Size(100, 24),
                                                            primary: const Color(0xff4F545A),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(40),
                                                              side: const BorderSide(color: Colors.white, width: 1.5),
                                                            )),
                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                        child: Text(AppLocalizations.of(context)!.close),
                                                      ),
                                                      // const SizedBox(
                                                      //   width: 11,
                                                      // ),
                                                      // ElevatedButton(
                                                      //   style: ElevatedButton.styleFrom(
                                                      //       fixedSize: const Size(122, 54),
                                                      //       primary: projectColors.blue,
                                                      //       shape: RoundedRectangleBorder(
                                                      //         borderRadius: BorderRadius.circular(40),
                                                      //       )),
                                                      //   onPressed: () => {
                                                      //     Navigator.pop(context, 'Cancel'),
                                                      //   },
                                                      //   child: const Text('GÜNCELLE'),
                                                      // ),
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
                              child: const ImageIcon(
                                AssetImage(
                                  'assets/images/edit.png',
                                ),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ShotRecordCubit, ShotRecordListResponse>(
                  builder: (context, response) {
                    if (response.shotRecords.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ProjectColors().black,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: ProjectColors().black,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Dividers(),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Dividers(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 33.5, right: 33.5, top: 15),
                                child: Text(
                                  AppLocalizations.of(context)!.shot_not_add,
                                  textAlign: TextAlign.center,
                                  style: textStyle2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      dialogContext = context;
                                      Future<String?> x = showDialog<String>(
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
                                          style: textStyle,
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      response.shotRecords.sort((a, b) => b.date.compareTo(a.date));
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ProjectColors().black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          style: textStyle,
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Container(
                                    height: 26,
                                    color: projectColors.black2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/images/crosshairs.svg'),
                                        Text(
                                          ' ${AppLocalizations.of(context)!.shot_count} ',
                                          style: TextStyle(
                                              color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          calculateToTalShotRecords(response.shotRecords),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  child: SizedBox(
                                    height: 100.h < 740
                                        ? 34.h
                                        : 100.h < 780
                                            ? 31.h
                                            : 100.h < 1300
                                                ? 19.h
                                                : 12.h,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: const ScrollPhysics(),
                                      itemCount: response.shotRecords.length < 5 ? response.shotRecords.length : 5,
                                      itemBuilder: (context, index) {
                                        final shotRecord = response.shotRecords[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Container(
                                            height: 41,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5), color: projectColors.black2),
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
                                                            shotRecord.date
                                                                .substring(0, 10)
                                                                .split('-')
                                                                .reversed
                                                                .join('.'),
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
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: projectColors.black),
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
                                                      seriesTextEditingController2.text = shotRecord.recordId;
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return StatefulBuilder(
                                                                builder: (BuildContext context, StateSetter setState) {
                                                              return AlertDialog(
                                                                backgroundColor: ProjectColors().black,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(30)),
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
                                                                      widget.weaponToUserGetResponseModel.name,
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
                                                                      AppLocalizations.of(context)!.explanation == ""
                                                                          ? " - "
                                                                          : AppLocalizations.of(context)!.explanation,
                                                                      style: textStyle3,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text(
                                                                      shotRecord.explanation,
                                                                      style: popUpTitleTextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: <Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                  primary: const Color(0xff4F545A),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(40),
                                                                                    side: const BorderSide(
                                                                                        color: Colors.white,
                                                                                        width: 1.5),
                                                                                  )),
                                                                              onPressed: () =>
                                                                                  Navigator.pop(context, 'Cancel'),
                                                                              child: Text(
                                                                                  AppLocalizations.of(context)!.close),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 11,
                                                                            ),
                                                                            ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                  primary: projectColors.red,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(40),
                                                                                  )),
                                                                              onPressed: () async{
                                                                                EasyLoading.show(dismissOnTap: false);
                                                                                ShotRecordUpdateRequestModel
                                                                                    recordUpdateRequestModel =
                                                                                    ShotRecordUpdateRequestModel(
                                                                                        date: DateTime.now()
                                                                                            .toString()
                                                                                            .substring(0, 10),
                                                                                        explanation:
                                                                                            shotRecord.explanation,
                                                                                        isDeleted: true,
                                                                                        numberShots:
                                                                                            shotRecord.numberShots,
                                                                                        polygon: shotRecord.polygon,
                                                                                        recordID: shotRecord.recordId);
                                                                               await context
                                                                                    .read<ShotRecordCubit>()
                                                                                    .updateShotRecord(
                                                                                        recordUpdateRequestModel)
                                                                                    .then((value) {
                                                                                  if (value == true) {
                                                                                    EasyLoading.dismiss();
                                                                                    getAllShotRecord();
                                                                                  }
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: Text(
                                                                                  AppLocalizations.of(context)!.delete),
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
                                  ),
                                ),
                                Visibility(
                                  visible: response.shotRecords.length > 5,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        response.shotRecords.sort((a, b) => b.date.compareTo(a.date));
                                        return AllShotRecordForGun(
                                          shotRecords: response.shotRecords,
                                          name: widget.weaponToUserGetResponseModel.name,
                                          serialNumber: widget.weaponToUserGetResponseModel.serialNumber,
                                          canikId: canikId,
                                        );
                                      }));
                                    },
                                    child: Text(
                                      '${AppLocalizations.of(context)!.all} (${response.shotRecords.length})',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                // const Padding(
                //   padding: EdgeInsets.only(top: 30.0, bottom: 15),
                //   child: Text(
                //     'AKSESUARLARIM',
                //     style: textStyle,
                //   ),
                // ),
                // Container(
                //   height: 197,
                //   decoration: BoxDecoration(
                //     color: const ProjectColors().black,
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(top: 15.0),
                //         child: Image.asset('assets/images/gunHomeAcc.png'),
                //       ),
                //       const Text(
                //         'Henüz aksesuar eklemediniz',
                //         style: TextStyle(
                //             fontSize: 17,
                //             fontWeight: FontWeight.w300,
                //             color: Colors.white),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(5.0),
                //         child: ElevatedButton(
                //             onPressed: () {
                //               // Navigator.push(
                //               //     context,
                //               //     MaterialPageRoute(
                //               //         builder: (context) =>
                //               //             const CompatibleAcc()));
                //             },
                //             style: ElevatedButton.styleFrom(
                //               fixedSize: const Size(285, 34),
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(40),
                //                   side:
                //                       BorderSide(color: Colors.white, width: 1)),
                //               primary: Colors.transparent,
                //             ),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: const [
                //                 Icon(Icons.add),
                //                 Text(
                //                   'AKSESUAR EKLE',
                //                   style: textStyle,
                //                 ),
                //               ],
                //             )),
                //       )
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    AppLocalizations.of(context)!.maintenance,
                    style: textStyle,
                  ),
                ),
                BlocBuilder<WeaponCareCubit, WeaponCareListResponse>(
                  builder: (context, response) {
                    if (response.weaponCares.isEmpty) {
                      return Container(
                        decoration: BoxDecoration(
                          color: ProjectColors().black,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: ProjectColors().black,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 225,
                              decoration: BoxDecoration(
                                //color: projectColors.black2,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Dividers(),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Dividers(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.maintenance_not_add,
                                      style: textStyle2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          getText();
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                  return weaponCareAlert(textStyle, textStyle3, context,
                                                      popUpTitleTextStyle, popUpTextStyle2, setState, textStyle2);
                                                });
                                              }).then((value) => setState(
                                                () {},
                                              ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(240, 34),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                side: const BorderSide(color: Colors.white, width: 1)),
                                            primary: Colors.transparent),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.add),
                                            Text(
                                              AppLocalizations.of(context)!.maintenance_add,
                                              style: textStyle,
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ProjectColors().black,
                              border: Border.all(color: projectColors.black2, width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    getText();
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                            return weaponCareAlert(textStyle, textStyle3, context, popUpTitleTextStyle,
                                                popUpTextStyle2, setState, textStyle2);
                                          });
                                        }).then((value) => setState(
                                          () {},
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    fixedSize: const Size(285, 34),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: const BorderSide(color: Colors.white, width: 1)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add, color: Colors.white),
                                      Text(AppLocalizations.of(context)!.maintenance_add, style: textStyle)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                                  child: Container(
                                    height: 26,
                                    color: projectColors.black2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/images/crosshairs.svg'),
                                        Text(
                                          ' ${AppLocalizations.of(context)!.maintenance_count} ',
                                          style: TextStyle(
                                              color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          response.weaponCares.length.toString(),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  child: SizedBox(
                                    height: 100.h < 740
                                        ? 34.h
                                        : 100.h < 780
                                            ? 31.h
                                            : 100.h < 1300
                                                ? 19.h
                                                : 12.h,
                                    child: ListView.builder(
                                      physics: const ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: response.weaponCares.length < 5 ? response.weaponCares.length : 5,
                                      itemBuilder: (context, index) {
                                        final weaponCare = response.weaponCares[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(left: 15, right: 15, top: 5.0),
                                          child: Container(
                                            height: 41,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5), color: projectColors.black2),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      weaponCare.careType,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: projectColors.white1,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // Text(
                                                        //   weaponCare.careDate.substring(0, 10).split('-').reversed.join('.'),
                                                        //   style: const TextStyle(
                                                        //     color: Colors.white,
                                                        //     fontSize: 13,
                                                        //     fontWeight: FontWeight.w500,
                                                        //   ),
                                                        // ),
                                                        // const SizedBox(width: 75,),
                                                        // BAKIMPOPUP
                                                        InkWell(
                                                          onTap: () {
                                                            seriesTextEditingController3.text =
                                                                response.weaponCares[index].careType;
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return StatefulBuilder(builder:
                                                                      (BuildContext context, StateSetter setState) {
                                                                    return AlertDialog(
                                                                      backgroundColor: ProjectColors().black,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(30)),
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
                                                                            widget.weaponToUserGetResponseModel.name,
                                                                            style: popUpTitleTextStyle,
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context)!
                                                                                .maintenance_type,
                                                                            style: textStyle3,
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                            response.weaponCares[index].careType,
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
                                                                            response.weaponCares[index].explanation ==
                                                                                    ""
                                                                                ? " - "
                                                                                : response
                                                                                    .weaponCares[index].explanation,
                                                                            style: popUpTitleTextStyle,
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context)!.date,
                                                                            style: textStyle3,
                                                                          ),
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                            response.weaponCares[index].careDate
                                                                                .toString()
                                                                                .substring(0, 10),
                                                                            style: popUpTitleTextStyle,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      actions: <Widget>[
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        primary:
                                                                                            const Color(0xff4F545A),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(40),
                                                                                          side: const BorderSide(
                                                                                              color: Colors.white,
                                                                                              width: 1.5),
                                                                                        )),
                                                                                    onPressed: () => Navigator.pop(
                                                                                        context, 'Cancel'),
                                                                                    child: Text(
                                                                                        AppLocalizations.of(context)!
                                                                                            .close),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 11,
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        primary: projectColors.red,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius:
                                                                                              BorderRadius.circular(40),
                                                                                        )),
                                                                                    onPressed: () {
                                                                                      EasyLoading.show(
                                                                                          dismissOnTap: false);
                                                                                      WeaponCareUpdateRequestModel
                                                                                          request =
                                                                                          WeaponCareUpdateRequestModel(
                                                                                              careDate: response
                                                                                                  .weaponCares[index]
                                                                                                  .careDate,
                                                                                              careType: response
                                                                                                  .weaponCares[index]
                                                                                                  .careType,
                                                                                              explanation: response
                                                                                                  .weaponCares[index]
                                                                                                  .explanation,
                                                                                              recordID: response
                                                                                                  .weaponCares[index]
                                                                                                  .recordId,
                                                                                              isDeleted: true);

                                                                                      context
                                                                                          .read<WeaponCareCubit>()
                                                                                          .updateWeaponCare(request)
                                                                                          .then((value) {
                                                                                        EasyLoading.dismiss();
                                                                                        getAllShotRecord();
                                                                                      });
                                                                                      Navigator.pop(context, 'Cancel');
                                                                                    },
                                                                                    child: Text(
                                                                                        AppLocalizations.of(context)!
                                                                                            .delete),
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // BakımListe Sayfası
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Visibility(
                                    visible: response.weaponCares.length > 5,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AllWeaponCareForGun(
                                                weaponcarelist: response.weaponCares,
                                                canikId: canikId,
                                                serialnumber: widget.weaponToUserGetResponseModel.serialNumber,
                                                name: widget.weaponToUserGetResponseModel.name,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                            '${AppLocalizations.of(context)!.all} (${response.weaponCares.length})',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                )

                // bakım ekledeki verilerin gösterildiği yer
                //
                // widget.maintenances.length > 0
                //     ? Text(
                //         widget.maintenances.first.maintenanceDate.toString() +
                //             widget.maintenances.first.maintenanceDesc.toString() +
                //             widget.maintenances.first.maintenanceType!,
                //         style: popUpTitleTextStyle,
                //       )
                //     : Text(
                //         widget.maintenances.length.toString(),
                //         style: popUpTitleTextStyle,
                //       ),
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //           fixedSize: const Size(285, 54),
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(40),
                //               side: const BorderSide(
                //                   color: Colors.white, width: 1)),
                //           primary: Colors.transparent),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: const [
                //           Text(
                //             'SİLAH DETAYINA GİT',
                //             style: textStyle,
                //           ),
                //           Icon(Icons.keyboard_arrow_right),
                //         ],
                //       )),
                // )
              ]),
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
                        actions: <Widget>[
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
                      setState(
                          () => {widget.maintenance.maintenanceType = "", widget.maintenance.maintenanceDate = null});
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
                                serialNumber: widget.weaponToUserGetResponseModel.serialNumber);

                            var res = await context.read<WeaponCareCubit>().addWeaponCare(request);
                            if (res.isError == false) {
                              EasyLoading.dismiss();
                              weaponCareTextEditingController4.text = "";
                              widget.maintenance.maintenanceDate = null;
                              widget.maintenance.maintenanceType = "";
                              await getAllShotRecord();

                              Navigator.pop(context, 'Cancel');
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
                  dateTimePickerTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500))),
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
                  fixedSize:  Size(24.w, 5.h),
                  primary: projectColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  )),
              onPressed: () => {
                widget.temp.dateTime = cuportinoDate,
                showDialog<String>(
                  context: context,
                  builder: (context) {
                    return AlertWithTextfield(popUpTitleTextStyle, popUpTextStyle2, context);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.how_many_shot_count,
                    style: TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500)),
                TextField(
                  controller: shotCounterTextEditingController,
                  onChanged: (value) => setState(() => {print(value)}),
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          actions: [
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
                            fixedSize:Size(24.w, 5.h),
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
                                    builder: (context) {
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
                  maxLength: 20,
                  controller: shotPolygonTextEditingController,
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
                  maxLength: 50,
                  onChanged: (value) => setState(() => {}),
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
                                    serialNumber: widget.weaponToUserGetResponseModel.serialNumber,
                                    canikId: canikId!,
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
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                setState(() {
                                  shotPolygonTextEditingController.text = '';
                                  shotDetailTextEditingController.text = '';
                                  shotCounterTextEditingController.text = '';
                                });
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

  Widget buildListview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}

class Dividers extends StatelessWidget {
  const Dividers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      width: 225,
      decoration: BoxDecoration(
        color: projectColors.black2,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4.78,
                  width: 52.11,
                  decoration: BoxDecoration(color: projectColors.black3, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 3.18,
                  width: 52.11,
                  decoration: BoxDecoration(color: projectColors.black3, borderRadius: BorderRadius.circular(6)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3.18,
                  width: 36.32,
                  decoration: BoxDecoration(color: projectColors.white1, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 3.18,
                  width: 44.21,
                  decoration: BoxDecoration(color: projectColors.white1, borderRadius: BorderRadius.circular(6)),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Text(
            '...',
            style: TextStyle(fontSize: 16, color: projectColors.black3, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String value) => DropdownMenuItem(
    value: value,
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ));

class Temp {
  DateTime? dateTime;
  int? shotCounter;
  String? shotDetailName;
  String? shotDetailDesc;
  Temp({
    this.dateTime,
    this.shotCounter,
    this.shotDetailName,
    this.shotDetailDesc,
  });
}

class Maintenance {
  String? maintenanceType;
  String? maintenanceDate;
  String? maintenanceDesc;
  Maintenance({
    this.maintenanceType,
    this.maintenanceDate,
    this.maintenanceDesc,
  });
}
