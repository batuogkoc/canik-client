import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/cubit/shot_timer_cubit.dart';
import 'package:mysample/entities/shot_timer.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/all_shot_timer_page.dart';
import 'package:mysample/views/shot_timer_download_page.dart';
import 'package:mysample/views/shot_timer_fire.dart';
import 'package:mysample/views/tabs_bar.dart';

import '../constants/color_constants.dart';
import '../cubit/weapon_list_cubit.dart';
import '../entities/response/weapon_to_user_response.dart';
import '../widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/shot_timer_video_widget.dart';

class ShotTimeHomePage extends StatefulWidget {
  const ShotTimeHomePage({Key? key}) : super(key: key);

  @override
  State<ShotTimeHomePage> createState() => _ShotTimeHomePageState();
}

class _ShotTimeHomePageState extends State<ShotTimeHomePage> {
  

  @override
  void initState() {
    context.read<ShotTimerCubit>().listShotTimersByDeviceId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        const BackgroundImage(),
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TabBarPage(index: 0),
                      ));
                },
                icon: const Icon(Icons.home),
                color: projectColors.black3,
              ),
              title: Text(
                AppLocalizations.of(context)!.shot_timer_t,
                style: TextStyle(color: projectColors.black3, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              backgroundColor: projectColors.black2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18.0),
                  bottomRight: Radius.circular(18.0),
                ),
              ),
            ),
            body: SizedBox(
              height: screenHeight,
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 45,
                      //left: 95,
                      //right: 95,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 68,
                        width: 181,
                        child: Text(
                          "00:00:00",
                          style: TextStyle(fontSize: 57, color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.08,
                          width: screenWidth * 0.80,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>const ShotTimerVideo()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: projectColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: Text(AppLocalizations.of(context)!.start)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                    child: BlocBuilder<ShotTimerCubit, List<ShotTimerListResponseModel>>(
                      builder: (context, shotTimers) {
                        if (shotTimers.isNotEmpty) {
                          // double sizedBoxHeight = screenHeight / 4.5 * shotTimers.length;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 30, right: 30, left: 30),
                            child: Container(
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(15), color: projectColors.black),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: shotTimers.length > 5 ? 5 : shotTimers.length,
                                      itemBuilder: (_, index) {
                                        ShotTimerListResponseModel shotTimerListResponseModel = shotTimers[index];

                                        return ShotCardWidget(
                                          screenWidth: screenWidth,
                                          shotTimerListResponseModel: shotTimerListResponseModel,
                                        );
                                      }),
                                  shotTimers.length > 5
                                      ? TextButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) => AllShotTimerPage(shotTimerList: shotTimers)))),
                                          child: Text(
                                            '${AppLocalizations.of(context)!.all} (${shotTimers.length})',
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 50,
                                        ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShotCardWidget extends StatefulWidget {
  double screenWidth;
  ShotTimerListResponseModel shotTimerListResponseModel;
  bool? allshottimerpage;
  ShotCardWidget({Key? key, required this.screenWidth, required this.shotTimerListResponseModel, this.allshottimerpage})
      : super(key: key);

  @override
  State<ShotCardWidget> createState() => _ShotCardWidgetState();
}

class _ShotCardWidgetState extends State<ShotCardWidget> {
  final GlobalKey _key = GlobalKey();

  // Coordinates
  double? _x, _y;

  final fireController = TextEditingController();

  String? selectedGun;
  ProjectColors projectColors = ProjectColors();

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

  Future<void> setDatasToInputs() async {
    fireController.text = widget.shotTimerListResponseModel.shotName;
    selectedGun =
        widget.shotTimerListResponseModel.weapon.isNotEmpty ? widget.shotTimerListResponseModel.weapon : 'OTHER';
  }

  @override
  void initState() {
    super.initState();
    fireController.text = widget.shotTimerListResponseModel.shotName;
    selectedGun =
        widget.shotTimerListResponseModel.weapon.isNotEmpty ? widget.shotTimerListResponseModel.weapon : 'OTHER';
  }

  @override
  Widget build(BuildContext context) {
    List<String> gunsForUser = [AppLocalizations.of(context)!.other];
    double? screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: projectColors.black2,
          border: Border.all(color: projectColors.black3, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.shotTimerListResponseModel.shotName,
                      style: TextStyle(color: projectColors.white1, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.shotTimerListResponseModel.weapon,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      widget.shotTimerListResponseModel.date == null
                          ? ''
                          : widget.shotTimerListResponseModel.date!.substring(0, 10).split('-').reversed.join('-'),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: projectColors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5, top: 5),
                      child: Text(
                        widget.shotTimerListResponseModel.totalShot == null
                            ? ''
                            : widget.shotTimerListResponseModel.totalShot! + ' ' + AppLocalizations.of(context)!.shot,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
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
                                bottom: screenHeight - _y! - 175,
                                left: _x! - 50,
                                child: Container(
                                  width: 112,
                                  height: 138,
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ShotTimerDownload(
                                                  shotTimerListResponseModel: widget.shotTimerListResponseModel,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.download,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                              ),
                                              Image.asset('assets/images/download.png'),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 13.0, bottom: 13),
                                          child: Divider(
                                            color: Colors.transparent,
                                            height: 1,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await setDatasToInputs();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                var textStyle = TextStyle(
                                                    color: projectColors.black3,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500);
                                                return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    var textStyle2 = const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily: 'Built',
                                                      fontWeight: FontWeight.w600,
                                                    );
                                                    return Center(
                                                      child: SingleChildScrollView(
                                                        child: AlertDialog(
                                                          backgroundColor: projectColors.black,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(30)),
                                                          title: Text(
                                                            AppLocalizations.of(context)!.save_to_shot,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontFamily: 'Built',
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          titlePadding: const EdgeInsets.only(left: 30, top: 30),
                                                          contentPadding: const EdgeInsets.all(30),
                                                          content: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(AppLocalizations.of(context)!.shot_record_name,
                                                                  style: textStyle),
                                                              TextField(
                                                                controller: fireController,
                                                                style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 17,
                                                                    fontWeight: FontWeight.w500),
                                                                decoration: InputDecoration(
                                                                  enabledBorder: const UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.white),
                                                                  ),
                                                                  focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: projectColors.blue),
                                                                  ),
                                                                  hintText:
                                                                      AppLocalizations.of(context)!.shot_record_hint,
                                                                  hintStyle: const TextStyle(
                                                                    fontSize: 17,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 15.0),
                                                                child: Text(AppLocalizations.of(context)!.gun,
                                                                    style: textStyle),
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
                                                                      hint: Text(
                                                                          AppLocalizations.of(context)!.choose_weapon,
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
                                                                    var weaponToUser = response.weaponToUsers
                                                                        .map<String>((e) => e.name)
                                                                        .toList();
                                                                    return DropdownButton<String>(
                                                                      dropdownColor: Colors.black,
                                                                      value: selectedGun,
                                                                      onChanged: (String? newValue) => setState(() => {
                                                                            selectedGun = newValue!,
                                                                          }),
                                                                      isExpanded: true,
                                                                      hint: Text(
                                                                          AppLocalizations.of(context)!.choose_weapon,
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
                                                                      items: selectedGun != "OTHER"
                                                                          ? weaponToUser.map(buildMenuItem).toList()
                                                                          : gunsForUser.map(buildMenuItem).toList(),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          actionsPadding:
                                                              const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                                                          actions: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(40)),
                                                                      fixedSize: const Size(122, 54),
                                                                      primary: projectColors.blue,
                                                                    ),
                                                                    onPressed: fireController.text.isEmpty ||
                                                                            selectedGun == null
                                                                        ? null
                                                                        : () async {
                                                                            EasyLoading.show();
                                                                            var shotTimerRequest =
                                                                                ShotTimerUpdateRequestModel(
                                                                                    weapon: selectedGun!,
                                                                                    shotName: fireController.text,
                                                                                    recordId: widget
                                                                                        .shotTimerListResponseModel
                                                                                        .recordId);
                                                                            var shotTimerUpdate = await context
                                                                                .read<ShotTimerCubit>()
                                                                                .updateShotTimer(shotTimerRequest);
                                                                            if (shotTimerUpdate.isError == false) {
                                                                              EasyLoading.dismiss();
                                                                              if (widget.allshottimerpage == null) {
                                                                                context
                                                                                    .read<ShotTimerCubit>()
                                                                                    .listShotTimersByDeviceId();
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              } else {
                                                                                await context
                                                                                    .read<ShotTimerCubit>()
                                                                                    .listShotTimersByDeviceId()
                                                                                    .then((value) {
                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                  Navigator.pop(context);
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) =>
                                                                                              AllShotTimerPage(
                                                                                                shotTimerList: value,
                                                                                              )));
                                                                                });
                                                                              }
                                                                            }
                                                                          },
                                                                    child: Text(
                                                                      AppLocalizations.of(context)!.save,
                                                                      style: textStyle2,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.edit,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                              ),
                                              Image.asset('assets/images/edit.png'),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 13.0, bottom: 13),
                                          child: Divider(
                                            color: Colors.transparent,
                                            height: 1,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            EasyLoading.show(dismissOnTap: false);
                                            ShotTimerListResponseModel shotTimerToUpdate =
                                                widget.shotTimerListResponseModel;
                                            var result = await context.read<ShotTimerCubit>().deleteShotTimer(
                                                  ShotTimerDeleteRequestModel(
                                                    recordId: shotTimerToUpdate.recordId,
                                                  ),
                                                );
                                            if (result.isError == false) {
                                              EasyLoading.dismiss();
                                              if(widget.allshottimerpage == true){
                                              var shotList =  await context.read<ShotTimerCubit>().listShotTimersByDeviceId();
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllShotTimerPage(shotTimerList: shotList),));
                                              }
                                              else{
                                              await context.read<ShotTimerCubit>().listShotTimersByDeviceId();
                                              Navigator.pop(context);
                                              }
                                              
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.delete,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
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
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.white,
                )
              ]),
        ),
      ),
    );
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
}
