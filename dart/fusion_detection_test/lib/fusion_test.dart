import 'dart:math';

import 'package:csv/csv.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'package:canik_lib/canik_lib.dart';
import 'package:collection/collection.dart';

var madgwickTransformer = RawDataToProcessedDataTransformer(
    ScfAhrs({"aLambda1": 0.1, "aLambda2": 1}));
var scfTransformer =
    RawDataToProcessedDataTransformer(MadgwickAhrs({"beta": 0.5}));

void main(List<String> args) {
  String path;
  if (args.isEmpty) {
    path = "../../test_data/DATA.csv";
  } else {
    path = args[0];
  }
  csvToProccessedData(path);
}

Future<List<Map<String, dynamic>>> csvToProccessedData(String path) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    throw Exception("File not found");
  }
  double time = 0;
  int index = 0;
  var list = await File(path)
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
    var gyro = Vector3(list[3], list[4], list[5]); //TODO: z axis of the gyro
    double dt = list[6];
    var eulerRads = Vector3(list[7], list[8], list[9]) * degrees2Radians;
    time += dt;
    return [RawData(accel, gyro, time), eulerRads];
  }).toList();
  bool firstTime = true;
  double lastTime = 0;
  list.sort((a, b) => (a[0] as RawData).time.compareTo((b[0] as RawData).time));
  return list.map((data) {
    RawData rawData = data[0] as RawData;
    Vector3 eulerRads = data[1] as Vector3;
    double dt;
    if (firstTime == true) {
      firstTime == false;
      lastTime = rawData.time;
      dt = 0;
      // madgwickTransformer.ahrs.quaternion =
      //     Quaternion.euler(eulerRads.z, eulerRads.y, eulerRads.x);
      // scfTransformer.ahrs.quaternion =
      //     Quaternion.euler(eulerRads.z, eulerRads.y, eulerRads.x);
    } else {
      dt = rawData.time - lastTime;
      lastTime = rawData.time;
    }

    ProcessedData madgwickProcessedData =
        madgwickTransformer.proccessRawData(rawData.copy());
    ProcessedData scfProcessedData =
        scfTransformer.proccessRawData(rawData.copy());
    if (dt > 0.002) {
      print(dt);
    }
    return <String, dynamic>{
      "index": index++,
      "time": rawData.time,
      "dt": dt,
      "euler": eulerRads.clone(),
      "madgwick": madgwickProcessedData.copy(),
      "scf": scfProcessedData.copy(),
      "raw": rawData.copy()
    };
  }).toList();
}
