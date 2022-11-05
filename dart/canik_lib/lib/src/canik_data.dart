import 'package:canik_lib/src/ahrs/ahrs.dart';

import 'ahrs/madgwick_ahrs.dart';
import 'ahrs/scf_ahrs.dart';
import "package:vector_math/vector_math.dart";
import "dart:async";
import "dart:typed_data";

class ProcessedData {
  final double time;
  final Quaternion orientation;
  final Vector3 rawAccelG;
  final Vector3 deviceAccelG;
  final Vector3 rateRad;

  ProcessedData(Quaternion orientation, Vector3 rawAccelG, Vector3 deviceAccelG,
      Vector3 rateRad, this.time)
      : orientation = orientation.clone(),
        rawAccelG = rawAccelG.clone(),
        deviceAccelG = deviceAccelG.clone(),
        rateRad = rateRad.clone();
  ProcessedData.zero()
      : orientation = Quaternion.identity(),
        rawAccelG = Vector3.zero(),
        deviceAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        time = 0;
  ProcessedData copy() {
    return ProcessedData(orientation.clone(), rawAccelG.clone(),
        deviceAccelG.clone(), rateRad.clone(), time);
  }
}

class RawData {
  final double time;
  final Vector3 rawAccelG;
  final Vector3 rateRad;
  RawData(Vector3 rawAccelG, Vector3 rateRad, this.time)
      : rawAccelG = rawAccelG.clone(),
        rateRad = rateRad.clone();
  RawData.zero()
      : rawAccelG = Vector3.zero(),
        rateRad = Vector3.zero(),
        time = 0;
  RawData copy() {
    return RawData(rawAccelG.clone(), rateRad.clone(), time);
  }
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

      RawData rawData =
          RawData(accel.clone(), gyro.clone(), canikTime + i * (dt));
      ret[i] = rawData;
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

class RawDataToProcessedDataTransformer<T extends Ahrs>
    extends StreamTransformerBase<RawData, ProcessedData> {
  late StreamController<ProcessedData> _controller;
  StreamSubscription<RawData>? _subscription;
  Stream<RawData>? _stream;
  bool cancelOnError;

  double _lastCanikTime;
  final T _ahrs;
  double gravitationalAccelG;
  Vector3 gyroOffset;

  RawDataToProcessedDataTransformer(this._ahrs,
      {this.gravitationalAccelG = 1,
      bool sync = false,
      this.cancelOnError = false})
      : _lastCanikTime = 0,
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
  RawDataToProcessedDataTransformer.broadcast(this._ahrs,
      {this.gravitationalAccelG = 1, sync = false, this.cancelOnError = false})
      : _lastCanikTime = 0,
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
    double dt = (canikTime - _lastCanikTime);
    _ahrs.updateIMU(gyro, accel, dt);
    Vector3 gravitationalAccel =
        _ahrs.quaternion.rotate(Vector3(0, 0, gravitationalAccelG));
    ProcessedData processedData = ProcessedData(
        _ahrs.quaternion.clone(),
        accel.clone(),
        (accel - gravitationalAccel).clone(),
        gyro.clone(),
        canikTime);

    _lastCanikTime = canikTime;
    return processedData;
  }

  void onData(RawData data) {
    _controller.add(proccessRawData(data));
  }

  @override
  Stream<ProcessedData> bind(Stream<RawData> stream) {
    _stream = stream;
    return _controller.stream;
  }

  T get ahrs {
    return _ahrs;
  }
}
