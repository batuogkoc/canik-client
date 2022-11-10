import 'dart:convert';

import 'package:scidart/scidart.dart' as scidart;
import 'package:scidart/numdart.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:collection/collection.dart';

void normalizeInPlace(Array array) {
  //TODO: implement normalization
  double scalar = 1 / array.max;
  for (int i = 0; i < array.length; i++) {
    array[i] *= scalar;
  }
}

class ShotConditions {
  double maxResemblance;
  double minResemblanceCount;
  double resemblance;
  double shotAccLowerThresh;
  double shotAccUpperThresh;

  ShotConditions(this.maxResemblance, this.minResemblanceCount,
      this.resemblance, this.shotAccLowerThresh, this.shotAccUpperThresh);

  bool checkConditions(
      List<double> maxCorrelationArray, Array signalWihthinWindow) {
    bool cond1 = maxCorrelationArray.average > minResemblanceCount;
    int count =
        maxCorrelationArray.where((element) => element > maxResemblance).length;
    bool cond2 = count > resemblance;
    bool cond3 = maxCorrelationArray.max > maxResemblance;
    double signalMax = signalWihthinWindow.max;
    bool cond4and5 =
        shotAccLowerThresh < signalMax && signalMax < shotAccUpperThresh;
    print(cond1);
    print(cond2);
    print(cond3);
    print(cond4and5);
    return cond1 && cond2 && cond3 && cond4and5;
  }
}

class ShotDataset {
  List<Array> dataSet;
  ShotDataset() : dataSet = <Array>[];
  Future<void> fillFromCsv(String path,
      {String fieldDelimiter = defaultFieldDelimiter,
      String eol = defaultEol}) async {
    dataSet = <Array>[];
    var file = File(path);
    if (await file.exists() == false) {
      throw FileSystemException("File could not be found", path = path);
    }
    await file
        .openRead()
        .transform(utf8.decoder)
        .transform(CsvToListConverter(fieldDelimiter: fieldDelimiter, eol: eol))
        .where((event) {
      return event.every((element) {
        try {
          element as double;
        } catch (e) {
          return false;
        }
        return true;
      });
    }).forEach((dynamicList) {
      dataSet.add(Array(dynamicList.cast()));
    });
    normalize();
  }

  void normalize() {
    for (var array in dataSet) {
      normalizeInPlace(array);
    }
  }

  List<Array> correlate(Array signal, {bool fast = false}) {
    var ret = <Array>[];
    for (var sample in dataSet) {
      ret.add(scidart.correlate(sample, signal, fast: fast));
    }
    return ret;
  }

  List<double> maxCorrelationList(Array signal, {bool fast = false}) {
    return correlate(signal).map((e) => e.max).toList();
  }
}
