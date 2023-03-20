import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/cubit/weapon_to_user_get_cubit.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/user_info.dart';
import 'package:mysample/entities/weapon.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/gun_home_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/user_info_cubit.dart';
import '../cubit/weapon_add_cubit.dart';

class GunProperties extends StatefulWidget {
  String series;
  WeaponNameGetResponseModel weaponName;

  String? selectColor;
  GunProperties({Key? key, required this.series, required this.weaponName})
      : super(key: key);

  @override
  State<GunProperties> createState() => _GunPropertiesState();
}

class _GunPropertiesState extends State<GunProperties> {
  String canikId = '';
  final textStyle = TextStyle(
    fontSize: 12,
    color: projectColors.white1,
    fontWeight: FontWeight.w500,
  );
  final underTextStyle = const TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  getCanikId() async {
    final prefs = await SharedPreferences.getInstance();
    String? canikIdTemp = prefs.getString('canikId');
    canikId = canikIdTemp!;
  }

  Future<WeaponToUserAddResponse> addGun() {
    var request = WeaponToUserAddRequestModel(
      canikId: canikId,
      serialNumber: widget.series,
      name: widget.weaponName.name,
    );
    return context.read<WeaponAddCubit>().addWeaponToUser(request);
  }

  @override
  void initState() {
    super.initState();
    getCanikId();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(left: 45.0, right: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.serial_number,
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.series,
                    style: underTextStyle,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1.0, height: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    AppLocalizations.of(context)!.name,
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.weaponName.name,
                    style: underTextStyle,
                  ),
                ),
                const Divider(color: Colors.white, thickness: 1.0, height: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 164.0),
                  child: ElevatedButton(
                      onPressed: () {
                        EasyLoading.show(dismissOnTap: false);
                        addGun().then((value) {
                          if (value.result.isNotEmpty) {
                            WeaponToUserGetRequestModel request =
                                WeaponToUserGetRequestModel(
                                    recordId: value.result.first.recordId);
                            context
                                .read<WeaponToUserGetCubit>()
                                .getWeaponToUserByRecordId(request)
                                .then((value) {
                                  EasyLoading.dismiss();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddGunHome(
                                    series: widget.series,
                                    weaponToUserGetResponseModel:
                                        value.weaponToUser.first,
                                  ),
                                ),
                              );
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          fixedSize: const Size(315, 54),
                          primary: projectColors.blue),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'Built',
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
