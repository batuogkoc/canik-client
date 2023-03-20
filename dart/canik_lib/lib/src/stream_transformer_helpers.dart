import 'dart:async';

abstract class StreamTransformerTemplate<S, T>
    extends StreamTransformerBase<S, T> {
  late StreamController<T> _controller;
  StreamSubscription<S>? _subscription;
  Stream<S>? _stream;
  bool cancelOnError;

  StreamTransformerTemplate({bool sync = false, this.cancelOnError = false}) {
    _controller = StreamController<T>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription?.pause();
          onStop();
        },
        onResume: () {
          onStart();
          _subscription?.resume();
        },
        sync: sync);
  }
  StreamTransformerTemplate.broadcast(
      {sync = false, this.cancelOnError = false}) {
    _controller = StreamController<T>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }
  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
    onStop();
  }

  void _onListen() {
    onStart();
    _subscription = _stream?.listen(_onDataReceive,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  void onStop() {}
  void onStart() {}

  void _onDataReceive(S data) {
    try {
      onData(data);
    } catch (e) {
      _controller.addError(e);
    }
  }

  void onData(S data);

  void publishData(T data) {
    _controller.add(data);
  }

  @override
  Stream<T> bind(Stream<S> stream) {
    _stream = stream;
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}

abstract class PersistentStreamTransformerTemplate<S, T>
    extends StreamTransformerBase<S, T> {
  late StreamController<T> _controller;
  StreamSubscription<S>? _subscription;
  Stream<S>? _stream;
  bool cancelOnError;

  PersistentStreamTransformerTemplate(
      {bool sync = false, this.cancelOnError = false}) {
    _controller = StreamController<T>(sync: sync);
  }
  PersistentStreamTransformerTemplate.broadcast(
      {sync = false, this.cancelOnError = false}) {
    _controller = StreamController<T>.broadcast(sync: sync);
  }

  void _listen() {
    onStart();
    _subscription = _stream?.listen(_onDataReceive,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  void _onDataReceive(S data) {
    try {
      onData(data);
    } catch (e) {
      _controller.addError(e);
    }
  }

  void onData(S data);

  void publishData(T data) {
    _controller.add(data);
  }

  void onStart() {}

  @override
  Stream<T> bind(Stream<S> stream) {
    _stream = stream;
    _listen();
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }
}
