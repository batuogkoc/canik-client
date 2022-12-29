import 'package:csv/csv.dart';
import 'package:scidart/numdart.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'package:canik_lib/canik_lib.dart';
import 'detectors/shot_det.dart';
import 'dataset.dart';

// var scfAhrs = ScfAhrs(
//     {"aLambda1": 0.0017, "aLambda2": 0, "mLambda1": 0.0001, "mLambda2": 0});
var scfAhrs = FscfCcAhrs({"aLambda1": 0.0017, "mLambda1": 0.0001});

var madgwickAhrs = MadgwickAhrs({"beta": 0.011});

var madgwickTransformer = RawDataToProcessedDataTransformer(madgwickAhrs);
var scfTransformer = RawDataToProcessedDataTransformer(scfAhrs);
void main(List<String> args) {
  String path;
  if (args.isEmpty) {
    path = "../../test_data/DATA.csv";
  } else {
    path = args[0];
  }
  testDetector();
}

void testDetector() async {
  ShotConditions liveFireConditions = ShotConditions(85, 70, 5, 2, 15);
  ShotDataset liveFireDataset = ShotDataset();
  await liveFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Live_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector liveFireDetector =
      ShotDetector(liveFireConditions, liveFireDataset);

  ShotConditions dryFireConditions = ShotConditions(75, 70, 10, 1, 3.8);
  ShotDataset dryFireDataset = ShotDataset();
  await dryFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Dry_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector dryFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);

  ShotConditions paintFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
  ShotDataset paintFireDataset = ShotDataset();
  await paintFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Paint_Fire_set.csv",
      fieldDelimiter: ",",
      eol: "\n");
  ShotDetector paintFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);

  int datasetNum = 0;
  for (var dataset in paintFireDataset.dataSet) {
    print("$datasetNum: ");
    for (var data in dataset) {
      paintFireDetector.onDataReceive(data);
    }
    datasetNum++;
  }
}

Future<List<Map<String, dynamic>>> csvReadGithub(String path,
    {String outPath = "out.csv"}) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    throw Exception("File not found");
  }

  int index = 0;
  var list = await File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const CsvToListConverter(fieldDelimiter: ";"))
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
    var accel = Vector3(list[0], list[1], list[2]);
    var gyro = Vector3(list[3], list[4], list[5]);
    var mag = Vector3(list[6], list[7], list[8]);
    var quatVal = Quaternion(list[10], list[11], list[12], list[9]); //x y z w
    double time = list[13];
    return {
      "rawData": RawData.withMag(accel, gyro, mag, time),
      "quatVal": quatVal,
    };
  }).toList();

  list.sort((a, b) =>
      (a["rawData"] as RawData).time.compareTo((b["rawData"] as RawData).time));

  bool firstTime = true;
  double lastTime = 0;

  final ret = list.map((data) {
    RawData rawData = data["rawData"] as RawData;
    Quaternion quatVal = data["quatVal"] as Quaternion;
    double dt;
    if (firstTime == true) {
      firstTime = false;
      lastTime = rawData.time;
      dt = 0;
      // madgwickTransformer.ahrs.quaternion = quatVal;
      // scfTransformer.ahrs.quaternion = quatVal;
    } else {
      dt = rawData.time - lastTime;
      lastTime = rawData.time;
      // print(dt);
    }

    ProcessedData madgwickProcessedData =
        madgwickTransformer.proccessRawData(rawData.copy());
    ProcessedData scfProcessedData =
        scfTransformer.proccessRawData(rawData.copy());
    // scfAhrs.updateMag(rawData.rateRad, rawData.rawAccelG, rawData.magNorm!, dt);
    // madgwickAhrs.updateMag(
    //     rawData.rateRad, rawData.rawAccelG, rawData.magNorm!, dt);
    // ProcessedData madgwickProcessedData = ProcessedData(madgwickAhrs.quaternion,
    //     Vector3.zero(), Vector3.zero(), Vector3.zero(), 0);
    // ProcessedData scfProcessedData = ProcessedData(
    //     scfAhrs.quaternion, Vector3.zero(), Vector3.zero(), Vector3.zero(), 0);
    Vector3 gravitationalAccelVal = quatVal.rotate(Vector3(0, 0, 1));
    Vector3 deviceAccelVal = rawData.rawAccelG - gravitationalAccelVal;
    print("a");
    // if (dt > 0.002) {
    // }
    return <String, dynamic>{
      "index": index++,
      "time": rawData.time,
      "dt": dt,
      "eulerVal": quaternionToEuler(quatVal.normalized()),
      "quatVal": quatVal.normalized(),
      "deviceAccelVal": deviceAccelVal.clone(),
      "madgwick": madgwickProcessedData.copy(),
      "scf": scfProcessedData.copy(),
      "raw": rawData.copy()
    };
  }).toList();
  String csvOut = ListToCsvConverter().convert(ret.map((e) {
    final index = e["index"];
    final rawData = e["raw"];
    final eulerVal = e["eulerVal"];
    final scfEulerRads =
        quaternionToEuler((e["scf"] as ProcessedData).orientation);
    return <num>[
      index,
      rawData.time,
      eulerVal.x,
      eulerVal.y,
      eulerVal.z,
      scfEulerRads.x,
      scfEulerRads.y,
      scfEulerRads.z
    ];
  }).toList());
  if (outPath != "") {
    File(outPath).openWrite().write(csvOut);
  }
  // ret.map((e) => e["dt"]).reduce(max);
  return ret;
}

Future<List<Map<String, dynamic>>> csvRead(
    String path, Vector3 gyroOffset) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    throw Exception("File not found");
  }

  ShotConditions liveFireConditions = ShotConditions(85, 70, 5, 2, 15);
  ShotDataset liveFireDataset = ShotDataset();
  await liveFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Live_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector liveFireDetector =
      ShotDetector(liveFireConditions, liveFireDataset);

  ShotConditions dryFireConditions = ShotConditions(75, 70, 10, 1, 3.8);
  ShotDataset dryFireDataset = ShotDataset();
  await dryFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Dry_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector dryFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);

  ShotConditions paintFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
  ShotDataset paintFireDataset = ShotDataset();
  await paintFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Paint_Fire_set.csv",
      fieldDelimiter: ",",
      eol: "\n");
  ShotDetector paintFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);
  // ShotConditions blankFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
  // ShotConditions coolFireConditions = ShotConditions(85, 78, 7, 2.5, 15);

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
    var gyro = Vector3(list[3], list[4], list[5]) - gyroOffset;
    // var quatVal = Quaternion(list[6], list[7], list[8], list[9]); //x y z w
    var quatVal = Quaternion(list[7], list[8], list[9], list[6]); //w x y z
    double dt = list[10];
    // var eulerRads = Vector3(list[7], list[8], list[9]) * degrees2Radians;
    time += dt;
    return {
      "rawData": RawData(accel, gyro, time),
      "quatVal": quatVal,
    };
  }).toList();
  bool firstTime = true;
  double lastTime = 0;
  list.sort((a, b) =>
      (a["rawData"] as RawData).time.compareTo((b["rawData"] as RawData).time));
  return list.map((data) {
    RawData rawData = data["rawData"] as RawData;
    Quaternion quatVal = data["quatVal"] as Quaternion;
    double dt;
    if (firstTime == true) {
      firstTime = false;
      lastTime = rawData.time;
      dt = 0;
      madgwickTransformer.ahrs.quaternion = quatVal;
      scfTransformer.ahrs.quaternion = quatVal;
    } else {
      dt = rawData.time - lastTime;
      lastTime = rawData.time;
      // print(dt);
    }

    ProcessedData madgwickProcessedData =
        madgwickTransformer.proccessRawData(rawData.copy());
    ProcessedData scfProcessedData =
        scfTransformer.proccessRawData(rawData.copy());
    double accelNorm = scfProcessedData.deviceAccelG.length;
    Vector3 gravitationalAccelVal = quatVal.rotate(Vector3(0, 0, 1));
    Vector3 deviceAccelVal = rawData.rawAccelG - gravitationalAccelVal;
    dryFireDetector.onDataReceive(accelNorm);
    liveFireDetector.onDataReceive(accelNorm);
    paintFireDetector.onDataReceive(accelNorm);
    // if (dt > 0.002) {
    // }
    return <String, dynamic>{
      "index": index++,
      "time": rawData.time,
      "dt": dt,
      "eulerVal": quaternionToEuler(quatVal),
      "quatVal": quatVal.clone(),
      "deviceAccelVal": deviceAccelVal.clone(),
      "madgwick": madgwickProcessedData.copy(),
      "scf": scfProcessedData.copy(),
      "raw": rawData.copy()
    };
  }).toList();
}

Future<List<Map<String, dynamic>>> csvReadOld(
    String path, Vector3 gyroOffset) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    throw Exception("File not found");
  }

  ShotConditions liveFireConditions = ShotConditions(85, 70, 5, 2, 15);
  ShotDataset liveFireDataset = ShotDataset();
  await liveFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Live_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector liveFireDetector =
      ShotDetector(liveFireConditions, liveFireDataset);

  ShotConditions dryFireConditions = ShotConditions(75, 70, 10, 1, 3.8);
  ShotDataset dryFireDataset = ShotDataset();
  await dryFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Dry_Fire_set.csv",
      fieldDelimiter: ";",
      eol: "\n");
  ShotDetector dryFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);

  ShotConditions paintFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
  ShotDataset paintFireDataset = ShotDataset();
  await paintFireDataset.fillFromCsv(
      "../../data/shot_det_datasets/Paint_Fire_set.csv",
      fieldDelimiter: ",",
      eol: "\n");
  ShotDetector paintFireDetector =
      ShotDetector(dryFireConditions, dryFireDataset);
  // ShotConditions blankFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
  // ShotConditions coolFireConditions = ShotConditions(85, 78, 7, 2.5, 15);

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
    var gyro = Vector3(list[3], list[4], list[5]) - gyroOffset;
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
      firstTime = false;
      lastTime = rawData.time;
      dt = 0;
      madgwickTransformer.ahrs.quaternion =
          Quaternion.euler(eulerRads.z, eulerRads.y, eulerRads.x);
      scfTransformer.ahrs.quaternion =
          Quaternion.euler(eulerRads.z, eulerRads.y, eulerRads.x);
    } else {
      dt = rawData.time - lastTime;
      lastTime = rawData.time;
      // print(dt);
    }

    ProcessedData madgwickProcessedData =
        madgwickTransformer.proccessRawData(rawData.copy());
    ProcessedData scfProcessedData =
        scfTransformer.proccessRawData(rawData.copy());
    // shot_det.onDataReceive(scfProcessedData);
    double accelNorm = scfProcessedData.deviceAccelG.length;
    dryFireDetector.onDataReceive(accelNorm);
    liveFireDetector.onDataReceive(accelNorm);
    paintFireDetector.onDataReceive(accelNorm);
    // if (dt > 0.002) {
    // }
    return <String, dynamic>{
      "index": index++,
      "time": rawData.time,
      "dt": dt,
      "eulerVal": eulerRads.clone(),
      "madgwick": madgwickProcessedData.copy(),
      "scf": scfProcessedData.copy(),
      "raw": rawData.copy()
    };
  }).toList();
}
