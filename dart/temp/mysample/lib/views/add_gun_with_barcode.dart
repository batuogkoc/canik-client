import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/cubit/weapon_list_cubit.dart';
import 'package:mysample/entities/weapon.dart';
import 'package:mysample/product/utility/image_paths/image_path.dart';
import 'package:mysample/views/add_gun_properties.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:kartal/kartal.dart';
import '../cubit/weapon_to_user_get_cubit.dart';

class AddGunB extends StatefulWidget {
  String? barcode;

  AddGunB({Key? key, this.barcode}) : super(key: key);
  @override
  State<AddGunB> createState() => _AddGunBState();
}

Future<String?> getCanikId() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('canikId');
}

class _AddGunBState extends State<AddGunB> {
  bool isVisibleOfValidationMessage = false;
  bool isVisibleAvailable = false;
  ProjectColors projectColors = ProjectColors();
  String? canikId;
  static final _textSize = 14.sp;
  @override
  void initState() {
    super.initState();
    getCanikId().then((canikIdValue) => canikId = canikIdValue);
  }

  @override
  Widget build(BuildContext context) {
    String available = AppLocalizations.of(context)!.gun_available_inventory;
    String errorMessage = AppLocalizations.of(context)!.add_gun_error_message;
    String value = 'T6472 - ';
    TextEditingController _series = TextEditingController()
      ..text = widget.barcode == null ? value : widget.barcode!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: projectColors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              // margin: const EdgeInsets.only(top: 21, left: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.serial_number,
                    style: TextStyle(
                        color: projectColors.blue,
                        fontSize: _textSize,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _series,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: _textSize,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: projectColors.black2),
                            ),
                            hintText: ' 20 AB 12345',
                            hintStyle: TextStyle(
                                fontSize: _textSize,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xff9BACB3)),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BarcodePageView()));
                      //     },
                      //     child: Container(
                      //       height: 40,
                      //       width: 40,
                      //       child: Image.asset('assets/images/barcode-read.png'),
                      //       decoration: BoxDecoration(
                      //         color: projectColors.blue,
                      //         borderRadius: BorderRadius.circular(7),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
                visible: isVisibleAvailable,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(available,
                      style: TextStyle(color: Colors.red, fontSize: _textSize)),
                )),
            Visibility(
              visible: isVisibleOfValidationMessage,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: _textSize)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                height: 10.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: projectColors.black2,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Icon(
                          Icons.warning,
                          color: projectColors.blue,
                          size: 5.h,
                        ),
                      ),
                      context.emptySizedWidthBoxLow,
                      Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              AppLocalizations.of(context)!.add_gun_barcode_text,
                              style: TextStyle(
                                  fontSize: _textSize, fontWeight: FontWeight.normal)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3.h, left: 40),
              height: 40.h,
              width: 40.w,
              child: const FittedBox(
                  child: AssetImageWidget(imagePath: ImagePath.addGun)),
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
                onPressed: () {
                  context
                      .read<WeaponListCubit>()
                      .getAllWeaponToUsers(
                          WeaponToUserListRequestModel(canikId: canikId ?? ''))
                      .then((value) {
                    var res = value.weaponToUsers.where(
                        (element) => element.serialNumber == _series.text);
                    if (res.isNotEmpty) {
                      setState(() {
                        isVisibleAvailable = true;
                        isVisibleOfValidationMessage = false;
                      });
                    } else {
                      context
                          .read<WeaponToUserGetCubit>()
                          .getWeaponName(WeaponNameGetRequestModel(
                              serialNumber: _series.text))
                          .then((value) {
                        if (value.result.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GunProperties(
                                series: _series.text,
                                weaponName: value.result.first,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            isVisibleOfValidationMessage = true;
                            isVisibleAvailable = false;
                          });
                        }
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    primary: projectColors.blue),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.verify,
                            style: TextStyle(
                                fontSize: _textSize,
                                fontFamily: 'Built',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
