import 'dart:async';
import 'dart:io';
import 'package:canik_lib/src/stream_logger.dart';

void main(List<String> arguments) async {
  StreamController<List<int>> controller =
      StreamController<List<int>>.broadcast();
  controller.stream.listen((event) {
    print(event);
  });
  // var sl = StreamLogger(controller.stream, (element) => element.cast());
  // sl.start();
  print("a");
  controller.sink.add([1, 1]);
  sleep(Duration(seconds: 1));
  print("b");
  controller.sink.add([2, 2]);
  sleep(Duration(seconds: 1));
  print("c");
  // await sl.stop();
}
