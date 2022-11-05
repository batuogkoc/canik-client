import 'dart:convert';

import 'package:scidart/scidart.dart' as scidart;
import 'package:scidart/numdart.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:collection/collection.dart';

void _normalizeArray(Array array) {
  //TODO: implement normalization
  throw UnimplementedError();
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
    return cond1 && cond2 && cond3 && cond4and5;
  }
}

class ShotDataset {
  List<Array> dataSet;
  ShotDataset() : dataSet = <Array>[];
  Future<void> fillFromCsv(String path) async {
    dataSet = <Array>[];
    var file = File(path);
    if (await file.exists() == false) {
      throw FileSystemException("File could not be found", path = path);
    }
    file
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
    }).forEach((dynamicList) {
      dataSet.add(Array(dynamicList.cast()));
    });
    normalize();
  }

  void normalize() {
    for (var array in dataSet) {
      _normalizeArray(array);
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
