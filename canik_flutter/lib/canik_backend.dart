import 'dart:convert';
import 'dart:io';

import 'package:canik_flutter/madgwick_ahrs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "dart:async";
import "package:vector_math/vector_math.dart";
import "dart:typed_data";
import "dart:math";
import "fsm.dart";

//TODO: Device configuration
//TODO: Accel and gyro calibration
//TODO: Connection logic for other characteristics
//TODO: ?Maybe leave the connection to the different characteristics up to the user

Vector3 quaternionToEuler(Quaternion q) {
  double w = q.w;
  double x = q.x;
  double y = q.y;
  double z = q.z;
  Vector3 ret = Vector3.zero(); //yaw pitch roll

  //roll (x-axis rotation)
  double sinr_cosp = 2 * (w * x + y * z);
  double cosr_cosp = 1 - 2 * (x * x + y * y);
  ret.x = atan2(sinr_cosp, cosr_cosp);

  //pitch (y-axis rotation)
  double sinp = 2 * (w * y - z * x);
  if ((sinp).abs() >= 1) {
    ret.y = copySign(pi / 2, sinp); // use 90 degrees if out of range
  } else {
    ret.y = asin(sinp);
  }

  // yaw (z-axis rotation)
  double siny_cosp = 2 * (w * z + x * y);
  double cosy_cosp = 1 - 2 * (y * y + z * z);
  ret.z = atan2(siny_cosp, cosy_cosp);

  return ret;
}

Vector3 accelToEuler(Vector3 accel) {
  // Vector3 euler = Vector3(0, 0, 0);
  //roll x axis
  double roll = atan2(accel.y, sqrt(accel.z * accel.z + accel.x + accel.x));
  //pitch y axis
  double pitch = atan2(-accel.x, sqrt(accel.z * accel.z + accel.y + accel.y));
  //yaw y axis
  double yaw = atan2(accel.y, accel.x);

  return Vector3(roll, pitch, 0);
}

double copySign(double magnitude, double sign) {
  // The highest order bit is going to be zero if the
  // highest order bit of m and s is the same and one otherwise.
  // So (m^s) will be positive if both m and s have the same sign
  // and negative otherwise.
  /*final long m = Double.doubleToRawLongBits(magnitude); // don't care about NaN
  final long s = Double.doubleToRawLongBits(sign);
  if ((m^s) >= 0) {
      return magnitude;
  }
  return -magnitude; // flip sign*/
  if (sign == 0.0 || sign.isNaN || magnitude.sign == sign.sign) {
    return magnitude;
  }
  return -magnitude; // flip sign
}

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

class ProcessedData {
  final double time;
  final Quaternion orientation;
  final Vector3 rawAccelG;
  final Vector3 deviceAccelG;
  final Vector3 rateRad;

  ProcessedData(this.orientation, this.rawAccelG, this.deviceAccelG,
      this.rateRad, this.time);
  ProcessedData.zero()
      : orientation = Quaternion.identity(),
        rawAccelG = Vector3.zero(),
        deviceAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        time = 0;
}

class RawData {
  final double time;
  final Vector3 rawAccelG;
  final Vector3 rateRad;
  RawData(this.rawAccelG, this.rateRad, this.time);
  RawData.zero()
      : rawAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        time = 0;
}

class BufferedRawDataToRawDataTransformer
    extends StreamTransformerBase<List<int>, RawData> {
  late StreamController<RawData> _controller;
  StreamSubscription<List<int>>? _subscription;
  Stream<List<int>>? _stream;
  bool cancelOnError;

  double _lastCanikTime;
  final double gyroRadsScale;
  final double accGScale;

  BufferedRawDataToRawDataTransformer(
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      bool sync = false,
      this.cancelOnError = false})
      : _lastCanikTime = 0 {
    _controller = StreamController<RawData>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription?.pause();
        },
        onResume: () {
          _subscription?.resume();
        },
        sync: sync);
  }
  BufferedRawDataToRawDataTransformer.broadcast(
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      bool sync = false,
      this.cancelOnError = true})
      : _lastCanikTime = 0 {
    _controller = StreamController<RawData>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }
  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onListen() {
    _subscription = _stream?.listen(onData,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  List<RawData> _proccessBufferedRawData(List<int> data) {
    List<RawData> ret = List<RawData>.filled(20, RawData.zero());
    final byteBuffer = ByteData.sublistView(Uint8List.fromList(data));
    final int messageCounter = byteBuffer.getUint16(0, Endian.little);
    final health = byteBuffer.getUint8(2);
    final int timestamp =
        ByteData.sublistView(byteBuffer, 3).getUint32(0, Endian.little);

    final double canikTime = timestamp.toDouble() * 0.000025;
    if (_lastCanikTime == 0) {
      _lastCanikTime = canikTime;
    }
    if (_lastCanikTime > canikTime) {
      _lastCanikTime = 0;
    }
    final accelGyroRawData = ByteData.sublistView(byteBuffer, 7);
    for (int i = 0; i < 20; i++) {
      final gyrox = accelGyroRawData.getInt16(i * 2, Endian.little).toDouble();
      final gyroy =
          accelGyroRawData.getInt16(i * 2 + 40, Endian.little).toDouble();
      final gyroz =
          accelGyroRawData.getInt16(i * 2 + 80, Endian.little).toDouble();
      final accx =
          accelGyroRawData.getInt16(i * 2 + 120, Endian.little).toDouble();
      final accy =
          accelGyroRawData.getInt16(i * 2 + 160, Endian.little).toDouble();
      final accz =
          accelGyroRawData.getInt16(i * 2 + 200, Endian.little).toDouble();
      //natural order
      //final gyroRaw = Vector3(gyrox, gyroy, gyroz);
      //final accRaw = Vector3(accx, accy, accz);

      //so the axes align with the axes of the device
      final gyroRaw = Vector3(gyroy, -gyrox, gyroz);
      final accRaw = Vector3(accy, -accx, accz);

      var gyro = gyroRaw * gyroRadsScale;

      final accel = accRaw * accGScale;
      double dt = (canikTime - _lastCanikTime) / 20;

      RawData rawData = RawData(accel, gyro, canikTime + i * (dt));
      ret[i] = rawData;
      // _rawAccelGStreamController.sink.add(accel);
      // _rateRadStreamController.sink.add(gyro);
      // _orientationStreamController.sink.add(_ahrs.quaternion);
      // _deviceAccelGStreamController.sink.add(accel - gravitationalAccel);
    }
    _lastCanikTime = canikTime;
    return ret;
  }

  void onData(List<int> data) {
    var rawDataList = _proccessBufferedRawData(data);
    for (var rawData in rawDataList) {
      _controller.add(rawData);
    }
  }

  @override
  Stream<RawData> bind(Stream<List<int>> stream) {
    _stream = stream;
    return _controller.stream;
  }
}

class RawDataToProcessedDataTransformer
    extends StreamTransformerBase<RawData, ProcessedData> {
  late StreamController<ProcessedData> _controller;
  StreamSubscription<RawData>? _subscription;
  Stream<RawData>? _stream;
  bool cancelOnError;

  double _lastCanikTime;
  bool _firstData;
  final Madgwick _ahrs;
  double gravitationalAccelG;
  Vector3 gyroOffset;

  RawDataToProcessedDataTransformer(
      {double ahrsBeta = 0.5,
      this.gravitationalAccelG = 1,
      sync = false,
      this.cancelOnError = true})
      : _lastCanikTime = 0,
        _firstData = true,
        _ahrs = Madgwick(beta: ahrsBeta),
        gyroOffset = Vector3.zero() {
    _controller = StreamController<ProcessedData>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription?.pause();
        },
        onResume: () {
          _subscription?.resume();
        },
        sync: sync);
  }
  RawDataToProcessedDataTransformer.broadcast(
      {double ahrsBeta = 0.5,
      this.gravitationalAccelG = 1,
      sync = false,
      this.cancelOnError = true})
      : _lastCanikTime = 0,
        _firstData = true,
        _ahrs = Madgwick(beta: ahrsBeta),
        gyroOffset = Vector3.zero() {
    _controller = StreamController<ProcessedData>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }
  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onListen() {
    _subscription = _stream?.listen(onData,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  ProcessedData _proccessRawData(RawData data) {
    final double canikTime = data.time;
    if (_lastCanikTime == 0) {
      _lastCanikTime = canikTime;
    }
    if (_lastCanikTime > canikTime) {
      _lastCanikTime = 0;
    }
    final gyro = data.rateRad - gyroOffset;
    final accel = data.rawAccelG;
    double dt = (canikTime - _lastCanikTime);
    if (_firstData) {
      _firstData = false;
      final double tempBeta = _ahrs.beta;
      _ahrs.beta = 1000;
      _ahrs.updateIMU(gyro.x, gyro.y, gyro.z, accel.x, accel.y, accel.z, dt);
      _ahrs.beta = tempBeta;
    } else {
      _ahrs.updateIMU(gyro.x, gyro.y, gyro.z, accel.x, accel.y, accel.z, dt);
    }
    Vector3 gravitationalAccel =
        _ahrs.quaternion.rotate(Vector3(0, 0, gravitationalAccelG));
    ProcessedData processedData = ProcessedData(
        _ahrs.quaternion, accel, accel - gravitationalAccel, gyro, canikTime);

    _lastCanikTime = canikTime;
    return processedData;
  }

  void onData(RawData data) {
    _controller.add(_proccessRawData(data));
  }

  @override
  Stream<ProcessedData> bind(Stream<RawData> stream) {
    _stream = stream;
    return _controller.stream;
  }
}

class CanikDevice {
  final BluetoothDevice _device;

  final Madgwick _ahrs;

  late HolsterDrawSM _holsterDrawSM;

  late List<BluetoothService> services;

  final _processedDataStreamController = StreamController<ProcessedData>();
  late Stream<ProcessedData> _processedDataBroadcastStream;
  // final _orientationStreamController = StreamController<Quaternion>();
  // final _rawAccelGStreamController = StreamController<Vector3>();
  // final _deviceAccelGStreamController = StreamController<Vector3>();
  // final _rateRadStreamController = StreamController<Vector3>();
  final _stateStreamController = StreamController<BluetoothDeviceState>();

  final double gyroRadsScale;
  final double accGScale;
  double _lastCanikTime = 0;
  double _gravitationalAccelG = 1;
  Vector3 _gyroOffset;
  bool _firstData;
  //degrees2Radians * (6000) / 32767
  CanikDevice(this._device,
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      double ahrsBeta = 0.5,
      double drawThresholdG = 0.2,
      double rotatingAngularRateThreshDegS = 50,
      bool startHolsterDrawSM = false})
      : _ahrs = Madgwick(beta: ahrsBeta),
        _gyroOffset = Vector3.zero(),
        _firstData = true {
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
    // bufferedRawData.value
    //     .listen(_bufferedRawDataCallback, cancelOnError: false);
    //TODO: make the processors private variables and add calibration capabilities.
    _processedDataStreamController.sink.addStream(bufferedRawData.value
        .transform(BufferedRawDataToRawDataTransformer())
        .transform(RawDataToProcessedDataTransformer()));
  }

  void _bufferedRawDataCallback(List<int> rawData) {
    final byteBuffer = ByteData.sublistView(Uint8List.fromList(rawData));
    final int messageCounter = byteBuffer.getUint16(0, Endian.little);
    final health = byteBuffer.getUint8(2);
    final int timestamp =
        ByteData.sublistView(byteBuffer, 3).getUint32(0, Endian.little);

    final double canikTime = timestamp.toDouble() * 0.000025;
    if (_lastCanikTime == 0) {
      _lastCanikTime = canikTime;
    }
    if (_lastCanikTime > canikTime) {
      _lastCanikTime = 0;
    }
    final accelGyroRawData = ByteData.sublistView(byteBuffer, 7);
    for (int i = 0; i < 20; i++) {
      final gyrox = accelGyroRawData.getInt16(i * 2, Endian.little).toDouble();
      final gyroy =
          accelGyroRawData.getInt16(i * 2 + 40, Endian.little).toDouble();
      final gyroz =
          accelGyroRawData.getInt16(i * 2 + 80, Endian.little).toDouble();
      final accx =
          accelGyroRawData.getInt16(i * 2 + 120, Endian.little).toDouble();
      final accy =
          accelGyroRawData.getInt16(i * 2 + 160, Endian.little).toDouble();
      final accz =
          accelGyroRawData.getInt16(i * 2 + 200, Endian.little).toDouble();
      //natural order
      //final gyroRaw = Vector3(gyrox, gyroy, gyroz);
      //final accRaw = Vector3(accx, accy, accz);

      //so the axes align with the axes of the device
      final gyroRaw = Vector3(gyroy, -gyrox, gyroz);
      final accRaw = Vector3(accy, -accx, accz);

      var gyro = gyroRaw * gyroRadsScale;
      gyro -= gyroOffset;

      final accel = accRaw * accGScale;
      double dt = (canikTime - _lastCanikTime) / 20;
      if (_firstData) {
        _firstData = false;
        final double tempBeta = _ahrs.beta;
        _ahrs.beta = 1000;
        _ahrs.updateIMU(gyro.x, gyro.y, gyro.z, accel.x, accel.y, accel.z, dt);
        _ahrs.beta = tempBeta;
      } else {
        _ahrs.updateIMU(gyro.x, gyro.y, gyro.z, accel.x, accel.y, accel.z, dt);
      }
      Vector3 gravitationalAccel =
          _ahrs.quaternion.rotate(Vector3(0, 0, _gravitationalAccelG));
      ProcessedData processedData = ProcessedData(_ahrs.quaternion, accel,
          accel - gravitationalAccel, gyro, canikTime + i * (dt));

      _processedDataStreamController.sink.add(processedData);
      // _rawAccelGStreamController.sink.add(accel);
      // _rateRadStreamController.sink.add(gyro);
      // _orientationStreamController.sink.add(_ahrs.quaternion);
      // _deviceAccelGStreamController.sink.add(accel - gravitationalAccel);
    }
    _lastCanikTime = canikTime;
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
      print("Done.");
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
        _gyroOffset = (gyroSum / n.toDouble());
        _gravitationalAccelG = accelNormSum / n.toDouble();
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

  // get rateRadStream {
  //   return _rateRadStreamController.stream;
  // }

  // get rawAccelGStream {
  //   return _rawAccelGStreamController.stream;
  // }

  // get orientationStream {
  //   return _orientationStreamController.stream;
  // }

  // get deviceAccelGStream {
  //   return _deviceAccelGStreamController.stream;
  // }
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
    return _gravitationalAccelG;
  }

  Vector3 get gyroOffset {
    return _gyroOffset;
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
