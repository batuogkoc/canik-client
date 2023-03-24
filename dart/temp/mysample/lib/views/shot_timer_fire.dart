import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/product/error_handler.dart';
import 'package:mysample/repository/repo_shotTimer.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../constants/color_constants.dart';
import '../cubit/weapon_list_cubit.dart';
import '../entities/response/weapon_to_user_response.dart';
import '../entities/shot_timer.dart';
import '../entities/weapon.dart';
import '../widgets/background_image_widget.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShotTimerFire extends StatefulWidget {
  double? sensibility;

  ShotTimerFire({Key? key, this.sensibility = 45.0}) : super(key: key);

  @override
  State<ShotTimerFire> createState() => _ShotTimerFireState();
}

class _ShotTimerFireState extends State<ShotTimerFire> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  int counter = 0;
  double preTimeWarning = 0.0;

  Duration duration = const Duration();
  List<Info> infos = <Info>[];
  final durationZero = const Duration(seconds: 0);
  Timer? timer;
  bool timerStop = true;
  String? selectedGun;
  final ScrollController _scrollController = ScrollController();
  String? canikId;
  ProjectColors projectColors = ProjectColors();

  bool isShotNullErrorText = false;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<String?> getCanikId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('canikId');
  }

  String? _deviceId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    startTimer();
    _noiseMeter = NoiseMeter(onError);
    start();
    getCanikId().then(
      (canikIdValue) {
        canikId = canikIdValue;
        context.read<WeaponListCubit>().getAllWeaponToUsers(WeaponToUserListRequestModel(canikId: canikIdValue!));
      },
    );
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!_isRecording) {
        _isRecording = true;
      }
    });

    if (noiseReading.maxDecibel > 90) {
      counter += 1;

      Info info = Info(
          index: counter,
          timeOnShot: buildTimeTwo(),
          shotDecibel: noiseReading.maxDecibel,
          timeWarning: (double.parse(buildTimeTwo().data!) - preTimeWarning));
      preTimeWarning = double.parse(info.timeOnShot!.data.toString());
      infos.add(info);
    }
  }

  void onError(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void start() async {
    counter = 0;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      setState(() {
        _isRecording = false;
      });
    } catch (err) {
      //print('stopRecorder error: $err');
    }
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void reset() {
    if (timerStop) {
      setState(() {
        duration = durationZero;
      });
    } else {
      setState(() {
        duration = const Duration();
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void resetTimer({bool resets = true}) {
    if (resets) {
      reset();
      startTimer();
    }
    setState(() => timer?.cancel());
  }

  final fireController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> gunsForUser = [AppLocalizations.of(context)!.other];
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShotTimeHomePage(),));
              },
              icon: const Icon(Icons.arrow_back_ios_sharp),
              color: projectColors.black3,
            ),
            title: Text(
              'Shot Timer',
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
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Visibility(
                    visible: isShotNullErrorText,
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.no_shooting,
                          style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold)),
                    )),
                Center(child: buildTime()),
                Padding(
                  padding: const EdgeInsets.only(top: 46.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShotTimerFire()));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          fixedSize: const Size(315, 54),
                          primary: projectColors.blue),
                      child: Text(
                        AppLocalizations.of(context)!.start_again,
                        style: const TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.w400),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 11.0),
                  child: ElevatedButton(
                      onPressed: () {
                        var result = infos
                            .map<Result>((e) => Result(
                                shotCounter: e.index.toString(),
                                duration: double.parse(e.timeOnShot!.data!),
                                passingTime: e.timeWarning!))
                            .toList();
                        // result.isNotEmpty yapılacak kayıt eklemek true==true eklendi ...
                        if (result.isNotEmpty) {
                          resetTimer(resets: false);
                          stop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var textStyle =
                                  TextStyle(color: projectColors.black3, fontSize: 12, fontWeight: FontWeight.w500);
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
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                                            Text(AppLocalizations.of(context)!.shot_record_name, style: textStyle),
                                            TextField(
                                              maxLength: 20,
                                              onChanged: (value) => setState(() => {}),
                                              controller: fireController,
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                              decoration: InputDecoration(
                                                counterStyle:const TextStyle(color: Colors.white),
                                                enabledBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: projectColors.blue),
                                                ),
                                                hintText: AppLocalizations.of(context)!.shot_record_hint,
                                                hintStyle: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 15.0),
                                              child: Text(AppLocalizations.of(context)!.gun, style: textStyle),
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
                                                  var weaponToUser =
                                                      response.weaponToUsers.map<String>((e) => e.name).toList();
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
                                        actionsPadding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                    fixedSize: const Size(122, 54),
                                                    primary: projectColors.blue,
                                                  ),
                                                  onPressed: fireController.text.isEmpty || selectedGun == null || EasyLoading.isShow
                                                      ? null
                                                      : () async {
                                                          EasyLoading.show();
                                                          setState(() => {});
                                                          var shotTimerRequest = ShotTimerAddRequestModel(
                                                              shotName: fireController.text,
                                                              weapon: selectedGun!,
                                                              deviceId: _deviceId!,
                                                              totalTime: double.parse(buildTimeTwo().data!),
                                                              sensibility: widget.sensibility!,
                                                              result: result);
                                                          var boolresult = await RepositoryShotTimer()
                                                              .addShotTimer(shotTimerRequest);
                                                          if (boolresult.result == true) {
                                                            EasyLoading.dismiss();
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => const ShotTimeHomePage()));
                                                          }
                                                          else{
                                                            EasyLoading.dismiss();
                                                            Navigator.pop(context);
                                                            ErrorPopup(2, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.error_subtitle).error(context);
                                                            setState(() => {
                                                              fireController.text = "",
                                                              selectedGun = null
                                                            });
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
                        } else {
                          setState(() {
                            isShotNullErrorText = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(40)),
                        fixedSize: const Size(315, 54),
                        primary: Colors.transparent,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.w400),
                      )),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: infos.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var info = infos[index];
                      isShotNullErrorText = false;
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.shot + '-' + info.index.toString(),
                              style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${info.timeOnShot!.data.toString()} ${info.timeWarning!.toStringAsFixed(2)}',
                              style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
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

  Text buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }

  Text buildTimeTwo() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes.$seconds',
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: projectColors.blue),
    );
  }
}

class Info {
  int? index;
  Text? timeOnShot;
  double? timeWarning;
  double? shotDecibel;
  Info({this.index = 1, this.timeOnShot, this.timeWarning = 0, this.shotDecibel});
}
