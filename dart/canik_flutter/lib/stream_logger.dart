import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

class StreamLogger<T> {
  final Stream<T> inputStream;
  final List<dynamic> Function(T) toStringList;
  final Directory logDirectory;
  late StreamSubscription _streamSubscription;
  final StreamController<bool> _stateStreamController = StreamController();

  late IOSink _sink;

  final String? header;

  StreamLogger(this.inputStream, this.toStringList, this.logDirectory,
      {this.header});

  Future<void> start() async {
    _sink = File(path.join(logDirectory.path,
            "log-${DateTime.now().toIso8601String().replaceAll(":", ".")}.csv"))
        .openWrite();
    var stream = inputStream.map(toStringList).map((event) {
      return event.join(", ");
    });

    if (header != null) {
      _sink.writeln(header);
    }
    // _sink.writeln("header");
    _streamSubscription = stream.listen((event) {
      _sink.writeln(event);
    });
    _stateStreamController.sink.add(true);
  }

  Future<void> stop() async {
    await _streamSubscription.cancel();
    await _sink.close();
    _stateStreamController.sink.add(false);
  }

  Stream<bool> get isActive {
    return _stateStreamController.stream;
  }
}
