import 'dart:async';
import 'package:circular_buffer/circular_buffer.dart';

import 'canik_data.dart';
import 'package:vector_math/vector_math.dart';
import 'utils.dart';

class YawPitchVisualiser
    extends StreamTransformerBase<ProcessedData, List<Vector2>> {
  late StreamController<List<Vector2>> _controller;
  StreamSubscription<ProcessedData>? _subscription;
  Stream<ProcessedData>? _stream;
  bool cancelOnError;
  double dataCaptureFraction;
  int _droppedDataCount;

  CircularBuffer<Vector2> output;

  YawPitchVisualiser(int size,
      {this.dataCaptureFraction = 0.1,
      sync = false,
      this.cancelOnError = false})
      : output = CircularBuffer<Vector2>(size),
        _droppedDataCount = 0 {
    assert(dataCaptureFraction >= 0 && dataCaptureFraction <= 1.0);
    _controller = StreamController<List<Vector2>>(
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
  YawPitchVisualiser.broadcast(int size,
      {this.dataCaptureFraction = 1,
      bool sync = false,
      this.cancelOnError = true})
      : output = CircularBuffer<Vector2>(size),
        _droppedDataCount = 0 {
    assert(dataCaptureFraction >= 0 && dataCaptureFraction <= 1.0);

    _controller = StreamController<List<Vector2>>.broadcast(
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

  void onData(ProcessedData data) {
    Vector2 ret = data.orientation.toEuler().zy * radians2Degrees;
    ret *= -1;
    output.add(ret);
    _controller.add(output.toList());

    // if (_droppedDataCount * (1 - dataCaptureFraction) >= 1) {
    // }
    _droppedDataCount++;
  }

  @override
  Stream<List<Vector2>> bind(Stream<ProcessedData> stream) {
    _stream = stream;
    return _controller.stream;
  }
}
