import 'package:canik_flutter/madgwick_ahrs.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import "dart:async";
import "package:vector_math/vector_math.dart";
import "dart:typed_data";
import "dart:math";

Vector3 quaternionToEuler(Quaternion q) {
  double w = q.w;
  double x = q.x;
  double y = q.y;
  double z = q.z;
  Vector3 ret = Vector3.zero(); //yaw pitch roll

  //roll (x-axis rotation)
  double sinr_cosp = 2 * (w * x + y * z);
  double cosr_cosp = 1 - 2 * (x * x + y * y);
  ret.z = atan2(sinr_cosp, cosr_cosp);

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
  ret.x = atan2(siny_cosp, cosy_cosp);

  return ret;
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

class CanikDevice {
  final BluetoothDevice _device;

  final Madgwick _ahrs;

  late List<BluetoothService> services;

  final _orientationStreamController = StreamController<Quaternion>();
  final _rawAccelGStreamController = StreamController<Vector3>();
  final _deviceAccelGStreamController = StreamController<Vector3>();
  final _rateRadStreamController = StreamController<Vector3>();

  final double gyroRadsScale;
  final double accGScale;
  double _lastCanikTime = 0;
  CanikDevice(this._device,
      {this.gyroRadsScale = 0.000635783 * (pi / 180),
      this.accGScale = 0.000061035,
      double ahrsBeta = 0.1})
      : _ahrs = Madgwick(beta: ahrsBeta);
  Future<void> connect({
    Duration? timeout,
    bool autoConnect = true,
  }) async {
    await _device.connect(timeout: timeout, autoConnect: autoConnect);
    services = await _device.discoverServices();
    if (CanikUtilities.checkIfCanik(services) == false) {
      _device.disconnect();
      throw Exception("The bluetooth device is not a Canik device");
    }
    await _notifyToBufferedRawData();
  }

  Future<void> _notifyToBufferedRawData() async {
    final bufferedRawData = CanikUtilities.findCharacteristic(
        services, CanikCharacteristics.bufferedRawData);
    await bufferedRawData!.setNotifyValue(true);
    bufferedRawData.value
        .listen(_bufferedRawDataCallback, cancelOnError: false);
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
      final gyroRaw = Vector3(gyrox, gyroy, gyroz);
      final accRaw = Vector3(accx, accy, accz);
      final gyro = gyroRaw * gyroRadsScale;
      final accel = accRaw * accGScale;
      _ahrs.updateIMU(gyro.x, gyro.y, gyro.z, accel.x, accel.y, accel.z,
          (canikTime - _lastCanikTime) / 20);
      _lastCanikTime = canikTime;

      _rawAccelGStreamController.sink.add(accel);
      _rateRadStreamController.sink.add(gyro);
      _orientationStreamController.sink.add(_ahrs.quaternion);
    }
  }

  get rateRadStream {
    return _rateRadStreamController.stream;
  }

  get rawAccelGStream {
    return _rawAccelGStreamController.stream;
  }

  get orientationStream {
    return _orientationStreamController.stream;
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

  getRssi() {
    return _device.readRssi();
  }

  disconnect() {
    return _device.disconnect();
  }
}
