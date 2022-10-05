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

  HolsterDrawSM(this._processedDataStream, this.drawThresholdG,
      this.rotatingAngularRateThreshDegS,
      {this.updateStateStreamOnChange = true})
      : _state = HolsterDrawState.idle,
        _firstIdle = true,
        _firstWithdrawGun = true {
    _updateStateStream();
  }

  void start() {
    _processedDataStream.forEach(_update);
  }

  void _update(ProcessedData data) {
    switch (_state) {
      case HolsterDrawState.idle:
        if (_firstIdle) {
          _firstIdle = false;
          _startTime = DateTime.now();
        }
        if (data.deviceAccelG.length > drawThresholdG) {
          _state = HolsterDrawState.withdrawGun;
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
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
        double angularRateDeg = degrees(difference.radians) /
            (DateTime.now()
                    .difference(_withdrawGunStart)
                    .inMicroseconds
                    .toDouble() /
                1000000);
        if (degrees(difference.radians).abs() < 3 &&
            angularRateDeg > rotatingAngularRateThreshDegS) {
          _state = HolsterDrawState.rotating;
          _rotatingStart = DateTime.now();
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        }
        //TODO: What does orientation<0 mean?
        break;
      case HolsterDrawState.rotating:
        if (DateTime.now().difference(_rotatingStart).inMilliseconds > 2000) {
          _state = HolsterDrawState.stop;
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        } else if (quaternionToEuler(data.orientation).y.abs() < 3) {
          _state = HolsterDrawState.targeting;
          _targetingStart = DateTime.now();
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        }
        break;
      case HolsterDrawState.targeting:
        bool shotDetected = shotDetection();
        if (shotDetected ||
            DateTime.now().difference(_targetingStart).inMilliseconds > 2000) {
          _state = HolsterDrawState.stop;
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        } else if (data.deviceAccelG.length < 0.04) {
          _state = HolsterDrawState.shot;
          _shotStart = DateTime.now();
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        }
        break;
      case HolsterDrawState.shot:
        bool shotDetected = shotDetection();
        if (shotDetected ||
            DateTime.now().difference(_shotStart).inMilliseconds > 2000) {
          _state = HolsterDrawState.stop;
          if (updateStateStreamOnChange) {
            _updateStateStream();
          }
        }
        break;
      default:
    }
    if (!updateStateStreamOnChange) {
      _updateStateStream();
    }
  }

  void _updateStateStream() {
    _stateStreamController.sink.add(_state);
  }

  //TODO: Shot detection
  bool shotDetection() {
    return true;
  }

  get state {
    return _state;
  }

  get stateStream {
    return _stateStreamController.stream;
  }
}
