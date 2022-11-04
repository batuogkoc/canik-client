import 'package:csv/csv.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'detectors/simplified_det.dart' as simplified_det;
import 'package:canik_lib/canik_lib.dart';

void main(List<String> args) {
  String path;
  if (args.isEmpty) {
    path = "../../test_data/DATA.csv";
  } else {
    path = args[0];
  }
  csvToProccessedData(path);
}

void csvToProccessedData(String path) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    return;
  }
  double time = 0;
  var stream = File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .where((event) {
        return event.every((element) {
          try {
            element as double;
          } catch (e) {
            return false;
          }
          return true;
        });
      })
      .map((dynamicList) {
        List<double> list = dynamicList.cast<double>();
        var accel = Vector3(list[0], list[1], list[2]) / 1000;
        var gyro = Vector3(list[3], list[4], list[5]);
        double dt = list[6];
        time += dt;
        return RawData(accel, gyro, time);
      })
      .transform(RawDataToProcessedDataTransformer(MadgwickAhrs({"beta": 0.1})))
      .asBroadcastStream();

  // stream.forEach((element) {
  //   if (element.deviceAccelG.length > 1) {
  //     print(element.deviceAccelG.length);
  //   }
  // });
  simplified_det.processedDataStream = stream;
  simplified_det.start();
}
