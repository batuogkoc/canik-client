import 'canik_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "package:flutter/foundation.dart";
import 'package:vector_math/vector_math.dart' hide Colors;
import 'package:canik_lib/canik_lib.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const CanikApp());
}

// Future<int> test() async {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   // Start scanning
//   flutterBlue.startScan(timeout: Duration(seconds: 4));
//   // Listen to scan results
//   var subscription = flutterBlue.scanResults.listen((results) async {
//     // do something with scan results
//     for (ScanResult r in results) {
//       // if (r.device.name == "MyCanik ") {
//       //   flutterBlue.stopScan();
//       //   print('${r.device.name} found! rssi: ${r.rssi} id ${r.device.id}');
//       //   await r.device.connect();
//       // }
//     }
//   });

//   // Stop scanning

//   return 0;
// }

class CanikApp extends StatelessWidget {
  const CanikApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canik Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return const HomePage();
          } else {
            return const BluetoothOffScreen();
          }
        },
      ),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              child: const Text('TURN ON'),
              onPressed: defaultTargetPlatform == TargetPlatform.android
                  ? () => FlutterBluePlus.instance.turnOn()
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Flutter Blue Plus Test")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: StreamBuilder<bool>(
                  stream: FlutterBluePlus.instance.isScanning,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error with scanning");
                    }
                    final scanningState = snapshot.data ?? false;
                    return ElevatedButton(
                        onPressed: () {
                          if (scanningState == true) {
                            FlutterBluePlus.instance.stopScan();
                          } else {
                            FlutterBluePlus.instance.startScan(
                                timeout: const Duration(seconds: 40));
                          }
                        },
                        child: scanningState
                            ? const Text("Stop scan")
                            : const Text("Start scan"));
                  },
                ),
              ),
              const Text("Connected devices:"),
              FutureBuilder<List<BluetoothDevice>>(
                future: FlutterBluePlus.instance.connectedDevices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text("Error in fetching connected devices");
                    }
                    List<TextButton> children = [];
                    for (var bluetoothDevice in snapshot.data!) {
                      if (!(bluetoothDevice.name == "")) {
                        var textButton = TextButton(
                          child: Text(
                              "${bluetoothDevice.name == "" ? "<No device name>" : bluetoothDevice.name} : ${bluetoothDevice.id}"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                FlutterBluePlus.instance.stopScan();
                                return DevicePage(CanikDevice(bluetoothDevice));
                              },
                            ));
                          },
                        );
                        children.add(textButton);
                      }
                    }
                    return Column(children: children);
                  } else {
                    return const Text("Fetching connected devices");
                  }
                },
              ),
              Text("Scanned devices:"),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (context, snapshot) {
                  List<TextButton> children = [];
                  for (var result in snapshot.data!) {
                    if (result.device.name != "") {
                      var textButton = TextButton(
                        child: Text(
                            "${result.device.name == "" ? "<No device name>" : result.device.name} : ${result.device.id}"),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              FlutterBluePlus.instance.stopScan();
                              return DevicePage(CanikDevice(result.device));
                            },
                          ));
                        },
                      );
                      children.add(textButton);
                    }
                  }
                  return Column(children: children);
                },
              ),
            ],
          ),
        ));
  }
}

class DevicePage extends StatelessWidget {
  final CanikDevice canikDevice;
  const DevicePage(this.canikDevice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Canik: ${canikDevice.id}")),
      body: FutureBuilder(
        future: canikDevice.connect(timeout: const Duration(seconds: 10)),
        // initialData: BluetoothDeviceState.connecting,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: const [
                    Text("Connection error, device may not be a canik device."),
                    Icon(Icons.error_outline)
                  ],
                ),
              );
            }
            return Center(
              child: SingleChildScrollView(
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
                            return CalibrationPage(canikDevice);
                          },
                        ));
                      },
                    ),
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
                        final euler =
                            quaternionToEuler(snapshot.data!.orientation);
                        // final accelEuler = accelToEuler(snapshot.data!.rawAccelG);
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
                        return Text(
                            "HolsterDrawSM state: ${snapshot.data!.name}");
                      },
                    ),
                    StreamBuilder<List<Vector2>>(
                      stream: canikDevice.processedDataStream.transform(
                          YawPitchVisualiser(400 * 3,
                              dataCaptureFraction: 10 / 400)),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("a");
                          return SfCartesianChart(
                            primaryXAxis:
                                NumericAxis(minimum: -180, maximum: 180),
                            primaryYAxis:
                                NumericAxis(minimum: -90, maximum: 90),
                            series: <ChartSeries>[
                              LineSeries<Vector2, double>(
                                dataSource: snapshot.data!,
                                xValueMapper: (datum, index) {
                                  return datum.x;
                                },
                                yValueMapper: (datum, index) {
                                  return datum.y;
                                },
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Graph Error");
                        } else {
                          return const Text("Waiting graph data");
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: const [
                Text("Connecting..."),
                Icon(Icons.error_outline)
              ],
            );
          }
        },
      ),
    );
  }
}

class CalibrationPage extends StatelessWidget {
  final CanikDevice canikDevice;
  const CalibrationPage(this.canikDevice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calibrating ${canikDevice.id}")),
      body: Center(
        child: Column(children: [
          FutureBuilder<void>(
            future: canikDevice.calibrateGyro(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.hasError) {
                return Text(snapshot.error!.toString());
              } else if (snapshot.connectionState == ConnectionState.done) {
                Navigator.pop(context);
                return const Text("Successful calibration");
              } else {
                return const Text("Calibrating gyro...");
              }
            },
          )
        ]),
      ),
    );
  }
}
