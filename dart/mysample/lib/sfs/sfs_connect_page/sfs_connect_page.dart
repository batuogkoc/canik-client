import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/sfs/sfs_calibration_page/sfs_calibration_page.dart';
import 'package:mysample/widgets/background_image_sfs_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vector_math/vector_math.dart' hide Colors;
import '../../constants/color_constants.dart';
import '../../widgets/app_bar_sfs.dart';
import '../sfs_core/canik_backend.dart';
import '../sfs_core/fsm.dart';
import '../test-sfs/sfs_calibration_page_test.dart';

class SfsConnectPage extends StatefulWidget {
  const SfsConnectPage({Key? key}) : super(key: key);
  @override
  State<SfsConnectPage> createState() => _SfsConnectPageState();
}

class _SfsConnectPageState extends State<SfsConnectPage> {
  bool isClicked = false;
  bool isError = false;
  var result;
  late CanikDevice canikDevice;
  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    return Stack(
      children: [
        const BackgroundImageForSfs(),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBarForSfs(),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          width: 40.w,
                          height: 20.h,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                // side: BorderSide(color: Color(0xffFF5063), width: 2.0),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(300.0),
                                    bottomLeft: Radius.circular(18.0),
                                    bottomRight: Radius.circular(300.0),
                                    topRight: Radius.circular(300.0))),
                            color: const Color(0xff232931),
                            child: Image.asset(
                                'assets/images/sfs/sfs-connect-gun.png'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          width: 40.w,
                          height: 20.h,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                //  side: BorderSide(color: Color(0xffFF5063), width: 2.0),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(300.0),
                                    bottomLeft: Radius.circular(300.0),
                                    bottomRight: Radius.circular(300.0),
                                    topRight: Radius.circular(18.0))),
                            color: const Color(0xff232931),
                            child: Image.asset(
                                'assets/images/sfs/sfs-connect-mobile.png'),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<bool>(
                        stream: FlutterBluePlus.instance.isScanning,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            setState(() {
                              isClicked == false;
                            });
                          }
                          final scanningState = snapshot.data ?? false;
                          return isError == false && isClicked == false
                              ? TextButton(
                                  onPressed: () {
                                    context.isAndroidDevice
                                        ? FlutterBluePlus.instance.turnOn()
                                        : null;

                                    if (scanningState == true) {
                                      FlutterBluePlus.instance.stopScan();
                                    } else {
                                      FlutterBluePlus.instance.startScan(
                                          timeout: const Duration(seconds: 10));
                                    }
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async => false,
                                          child: AlertDialog(
                                            titlePadding:
                                                const EdgeInsets.all(20),
                                            titleTextStyle:
                                                _SfsConnectTextStyles.akhand16,
                                            title: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .sfs_connected_devices,
                                                      style:
                                                          _SfsConnectTextStyles
                                                              .akhand16),
                                                  FutureBuilder<
                                                      List<BluetoothDevice>>(
                                                    future: FlutterBluePlus
                                                        .instance
                                                        .connectedDevices,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        if (snapshot.hasError) {
                                                          return const Text(
                                                              "Error in fetching connected devices");
                                                        }
                                                        return Column(
                                                            children: snapshot
                                                                .data!
                                                                .where((element) =>
                                                                    element
                                                                        .name !=
                                                                    "")
                                                                .map((e) {
                                                          return TextButton(
                                                            child: Text(
                                                                "${e.name == "" ? "<No device name>" : e.name} : ${e.id}"),
                                                            onPressed:
                                                                () async {
                                                              canikDevice =
                                                                  CanikDevice(
                                                                      e);
                                                              result = await canikDevice.connect(
                                                                  timeout: const Duration(
                                                                      seconds:
                                                                          10));
                                                              if (result == Response.idError &&
                                                                  result ==
                                                                      Response
                                                                          .error &&
                                                                  result ==
                                                                      Response
                                                                          .alreadyConnected) {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  isError =
                                                                      true;
                                                                  switch (
                                                                      result) {
                                                                    case Response
                                                                        .idError:
                                                                      print(
                                                                          'Id error');
                                                                      break;
                                                                    case Response
                                                                        .error:
                                                                      print(
                                                                          'Connecting Error');
                                                                      break;
                                                                    case Response
                                                                        .alreadyConnected:
                                                                      print(
                                                                          'Already connected error');
                                                                      break;
                                                                  }
                                                                });
                                                              } else {
                                                                FlutterBluePlus
                                                                    .instance
                                                                    .stopScan();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return SfsCalibrationPage(
                                                                        canikdevice:
                                                                            canikDevice);
                                                                  },
                                                                ));
                                                                // context.navigateToPage(
                                                                //     DevicePage(canikDevice));
                                                              }
                                                            },
                                                          );
                                                        }).toList());
                                                      } else {
                                                        EasyLoading.dismiss();
                                                        return const Text(
                                                            "Fetching connected devices");
                                                      }
                                                    },
                                                  ),
                                                  context
                                                      .emptySizedHeightBoxNormal,
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .sfs_scanned_devices,
                                                      style:
                                                          _SfsConnectTextStyles
                                                              .akhand16),
                                                  StreamBuilder<
                                                      List<ScanResult>>(
                                                    stream: FlutterBluePlus
                                                        .instance.scanResults,
                                                    initialData: const [],
                                                    builder:
                                                        (context, snapshot) {
                                                      return Column(
                                                          children: snapshot
                                                              .data!
                                                              .where((element) =>
                                                                  element.device
                                                                      .name !=
                                                                  "")
                                                              .map((e) =>
                                                                  TextButton(
                                                                    child: Text(
                                                                        "${e.device.name == "" ? "<No device name>" : e.device.name} : ${e.device.id} , ${e.rssi}",
                                                                        style: _SfsConnectTextStyles
                                                                            .built17),
                                                                    onPressed:
                                                                        () async {
                                                                      canikDevice =
                                                                          CanikDevice(
                                                                              e.device);

                                                                      result = await canikDevice.connect(
                                                                          timeout:
                                                                              const Duration(seconds: 10));

                                                                      if (result == Response.alreadyConnected ||
                                                                          result ==
                                                                              Response
                                                                                  .error ||
                                                                          result ==
                                                                              Response.idError) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {
                                                                          isError =
                                                                              true;
                                                                        });
                                                                      } else {
                                                                        FlutterBluePlus
                                                                            .instance
                                                                            .stopScan();
                                                                        context.navigateToPage(
                                                                            DevicePage(canikDevice));
                                                                      }
                                                                    },
                                                                  ))
                                                              .toList());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            backgroundColor:
                                                ProjectColors().black,
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    FlutterBluePlus.instance
                                                        .stopScan();

                                                    setState(() {
                                                      isClicked = false;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline))),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    setState(() {
                                      isClicked = !isClicked;
                                    });
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .start
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          decoration:
                                              TextDecoration.underline)))
                              : const SizedBox();
                        }),
                    isClicked == true && isError == false
                        ? Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Column(
                              children: [
                                Text(AppLocalizations.of(context)!.pairing,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w300,
                                    )),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(AppLocalizations.of(context)!.pairing_text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300,
                                    )),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    isError == true
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Container(
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff102136),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Image.asset(
                                              'assets/images/sfs/sfs-connect-info-circle.png'),
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .warning_message,
                                            style:
                                                _SfsConnectTextStyles.akhand16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .connection_failed,
                                    style: _SfsConnectTextStyles.built32),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Opacity(
                                    opacity: 0.6,
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .please_bluetooth,
                                        style: _SfsConnectTextStyles.akhand16)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(138, 54),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40)),
                                              primary: ProjectColors().black3),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .try_again,
                                            style:
                                                _SfsConnectTextStyles.built17,
                                          )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(138, 54),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            primary: ProjectColors().blue),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .continue_upper,
                                          style: _SfsConnectTextStyles.built17,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ])),
        Positioned(
          top: 30.h,
          left: 45.w,
          child: SizedBox(
            width: 13.w,
            height: 6.h,
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xff5F6979)), // 0xffFF5063
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  color: const Color(0xff232931)), // 0xffFF5063
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SfsCalibrationPage(
                                  canikdevice: canikDevice,
                                )));
                  },
                  child: Image.asset(
                      'assets/images/sfs/sfs-connect-link.png')), //sfs-connect-danger.png
            ),
          ),
        ),
      ],
    );
  }
}

class _SfsConnectTextStyles {
  static const TextStyle built32 = TextStyle(
      fontSize: 32,
      fontFamily: 'Built',
      fontWeight: FontWeight.w500,
      color: Colors.white);
  static const TextStyle akhand16 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white);
  static const TextStyle built17 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white);
}

class DevicePage extends StatelessWidget {
  final CanikDevice canikDevice;
  const DevicePage(this.canikDevice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Canik: ${canikDevice.id}")),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("Disconnect"),
                onPressed: () {
                  canikDevice.disconnect();
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Calibrate Gyro"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return SfsCalibrationPage(canikdevice: canikDevice);
                    },
                  ));
                },
              ),

              // ***** HolsterDraw *****
              StreamBuilder(
                stream: canikDevice.holsterDrawSM.stateStream,
                initialData: canikDevice.holsterDrawSM.state,
                builder: (context, snapshot) {
                  if (snapshot.data! == HolsterDrawState.stop) {
                    return ElevatedButton(
                      child: const Text("Start SM"),
                      onPressed: () {
                        canikDevice.holsterDrawSM.start();
                      },
                    );
                  } else {
                    return ElevatedButton(
                      child: const Text("Stop SM"),
                      onPressed: () {
                        canikDevice.holsterDrawSM.stop();
                      },
                    );
                  }
                },
              ),
              const Text("Services:"),
              Column(
                  children: canikDevice.services.map((e) {
                return Text("${e.uuid}");
              }).toList()),
              StreamBuilder<ProcessedData>(
                stream: canikDevice.processedDataStream,
                initialData: ProcessedData.zero(),
                builder: (context, snapshot) {
                  final euler = quaternionToEuler(snapshot.data!.orientation);
                  final accelEuler = accelToEuler(snapshot.data!.rawAccelG);
                  return Column(
                    children: [
                      const Text("Raw Accel (g)"),
                      Text(
                          "X: ${snapshot.data!.rawAccelG.x}\nY: ${snapshot.data!.rawAccelG.y}\nZ: ${snapshot.data!.rawAccelG.z}"),
                      const Text("Rate (deg)"),
                      Text(
                          "X: ${degrees(snapshot.data!.rateRad.x)}\nY: ${degrees(snapshot.data!.rateRad.y)}\nZ: ${degrees(snapshot.data!.rateRad.z)}"),
                      const Text("Gyro offset (deg)"),
                      Text(
                          "X: ${degrees(canikDevice.gyroOffset.x)}\nY: ${degrees(canikDevice.gyroOffset.y)}\nZ: ${degrees(canikDevice.gyroOffset.z)}"),
                      const Text("G"),
                      Text("${canikDevice.gravitationalAccelG}"),
                      const Text("Orientation"),
                      Text(
                          "Yaw: ${degrees(euler.z)}\nPitch: ${degrees(euler.y)}\nRoll: ${degrees(euler.x)}\n"),
                      const Text("Device Accel (g)"),
                      Text(
                          "X: ${snapshot.data!.deviceAccelG.x}\nY: ${snapshot.data!.deviceAccelG.y}\nZ: ${snapshot.data!.deviceAccelG.z}"),
                    ],
                  );
                },
              ),
              StreamBuilder<HolsterDrawState>(
                stream: canikDevice.holsterDrawSM.stateStream,
                initialData: canikDevice.holsterDrawSM.state,
                builder: (context, snapshot) {
                  return Text("HolsterDrawSM state: ${snapshot.data!.name}");
                },
              )
            ],
          ),
        ));
  }
}
