import 'dart:async';
import 'package:vector_math/vector_math.dart';
import "canik_backend.dart";

enum HolsterDrawState {
  idle,
  withdrawGun,
  rotating,
  targeting,
  shot,
  stop
} //TODO: Stop?

class HolsterDrawSM {
  bool updateStateStreamOnChange;
  HolsterDrawState _state;
  final Stream<ProcessedData> _processedDataStream;
  bool _firstIdle;
  bool _firstWithdrawGun;
  late DateTime _withdrawGunStart;
  late DateTime _rotatingStart;
  late DateTime _targetingStart;
  late DateTime _shotStart;
  late DateTime _startTime;
  double drawThresholdG;
  double rotatingAngularRateThreshDegS;
  late Quaternion _initialOrientation;

  final StreamController<HolsterDrawState> _stateStreamController =
      StreamController<HolsterDrawState>();
  late Stream<HolsterDrawState> _stateBroadcastStream;
  HolsterDrawSM(this._processedDataStream, this.drawThresholdG,
      this.rotatingAngularRateThreshDegS,
      {this.updateStateStreamOnChange = true})
      : _state = HolsterDrawState.stop,
        _firstIdle = true,
        _firstWithdrawGun = true {
    _stateBroadcastStream = _stateStreamController.stream.asBroadcastStream();
    _updateState(HolsterDrawState.stop);
    _startStreamListen();
  }

  void _startStreamListen() {
    _processedDataStream.forEach(_update);
  }

  bool start() {
    if (state == HolsterDrawState.stop) {
      _updateState(HolsterDrawState.idle);
      return true;
    } else {
      return false;
    }
  }

  bool stop() {
    if (state != HolsterDrawState.stop) {
      _updateState(HolsterDrawState.stop);
      _firstIdle = true;
      _firstWithdrawGun = true;
      return true;
    } else {
      return false;
    }
  }

  void _update(ProcessedData data) {
    switch (state) {
      case HolsterDrawState.idle:
        if (_firstIdle) {
          _firstIdle = false;
          _startTime = DateTime.now();
        }
        if (data.deviceAccelG.length > drawThresholdG) {
          _updateState(HolsterDrawState.withdrawGun,
              updateStream: updateStateStreamOnChange);
        }
        break;
      case HolsterDrawState.withdrawGun:
        if (_firstWithdrawGun) {
          _firstWithdrawGun = false;
          _initialOrientation = data.orientation;
          _withdrawGunStart = DateTime.now();
        }
        Quaternion difference =
            _initialOrientation.inverted() * data.orientation;
        print((quaternionToEuler(difference) * radians2Degrees));
        print(difference.radians * radians2Degrees);
        double angularRateDeg = degrees(difference.radians) /
            (DateTime.now()
                    .difference(_withdrawGunStart)
                    .inMicroseconds
                    .toDouble() /
                1000000);
        if (degrees(difference.radians).abs() < 3 &&
            angularRateDeg > rotatingAngularRateThreshDegS) {
          _updateState(HolsterDrawState.rotating,
              updateStream: updateStateStreamOnChange);
          _rotatingStart = DateTime.now();
        }
        //TODO: What does orientation<0 mean?
        break;
      case HolsterDrawState.rotating:
        if (DateTime.now().difference(_rotatingStart).inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop,
              updateStream: updateStateStreamOnChange);
        } else if (quaternionToEuler(data.orientation).y.abs() < 3) {
          _targetingStart = DateTime.now();
          _updateState(HolsterDrawState.targeting,
              updateStream: updateStateStreamOnChange);
        }
        break;
      case HolsterDrawState.targeting:
        bool shotDetected = shotDetection();
        if (shotDetected ||
            DateTime.now().difference(_targetingStart).inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop,
              updateStream: updateStateStreamOnChange);
        } else if (data.deviceAccelG.length < 0.04) {
          _shotStart = DateTime.now();
          _updateState(HolsterDrawState.shot,
              updateStream: updateStateStreamOnChange);
        }
        break;
      case HolsterDrawState.shot:
        bool shotDetected = shotDetection();
        if (shotDetected ||
            DateTime.now().difference(_shotStart).inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop,
              updateStream: updateStateStreamOnChange);
        }
        break;
      default:
    }
    if (!updateStateStreamOnChange) {
      _updateStateStream();
    }
  }

  void _updateStateStream() {
    _stateStreamController.sink.add(state);
  }

  void _updateState(HolsterDrawState state, {bool updateStream = true}) {
    _state = state;
    if (updateStream) {
      _updateStateStream();
    }
  }

  //TODO: Shot detection
  bool shotDetection() {
    return true;
  }

  get state {
    return _state;
  }

  get stateStream {
    return _stateBroadcastStream;
  }
}
