import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/cubit/weapon_list_cubit.dart';
import 'package:mysample/entities/weapon.dart';
import 'package:mysample/product/init/SharedPreferences/shared_prefs.dart';
import 'package:mysample/product/utility/is_tablet.dart';
import 'package:mysample/views/add_gun_with_barcode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import '../cubit/weapon_to_user_get_cubit.dart';
import '../cubit/weapon_update_cubit.dart';
import '../entities/response/weapon_to_user_response.dart';
import '../widgets/background_image_widget.dart';
import 'add_gun_home.dart';

class GunHome extends StatefulWidget {
  const GunHome({Key? key}) : super(key: key);

  @override
  State<GunHome> createState() => _GunHomeState();
}

class _GunHomeState extends State<GunHome> {
  String language = "";
  String canikid = "";
  getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      language = prefs.getString('language')!;
      
    });
  }
  setCanikId() async {
    final prefs = await SharedPreferences.getInstance();
    var getCanik = prefs.getString('canikId');
    
    setState(() {
      canikid = getCanik!;
    });
  }
  @override
  void initState() {
    getLanguage();
    setCanikId();
    super.initState();
    SharedPrefs().getCanikId().then((canikId) =>
        context.read<WeaponListCubit>().getAllWeaponToUsers(WeaponToUserListRequestModel(canikId: canikId ?? '')));
  }

  @override
  Widget build(BuildContext context) {
    final double _cardHeight = 60.h;
    final double _cardHeightForTablet = 80.h;
    final textStyle = TextStyle(fontSize: 9.sp, fontFamily: 'Built', fontWeight: FontWeight.bold, color: Colors.white);
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<WeaponListCubit, WeaponToUserListResponse>(
              builder: (context, response) {
                if (response.weaponToUsers.isEmpty) {
                  return const AddGunCustomWidget();
                }

                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: IsTablet().isTablet() ? _cardHeightForTablet : _cardHeight,
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: response.weaponToUsers.length,
                          itemBuilder: (context, index) {
                            WeaponToUserListResponseModel weaponToUser = response.weaponToUsers[index];

                            return GunCard(
                              weaponToUser: weaponToUser,
                              canikId: canikid,
                              language: language,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 5.h,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddGunB()));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                primary: projectColors.blue),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add),
                                  Text(
                                    AppLocalizations.of(context)!.add_gun,
                                    style: textStyle,
                                  )
                                ])),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // Positioned(
        //   right: screenWidth * 0.08,
        //   bottom: screenHeight * 0.12,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       primary: projectColors.blue,
        //       shape: const CircleBorder(),
        //       fixedSize: const Size(56, 56),
        //     ),
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddGunB()));
        //     },
        //     child: const Icon(Icons.add),
        //   ),
        // ),
      ],
    );
  }
}

class GunCard extends StatefulWidget {
  final String language;
  final WeaponToUserListResponseModel weaponToUser;
  final String? canikId;
  GunCard({Key? key, required this.weaponToUser, this.canikId, required this.language}) : super(key: key);
  ProjectColors projectColors = ProjectColors();

  @override
  State<GunCard> createState() => _GunCardState();
}

class _GunCardState extends State<GunCard> {
  final GlobalKey _key = GlobalKey();

  // Coordinates
  double _x = 0.0, _y = 0.0;
  _onLoading() {
    Navigator.pop(context);
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabBarPage(
                  index: 1,
                )));
  }

  // This function is called when the user presses the floating button
  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);

    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    final double _size10 = 10.sp;
    final double _size15 = 15.sp;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        //color: const Color(0xff4C535E).withOpacity(0.20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              //stops: Alignment.center,

              end: Alignment.bottomCenter,
              colors: [
                projectColors.black2,
                projectColors.black,
              ],
            )),
        width: 85.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tarih Datası geldiği zaman güncellenecek.
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    widget.weaponToUser.date != ""
                        ? widget.language == "EN"
                            ? widget.weaponToUser.date.replaceAll(".", "").substring(4) +
                                "-" +
                                widget.weaponToUser.date.replaceAll(".", "").substring(2, 4) +
                                "-" +
                                widget.weaponToUser.date.replaceAll(".", "").substring(0, 2)
                            : widget.weaponToUser.date.replaceAll(".", "-")
                        : DateTime.now().toString().substring(0, 10),
                    style: TextStyle(
                        color: projectColors.blue,
                        fontSize: IsTablet().isTablet() ? _size10 : 11.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    key: _key,
                    onPressed: () {
                      _getOffset(_key);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                Positioned(
                                  bottom: screenHeight - _y - 155,
                                  left: _x - 80,
                                  child: Container(
                                    height: 15.h,
                                    width: 15.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: projectColors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              EasyLoading.show(dismissOnTap: false);
                                              context
                                                  .read<WeaponToUserGetCubit>()
                                                  .getWeaponToUserByRecordId(WeaponToUserGetRequestModel(
                                                      recordId: widget.weaponToUser.recordId))
                                                  .then((value) {
                                                if (value.weaponToUser.isNotEmpty) {
                                                  EasyLoading.dismiss();
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return AddGunHome(
                                                      weaponToUserGetResponseModel: value.weaponToUser.first,
                                                    );
                                                  }));
                                                }
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.edit,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:  11.sp,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                Image.asset('assets/images/edit.png'),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
                                            child: const Divider(
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              EasyLoading.show();

                                              WeaponToUserListResponseModel gunToDelete = widget.weaponToUser;
                                              var res = await context.read<WeaponUpdateCubit>().updateWeaponToUser(
                                                    WeaponToUserUpdateRequestModel(
                                                      serialNumber: gunToDelete.serialNumber,
                                                      name: gunToDelete.name,
                                                      recordID: gunToDelete.recordId,
                                                      isDeleted: true,
                                                    ),
                                                  );
                                              if (res.result == true) {
                                                var res2 = await context.read<WeaponListCubit>().getAllWeaponToUsers(
                                                    WeaponToUserListRequestModel(canikId: widget.canikId!));
                                                if (res2.isError == false) {
                                                  EasyLoading.dismiss();
                                                  _onLoading();
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.delete,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:  11.sp,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                Image.asset('assets/images/trash.png'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 2.h,
                    ))
              ],
            ),
            widget.weaponToUser.imageUrl == ""
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                      height: 35.h,
                      child: Image.asset(
                        'assets/images/shadowgun.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                )
                : widget.weaponToUser.imageUrl == null
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                          height: 35.h,
                          child: Image.asset(
                            'assets/images/shadowgun.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                          height: 35.h,
                          child: Image.network(
                            widget.weaponToUser.imageUrl!,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Text(
                    widget.weaponToUser.name,
                    style: TextStyle(
                        fontSize: IsTablet().isTablet() ? _size10 : 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    widget.weaponToUser.serialNumber,
                    style: TextStyle(
                        fontSize: IsTablet().isTablet() ? _size10 : 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddGunCustomWidget extends StatelessWidget {
  const AddGunCustomWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: SizedBox(
            height: 340,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: projectColors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Image.asset('assets/images/dont_add_gun.png')),
                  Text(
                    AppLocalizations.of(context)!.not_have_registered_gun,
                    style: const TextStyle(
                        fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
                    child: Text(
                      AppLocalizations.of(context)!.not_have_registered_gun_text,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddGunB()));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(285, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          primary: projectColors.blue),
                      child: Text(
                        AppLocalizations.of(context)!.add_gun,
                        style: TextStyle(
                            fontFamily: 'Built',
                            color: Colors.white,
                            fontSize: IsTablet().isTablet() ? 10.sp : 15.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GunImagesHorizontalList extends StatelessWidget {
  List<WeaponToUserListResponseModel> weaponToUsers;

  GunImagesHorizontalList({Key? key, required this.weaponToUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weaponToUsers.length,
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                WeaponToUserListResponseModel weaponToUser = weaponToUsers[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.abc,
                          color: Colors.white,
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
