// import 'dart:ffi';

import 'package:canik_lib/src/shot_det.dart';
import 'package:canik_lib/src/stream_transformer_helpers.dart';
import 'package:vector_math/vector_math.dart';
import 'canik_data.dart';
import 'utils.dart';

enum HolsterDrawState { idle, withdrawGun, rotating, targeting, shot, stop }

enum HolsterDrawResultState {
  notBegun,
  rotatingTimeout,
  targetingTimeout,
  shotWhileTargeting,
  shotTimeout,
  shot
}

class HolsterDrawResult {
  final DateTime startTime;
  final double? gripTime;
  final double? withdrawGunTime;
  final double? rotatingTime;
  final double? targetingTime;
  final double? shotTime;
  final HolsterDrawResultState state;
  HolsterDrawResult.zero()
      : state = HolsterDrawResultState.notBegun,
        startTime = DateTime(0),
        gripTime = 0,
        withdrawGunTime = 0,
        rotatingTime = 0,
        targetingTime = 0,
        shotTime = 0;
  HolsterDrawResult.notBegun(this.startTime)
      : state = HolsterDrawResultState.notBegun,
        gripTime = null,
        withdrawGunTime = null,
        rotatingTime = null,
        targetingTime = null,
        shotTime = null;

  HolsterDrawResult.rotatingTimeout(this.startTime, double gripTime,
      double withdrawGunTime, double rotatingTime)
      : state = HolsterDrawResultState.rotatingTimeout,
        gripTime = gripTime,
        withdrawGunTime = withdrawGunTime,
        rotatingTime = rotatingTime,
        targetingTime = null,
        shotTime = null;

  HolsterDrawResult.targetingTimeout(this.startTime, double gripTime,
      double withdrawGunTime, double rotatingTime, double targetingTime)
      : state = HolsterDrawResultState.targetingTimeout,
        gripTime = gripTime,
        withdrawGunTime = withdrawGunTime,
        rotatingTime = rotatingTime,
        targetingTime = targetingTime,
        shotTime = null;

  HolsterDrawResult.shotWhileTargeting(this.startTime, double gripTime,
      double withdrawGunTime, double rotatingTime, double targetingTime)
      : state = HolsterDrawResultState.shotWhileTargeting,
        gripTime = gripTime,
        withdrawGunTime = withdrawGunTime,
        rotatingTime = rotatingTime,
        targetingTime = targetingTime,
        shotTime = null;
  HolsterDrawResult.shotTimeout(
      this.startTime,
      double gripTime,
      double withdrawGunTime,
      double rotatingTime,
      double targetingTime,
      double shotTime)
      : state = HolsterDrawResultState.shotTimeout,
        gripTime = gripTime,
        withdrawGunTime = withdrawGunTime,
        rotatingTime = rotatingTime,
        targetingTime = targetingTime,
        shotTime = shotTime;
  HolsterDrawResult.shot(
      this.startTime,
      double gripTime,
      double withdrawGunTime,
      double rotatingTime,
      double targetingTime,
      double shotTime)
      : state = HolsterDrawResultState.shot,
        gripTime = gripTime,
        withdrawGunTime = withdrawGunTime,
        rotatingTime = rotatingTime,
        targetingTime = targetingTime,
        shotTime = shotTime;

  double getTotalTime() {
    return (gripTime ?? 0.0) +
        (withdrawGunTime ?? 0.0) +
        (rotatingTime ?? 0.0) +
        (targetingTime ?? 0.0) +
        (shotTime ?? 0.0);
    // return (gripTime ?? 0.0);
  }

  List<double?> getTimesNullable() {
    return [
      gripTime,
      withdrawGunTime,
      rotatingTime,
      targetingTime,
      shotTime,
    ];
  }

  List<double> getTimes() {
    return getTimesNullable().map((e) => e ?? 0).toList();
  }
}

class HolsterDrawSM {
  bool stateCallbackOnChange;
  HolsterDrawState _state;
  final Stopwatch _gripStopwatch = Stopwatch();
  final Stopwatch _withdrawGunStopwatch = Stopwatch();
  final Stopwatch _rotatingStopwatch = Stopwatch();
  final Stopwatch _targetingStopwatch = Stopwatch();
  final Stopwatch _shotStopwatch = Stopwatch();
  ShotDetector shotDetector;
  late DateTime _startTime;
  double drawThresholdG;
  double rotatingAngularRateThreshDegS;
  late Quaternion _initialOrientation;
  void Function(HolsterDrawState)? onStateUpdate;
  void Function(HolsterDrawResult)? onResult;

  HolsterDrawSM(this.drawThresholdG, this.rotatingAngularRateThreshDegS,
      this.shotDetector,
      {this.onStateUpdate, this.onResult, this.stateCallbackOnChange = true})
      : _state = HolsterDrawState.stop {
    _updateState(HolsterDrawState.stop);
  }

  bool start() {
    if (state == HolsterDrawState.stop) {
      _gripStopwatch.stop();
      _withdrawGunStopwatch.stop();
      _rotatingStopwatch.stop();
      _targetingStopwatch.stop();
      _shotStopwatch.stop();
      _gripStopwatch.reset();
      _withdrawGunStopwatch.reset();
      _rotatingStopwatch.reset();
      _targetingStopwatch.reset();
      _shotStopwatch.reset();
      _updateState(HolsterDrawState.idle);
      return true;
    } else {
      return false;
    }
  }

  bool stop() {
    if (state != HolsterDrawState.stop) {
      _gripStopwatch.stop();
      _withdrawGunStopwatch.stop();
      _rotatingStopwatch.stop();
      _targetingStopwatch.stop();
      _shotStopwatch.stop();
      _updateState(HolsterDrawState.stop);
      return true;
    } else {
      return false;
    }
  }

  void onData(ProcessedData data) {
    switch (state) {
      case HolsterDrawState.idle:
        if (_gripStopwatch.isRunning == false) {
          _startTime = DateTime.now();
          _gripStopwatch.start();
        }
        if (data.deviceAccelG.length > drawThresholdG) {
          _gripStopwatch.stop();
          _updateState(HolsterDrawState.withdrawGun,
              callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.withdrawGun:
        if (_withdrawGunStopwatch.isRunning == false) {
          _withdrawGunStopwatch.start();
          _initialOrientation = data.orientation.clone();
        }
        Quaternion difference =
            _initialOrientation.inverted() * data.orientation;
        double currentPitch =
            quaternionToEuler(data.orientation).y * radians2Degrees;
        double initialPitch =
            quaternionToEuler(_initialOrientation).y * radians2Degrees;
        double angularDifferenceDeg = 0;
        if (initialPitch < 0) {
          angularDifferenceDeg = currentPitch < 0
              ? currentPitch - initialPitch
              : (currentPitch - 180).abs() + initialPitch + 180;
        } else {
          angularDifferenceDeg = currentPitch < 0
              ? currentPitch + 180 + (initialPitch - 180).abs()
              : currentPitch - initialPitch;
        }
        double angularRateDeg = data.rateRad.y * radians2Degrees;
        print("${degrees(difference.radians).abs()} ${angularDifferenceDeg}");
        if (angularDifferenceDeg.abs() < 3 &&
            angularRateDeg.abs() > rotatingAngularRateThreshDegS) {
          _withdrawGunStopwatch.stop();
          _updateState(HolsterDrawState.rotating,
              callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.rotating:
        if (_rotatingStopwatch.isRunning == false) {
          _rotatingStopwatch.start();
        }
        var euler = quaternionToEuler(data.orientation) * radians2Degrees;
        if (_rotatingStopwatch.elapsedMilliseconds > 2000) {
          _rotatingStopwatch.stop();
          _onResult(HolsterDrawResult.rotatingTimeout(
              _startTime,
              _gripStopwatch.elapsedMilliseconds.toDouble() / 1000,
              _withdrawGunStopwatch.elapsedMilliseconds.toDouble() / 1000,
              _rotatingStopwatch.elapsedMilliseconds.toDouble() / 1000));
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        } else if (euler.y.abs() < 3) {
          _rotatingStopwatch.stop();
          _updateState(HolsterDrawState.targeting,
              callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.targeting:
        if (_targetingStopwatch.isRunning == false) {
          _targetingStopwatch.start();
        }
        bool shotDetected = shotDetection(data);
        if (shotDetected || _targetingStopwatch.elapsedMilliseconds > 2000) {
          _targetingStopwatch.stop();
          if (shotDetected) {
            _onResult(HolsterDrawResult.shotWhileTargeting(
                _startTime,
                _gripStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _withdrawGunStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _rotatingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _targetingStopwatch.elapsedMilliseconds.toDouble() / 1000));
          } else {
            _onResult(HolsterDrawResult.targetingTimeout(
                _startTime,
                _gripStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _withdrawGunStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _rotatingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _targetingStopwatch.elapsedMilliseconds.toDouble() / 1000));
          }
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        } else if (data.deviceAccelG.length < 0.04) {
          _targetingStopwatch.stop();
          _updateState(HolsterDrawState.shot, callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.shot:
        if (_shotStopwatch.isRunning == false) {
          _shotStopwatch.start();
        }
        bool shotDetected = shotDetection(data);
        if (shotDetected || _shotStopwatch.elapsedMilliseconds > 2000) {
          _shotStopwatch.stop();
          if (shotDetected) {
            _onResult(HolsterDrawResult.shot(
                _startTime,
                _gripStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _withdrawGunStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _rotatingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _targetingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _shotStopwatch.elapsedMilliseconds.toDouble() / 1000));
          } else {
            _onResult(HolsterDrawResult.shotTimeout(
                _startTime,
                _gripStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _withdrawGunStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _rotatingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _targetingStopwatch.elapsedMilliseconds.toDouble() / 1000,
                _shotStopwatch.elapsedMilliseconds.toDouble() / 1000));
          }
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        }
        break;
      default:
    }
    if (!stateCallbackOnChange) {
      _updateStateCallback();
    }
  }
  // HolsterDrawResult _generateNotBegun(){}
  // HolsterDrawResult _generateRotatingTimeout(){}
  // HolsterDrawResult _generateTargetingTimeout(){}
  // HolsterDrawResult _generateShotWhileTargeting(){}
  // HolsterDrawResult _generateShotTimeout(){}
  // HolsterDrawResult _generateShot(){}

  void _updateStateCallback() {
    onStateUpdate?.call(state);
  }

  void _updateState(HolsterDrawState state, {bool callback = true}) {
    _state = state;
    if (callback) {
      print(state);
      _updateStateCallback();
    }
  }

  void _onResult(HolsterDrawResult result) {
    print(result.state.name);
    onResult?.call(result);
  }

  bool shotDetection(ProcessedData data) {
    return shotDetector.onDataReceive(data) != null;
  }

  get state {
    return _state;
  }
}

// class HolsterDrawSMTransformer extends PersistentStreamTransformerTemplate<
//     ProcessedData, HolsterDrawState> {
//   final HolsterDrawSM _holsterDrawSM;

//   HolsterDrawSMTransformer(this._holsterDrawSM,
//       {bool cancelOnError = false, bool sync = false})
//       : super(cancelOnError: cancelOnError, sync: sync) {
//     _holsterDrawSM.onStateUpdate = publishData;
//   }

//   HolsterDrawSMTransformer.broadcast(this._holsterDrawSM,
//       {bool cancelOnError = false, bool sync = false})
//       : super.broadcast(cancelOnError: cancelOnError, sync: sync) {
//     _holsterDrawSM.onStateUpdate = publishData;
//   }

//   @override
//   void onData(ProcessedData data) {
//     _holsterDrawSM.onData(data);
//   }

//   HolsterDrawSM get holsterDrawSM {
//     return _holsterDrawSM;
//   }
// }
