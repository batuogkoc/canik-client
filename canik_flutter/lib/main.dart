import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "package:flutter/foundation.dart";

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
        body: Column(
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
                          FlutterBluePlus.instance
                              .startScan(timeout: const Duration(seconds: 4));
                        }
                      },
                      child: scanningState
                          ? const Text("Stop scan")
                          : const Text("Start scan"));
                },
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.instance.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                return Column(
                    children: snapshot.data!
                        .map((e) => TextButton(
                              child: Text(
                                  "${e.device.name == "" ? "<No device name>" : e.device.name} : ${e.device.id} , ${e.rssi}"),
                              onPressed: () {
                                e.device.connect();
                              },
                            ))
                        .toList());
              },
            ),
          ],
        ));
  }
}
