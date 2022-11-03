import 'dart:math';

import 'package:csv/csv.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'package:canik_lib/canik_lib.dart';
import 'package:collection/collection.dart';

var rawDataToProcessedDataTransformer =
    RawDataToProcessedDataTransformer(aLambda1: 1, aLambda2: 2);

void main(List<String> args) {
  String path;
  if (args.isEmpty) {
    path = "../../test_data/DATA.csv";
  } else {
    path = args[0];
  }
  csvToProccessedData(path);
}

Future<List<List<dynamic>>> csvToProccessedData(String path) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    throw Exception("File not found");
  }
  double time = 0;
  var stream = File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
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
    var eulerRads = Vector3(list[7], list[8], list[9]) * degrees2Radians;
    time += dt;
    return [RawData(accel, gyro, time), eulerRads];
  }).map((data) {
    RawData rawData = data[0] as RawData;
    Vector3 eulerRads = data[1] as Vector3;
    rawDataToProcessedDataTransformer.proccessRawData(rawData);
    Quaternion quat = rawDataToProcessedDataTransformer.ahrs.quaternion;
    Quaternion validation =
        Quaternion.euler(eulerRads[0], eulerRads[1], eulerRads[2]);
    Quaternion diff = validation * quat.inverted();
    Vector2 yawPitchDiffRad = eulerRads.xy - quaternionToEuler(quat).xy;
    double angleDiff = 2 *
        atan2(
            sqrt(diff.x * diff.x + diff.y * diff.y + diff.z * diff.z), diff.w);

    return [rawData.time, eulerRads, quat];
  });

  return stream.toList();
}
