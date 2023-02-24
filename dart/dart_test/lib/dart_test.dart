import 'dart:async';

class TestTransformer extends StreamTransformerBase<int, int> {
  late StreamController<int> _controller;
  StreamSubscription<int>? _subscription;
  Stream<int>? _stream;
  bool cancelOnError;

  TestTransformer({bool sync = false, this.cancelOnError = false}) {
    _controller = StreamController<int>(
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
  TestTransformer.broadcast({sync = false, this.cancelOnError = false}) {
    _controller = StreamController<int>.broadcast(
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

  void onData(int data) {
    _controller.add(data * 2);
  }

  @override
  Stream<int> bind(Stream<int> stream) {
    _stream = stream;
    return _controller.stream;
  }

  Stream<int> get outStream {
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
