import 'package:canik_lib/src/ahrs/ahrs.dart';
import "package:canik_lib/src/stream_transformer_helpers.dart";

import "package:vector_math/vector_math.dart";
import "dart:async";
import "dart:typed_data";

class ProcessedData {
  final double time;
  final Quaternion orientation;
  final Vector3 rawAccelG;
  final Vector3 deviceAccelG;
  final Vector3 rateRad;
  final Vector3? magNorm;

  ProcessedData(Quaternion orientation, Vector3 rawAccelG, Vector3 deviceAccelG,
      Vector3 rateRad, this.time)
      : orientation = orientation.clone(),
        rawAccelG = rawAccelG.clone(),
        deviceAccelG = deviceAccelG.clone(),
        rateRad = rateRad.clone(),
        magNorm = null;
  ProcessedData.withMag(Quaternion orientation, Vector3 rawAccelG,
      Vector3 deviceAccelG, Vector3 rateRad, Vector3 magNorm, this.time)
      : orientation = orientation.clone(),
        rawAccelG = rawAccelG.clone(),
        deviceAccelG = deviceAccelG.clone(),
        rateRad = rateRad.clone(),
        magNorm = magNorm;
  ProcessedData.zero({bool hasMag = false})
      : orientation = Quaternion.identity(),
        rawAccelG = Vector3.zero(),
        deviceAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        magNorm = hasMag ? Vector3.zero() : null,
        time = 0;
  ProcessedData copy() {
    if (magNorm != null) {
      return ProcessedData.withMag(orientation.clone(), rawAccelG.clone(),
          deviceAccelG.clone(), rateRad.clone(), magNorm!.clone(), time);
    } else {
      return ProcessedData(orientation.clone(), rawAccelG.clone(),
          deviceAccelG.clone(), rateRad.clone(), time);
    }
  }
}

class RawData {
  final double time;
  final Vector3 rawAccelG;
  final Vector3 rateRad;
  final Vector3? magNorm;
  RawData(Vector3 rawAccelG, Vector3 rateRad, this.time)
      : rawAccelG = rawAccelG.clone(),
        rateRad = rateRad.clone(),
        magNorm = null;
  RawData.withMag(
      Vector3 rawAccelG, Vector3 rateRad, Vector3 magNorm, this.time)
      : rawAccelG = rawAccelG.clone(),
        rateRad = rateRad.clone(),
        magNorm = magNorm.clone();
  RawData.zero({bool hasMag = false})
      : rawAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        magNorm = hasMag ? Vector3.zero() : null,
        time = 0;
  RawData copy() {
    if (magNorm != null) {
      return RawData.withMag(
          rawAccelG.clone(), rateRad.clone(), magNorm!.clone(), time);
    } else {
      return RawData(rawAccelG.clone(), rateRad.clone(), time);
    }
  }
}

class BufferedRawDataToRawDataTransformer
    extends StreamTransformerTemplate<List<int>, RawData> {
  double _lastCanikTime;
  final double gyroRadsScale;
  final double accGScale;

  BufferedRawDataToRawDataTransformer(
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      bool sync = false,
      bool cancelOnError = false})
      : _lastCanikTime = 0,
        super(cancelOnError: cancelOnError, sync: sync);

  BufferedRawDataToRawDataTransformer.broadcast(
      {this.gyroRadsScale = degrees2Radians * (250) / 32767,
      this.accGScale = 0.000061035,
      bool sync = false,
      bool cancelOnError = true})
      : _lastCanikTime = 0,
        super.broadcast(cancelOnError: cancelOnError, sync: sync);

  List<RawData> _proccessBufferedRawData(List<int> data) {
    if (data.isEmpty) {
      return [];
    }
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

      RawData rawData =
          RawData(accel.clone(), gyro.clone(), canikTime + i * (dt));
      ret[i] = rawData;
    }
    _lastCanikTime = canikTime;
    return ret;
  }

  @override
  void onData(List<int> data) {
    var rawDataList = _proccessBufferedRawData(data);
    for (var rawData in rawDataList) {
      publishData(rawData);
    }
  }

  @override
  void onStart() {
    _lastCanikTime = 0;
  }
}

class RawDataToProcessedDataTransformer<T extends Ahrs>
    extends PersistentStreamTransformerTemplate<RawData, ProcessedData> {
  double _lastCanikTime;
  final T _ahrs;
  double gravitationalAccelG;
  Vector3 gyroOffset;

  RawDataToProcessedDataTransformer(this._ahrs,
      {this.gravitationalAccelG = 1,
      bool sync = false,
      bool cancelOnError = false})
      : _lastCanikTime = 0,
        gyroOffset = Vector3.zero(),
        super(cancelOnError: cancelOnError, sync: sync);
  RawDataToProcessedDataTransformer.broadcast(this._ahrs,
      {this.gravitationalAccelG = 1, sync = false, bool cancelOnError = false})
      : _lastCanikTime = 0,
        gyroOffset = Vector3.zero(),
        super.broadcast(cancelOnError: cancelOnError, sync: sync);

  ProcessedData proccessRawData(RawData data) {
    final double canikTime = data.time;
    if (_lastCanikTime == 0) {
      _lastCanikTime = canikTime;
    }
    if (_lastCanikTime > canikTime) {
      _lastCanikTime = 0;
    }
    final gyro = data.rateRad - gyroOffset;
    final accel = data.rawAccelG;
    // double dt = min((canikTime - _lastCanikTime), 1 / 300); //TODO: clamp dt?
    double dt = (canikTime - _lastCanikTime); //TODO: clamp dt?
    if (data.magNorm == null) {
      _ahrs.updateIMU(gyro, accel, dt);
    } else {
      _ahrs.updateMag(gyro, accel, data.magNorm!, dt);
    }
    Vector3 gravitationalAccel =
        _ahrs.quaternion.rotate(Vector3(0, 0, gravitationalAccelG));
    ProcessedData processedData;
    if (data.magNorm == null) {
      processedData = ProcessedData(_ahrs.quaternion.clone(), accel.clone(),
          (accel - gravitationalAccel).clone(), gyro.clone(), canikTime);
    } else {
      processedData = ProcessedData.withMag(
          _ahrs.quaternion.normalized(),
          accel.clone(),
          (accel - gravitationalAccel).clone(),
          gyro.clone(),
          data.magNorm!.clone(),
          canikTime);
    }

    _lastCanikTime = canikTime;
    return processedData;
  }

  @override
  void onData(RawData data) {
    publishData(proccessRawData(data));
  }

  T get ahrs {
    return _ahrs;
  }
}
