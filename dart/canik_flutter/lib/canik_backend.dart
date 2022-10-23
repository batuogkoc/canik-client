import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "dart:async";
import "package:vector_math/vector_math.dart";
import 'package:canik_lib/canik_lib.dart';

//TODO: Device configuration
//TODO: Connection logic for other characteristics
//TODO: ?Maybe leave the connection to the different characteristics up to the user

class CanikServices {
  static const metrics = "00000001-0000-1000-8000-00805f9b34fb";
  static const parameters = "00000005-0000-1000-8000-00805f9b34fb";
}

class CanikCharacteristics {
  static const bufferedRawData = "00000002-0000-1000-8000-00805f9b34fb";
  static const configMonitor = "00000004-0000-1000-8000-00805f9b34fb";
}

class CanikUtilities {
  static const Map<String, List<String>> serviceCharacteristicUUIDMapping = {
    "00001801-0000-1000-8000-00805f9b34fb": [
      "00002a05-0000-1000-8000-00805f9b34fb"
    ],
    "00001800-0000-1000-8000-00805f9b34fb": [
      "00002a00-0000-1000-8000-00805f9b34fb",
      "00002a01-0000-1000-8000-00805f9b34fb",
      "00002a04-0000-1000-8000-00805f9b34fb",
    ],
    "0000fe40-cc7a-482a-984a-7f2ed5b3e58f": [
      "0000fe41-8e22-4541-9d4c-21edae82ed19",
      "0000fe42-8e22-4541-9d4c-21edae82ed19",
    ],
    "00000001-0000-1000-8000-00805f9b34fb": [
      "00000002-0000-1000-8000-00805f9b34fb",
      "00000003-0000-1000-8000-00805f9b34fb",
      "00000004-0000-1000-8000-00805f9b34fb",
    ],
    "00000005-0000-1000-8000-00805f9b34fb": [
      "00000006-0000-1000-8000-00805f9b34fb",
      "0000fe11-8e22-4541-9d4c-21edae82ed19",
    ],
    "0000fe20-cc7a-482a-984a-7f2ed5b3e58f": [
      "0000fe22-8e22-4541-9d4c-21edae82ed19",
      "0000fe23-8e22-4541-9d4c-21edae82ed19",
      "0000fe24-8e22-4541-9d4c-21edae82ed19",
    ],
    "00000000-000e-11e1-9ab4-0002a5d5c51d": [
      "00000001-000e-11e1-ac36-0002a5d5c51d",
      "00000002-000e-11e1-ac36-0002a5d5c51d"
    ]
  };

  static bool checkIfCanik(List<BluetoothService> services) {
    for (var service in services) {
      if (serviceCharacteristicUUIDMapping
              .containsKey(service.uuid.toString()) !=
          true) {
        return false;
      }
      for (var characteristic in service.characteristics) {
        if (serviceCharacteristicUUIDMapping[service.uuid.toString()]
                ?.contains(characteristic.uuid.toString()) !=
            true) {
          return false;
        }
      }
    }
    return true;
  }

  static BluetoothService? findService(
      List<BluetoothService> services, String uuid) {
    for (final service in services) {
      if (service.uuid.toString() == uuid) {
        return service;
      }
    }
    return null;
  }

  static BluetoothCharacteristic? findCharacteristic(
      List<BluetoothService> services, String uuid) {
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          return characteristic;
        }
      }
    }
    return null;
  }
}

class CanikDevice {
  final BluetoothDevice _device;

  late HolsterDrawSM _holsterDrawSM;

  late List<BluetoothService> services;

  final _processedDataStreamController = StreamController<ProcessedData>();
  late Stream<ProcessedData> _processedDataBroadcastStream;
  final _stateStreamController = StreamController<BluetoothDeviceState>();
  final RawDataToProcessedDataTransformer _rawDataToProcessedDataTransformer;

  final double gyroRadsScale;
  final double accGScale;
  //degrees2Radians * (6000) / 32767
  CanikDevice(this._device,
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      double ahrsBeta = 0.5,
      double drawThresholdG = 0.2,
      double rotatingAngularRateThreshDegS = 50,
      bool startHolsterDrawSM = false})
      : _rawDataToProcessedDataTransformer = RawDataToProcessedDataTransformer(
            ahrsBeta: ahrsBeta, cancelOnError: false) {
    _processedDataBroadcastStream =
        _processedDataStreamController.stream.asBroadcastStream();
    _holsterDrawSM = HolsterDrawSM(
        processedDataStream, drawThresholdG, rotatingAngularRateThreshDegS);
    if (startHolsterDrawSM) {
      _holsterDrawSM.start();
    }
  }
  Future<void> connect({
    Duration? timeout,
    bool autoConnect = true,
  }) async {
    _stateStreamController.sink.add(BluetoothDeviceState.connecting);
    try {
      await _device.connect(timeout: timeout, autoConnect: autoConnect);
    } on PlatformException {}
    services = await _device.discoverServices();
    if (CanikUtilities.checkIfCanik(services) == false) {
      _stateStreamController.sink.add(BluetoothDeviceState.disconnecting);
      _stateStreamController.sink.addStream(_device.state);
      _device.disconnect();
      throw Exception("The bluetooth device is not a Canik device");
    }
    await _notifyToBufferedRawData();
    _stateStreamController.sink.add(BluetoothDeviceState.connected);
    _stateStreamController.sink.addStream(_device.state);
  }

  Future<void> _notifyToBufferedRawData() async {
    final bufferedRawData = CanikUtilities.findCharacteristic(
        services, CanikCharacteristics.bufferedRawData);
    await bufferedRawData!.setNotifyValue(true);

    _processedDataStreamController.sink.addStream(bufferedRawData.value
        .transform(BufferedRawDataToRawDataTransformer())
        .transform(_rawDataToProcessedDataTransformer));
  }

  Future<void> calibrateGyro(
      {final Duration duration = const Duration(seconds: 3),
      final double maxAccelG = 0.1,
      final double minFrequency = 300}) async {
    var completer = Completer<void>();
    int n = 0;
    Vector3 gyroSum = Vector3.zero();
    double accelNormSum = 0;

    Timer(duration, () {
      if (completer.isCompleted) {
        return;
      }
      if (n == 0 ||
          (n.toDouble() / (duration.inMicroseconds.toDouble() / 1000000) <
              minFrequency)) {
        double dataRate =
            n.toDouble() / (duration.inMicroseconds.toDouble() / 1000000);
        completer.completeError(Exception(
            "Insufficient data rate of ${dataRate.isNaN ? 0 : dataRate} hZ, expected min ${minFrequency} hZ"));
      } else {
        _rawDataToProcessedDataTransformer.gyroOffset =
            (gyroSum / n.toDouble());
        _rawDataToProcessedDataTransformer.gravitationalAccelG =
            accelNormSum / n.toDouble();
        completer.complete();
      }
    });

    await for (var data in processedDataStream) {
      if (completer.isCompleted) {
        break;
      }
      if (data.deviceAccelG.length > maxAccelG) {
        completer.completeError(Exception(
            "Device was not kept stable. Experienced ${data.deviceAccelG.length} G, limit $maxAccelG G"));
      }
      n++;
      accelNormSum += data.rawAccelG.length;
      gyroSum += data.rateRad;
    }
    return completer.future;
  }

  Stream<ProcessedData> get processedDataStream {
    return _processedDataBroadcastStream;
  }

  get id {
    return _device.id;
  }

  get name {
    return _device.name;
  }

  get state {
    return _device.state;
  }

  double get gravitationalAccelG {
    return _rawDataToProcessedDataTransformer.gravitationalAccelG;
  }

  Vector3 get gyroOffset {
    return _rawDataToProcessedDataTransformer.gyroOffset;
  }

  HolsterDrawSM get holsterDrawSM {
    return _holsterDrawSM;
  }

  getRssi() {
    return _device.readRssi();
  }

  disconnect() {
    return _device.disconnect();
  }
}