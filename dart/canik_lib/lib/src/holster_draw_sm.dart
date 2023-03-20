import 'package:canik_lib/src/stream_transformer_helpers.dart';
import 'package:vector_math/vector_math.dart';
import 'canik_data.dart';
import 'utils.dart';

enum HolsterDrawState { idle, withdrawGun, rotating, targeting, shot, stop }

class HolsterDrawSM {
  bool stateCallbackOnChange;
  HolsterDrawState _state;
  // final Stream<ProcessedData> _processedDataStream;
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
  void Function(HolsterDrawState)? onStateUpdate;

  HolsterDrawSM(this.drawThresholdG, this.rotatingAngularRateThreshDegS,
      {this.onStateUpdate, this.stateCallbackOnChange = true})
      : _state = HolsterDrawState.stop,
        _firstIdle = true,
        _firstWithdrawGun = true {
    _updateState(HolsterDrawState.stop);
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

  void onData(ProcessedData data) {
    switch (state) {
      case HolsterDrawState.idle:
        if (_firstIdle) {
          _firstIdle = false;
          _startTime = DateTime.now();
        }
        if (data.deviceAccelG.length > drawThresholdG) {
          _updateState(HolsterDrawState.withdrawGun,
              callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.withdrawGun:
        if (_firstWithdrawGun) {
          _firstWithdrawGun = false;
          _initialOrientation = data.orientation.clone();
          _withdrawGunStart = DateTime.now();
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
          _updateState(HolsterDrawState.rotating,
              callback: stateCallbackOnChange);
          _rotatingStart = DateTime.now();
        }
        break;
      case HolsterDrawState.rotating:
        var euler = quaternionToEuler(data.orientation) * radians2Degrees;
        if (DateTime.now().difference(_rotatingStart).inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        } else if (euler.y.abs() < 3) {
          _targetingStart = DateTime.now();
          _updateState(HolsterDrawState.targeting,
              callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.targeting:
        bool shotDetected = shotDetection();
        var timeDifference = DateTime.now().difference(_targetingStart);
        if (shotDetected || timeDifference.inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        } else if (data.deviceAccelG.length < 0.04) {
          _shotStart = DateTime.now();
          _updateState(HolsterDrawState.shot, callback: stateCallbackOnChange);
        }
        break;
      case HolsterDrawState.shot:
        bool shotDetected = shotDetection();
        if (shotDetected ||
            DateTime.now().difference(_shotStart).inMilliseconds > 2000) {
          _updateState(HolsterDrawState.stop, callback: stateCallbackOnChange);
        }
        break;
      default:
    }
    if (!stateCallbackOnChange) {
      _updateStateCallback();
    }
  }

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

  //TODO: Shot detection
  bool shotDetection() {
    return true;
  }

  get state {
    return _state;
  }
}

class HolsterDrawSMTransformer extends PersistentStreamTransformerTemplate<
    ProcessedData, HolsterDrawState> {
  final HolsterDrawSM _holsterDrawSM;

  HolsterDrawSMTransformer(this._holsterDrawSM,
      {bool cancelOnError = false, bool sync = false})
      : super(cancelOnError: cancelOnError, sync: sync) {
    _holsterDrawSM.onStateUpdate = publishData;
  }

  HolsterDrawSMTransformer.broadcast(this._holsterDrawSM,
      {bool cancelOnError = false, bool sync = false})
      : super.broadcast(cancelOnError: cancelOnError, sync: sync) {
    _holsterDrawSM.onStateUpdate = publishData;
  }

  @override
  void onData(ProcessedData data) {
    _holsterDrawSM.onData(data);
  }

  HolsterDrawSM get holsterDrawSM {
    return _holsterDrawSM;
  }
}
