import 'dart:async';
import 'package:dart_test/dart_test.dart';

void main(List<String> arguments) {
  var streamController = StreamController<int>();
  var transformer = TestTransformer.broadcast();
  var stream = transformer.outStream;

  // stream.listen((event) {
  //   print(event);
  // });

  var stream2 = streamController.stream.transform(transformer);
  print(stream == stream2);
  stream.listen((event) {
    print(event * 2);
  });
  streamController.add(1);
  streamController.add(10);
  streamController.add(100);
}
