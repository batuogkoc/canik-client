import 'package:csv/csv.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'package:canik_lib/canik_lib.dart';

var rawDataToProcessedDataTransformer = RawDataToProcessedDataTransformer();

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
  }).map((dynamicList) {
    List<double> list = dynamicList.cast<double>();
    var accel = Vector3(list[0], list[1], list[2]) / 1000;
    var gyro = Vector3(list[3], list[4], list[5]);
    double dt = list[6];
    var euler = Vector3(list[7], list[8], list[9]);
    time += dt;
    return [RawData(accel, gyro, time), euler];
  }).map((data) {
    RawData rawData = data[0] as RawData;
    Vector3 euler = data[1] as Vector3;
    rawDataToProcessedDataTransformer.proccessRawData(rawData);
    Quaternion quat = rawDataToProcessedDataTransformer.ahrs.quaternion;
    Quaternion validation = Quaternion.euler(euler[2], euler[1], euler[0]);
    Quaternion difference = validation.inverted() * quat;
    return [quaternionToEuler(quat) * radians2Degrees, euler];
  });

  stream.forEach(print);
}
