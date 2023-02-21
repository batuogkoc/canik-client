import 'dart:convert';

import 'package:scidart/scidart.dart' as scidart;
import 'package:scidart/numdart.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:canik_lib/canik_lib.dart';
import 'dart:math';

Array normalizeCopy(Array array) {
  Array ret = Array.fixed(array.length, initialValue: double.nan);
  double norm = 0;
  for (var element in array) {
    norm += element * element;
  }
  norm = sqrt(norm);
  for (int i = 0; i < array.length; i++) {
    ret[i] = array[i] / norm;
  }
  return ret;
  // return array.copy();
}

class ShotConditions {
  double maxResemblance;
  double minResemblanceCount;
  int resemblance;
  double shotAccLowerThresh;
  double shotAccUpperThresh;
  Map<String, num> debug;

  ShotConditions(this.maxResemblance, this.minResemblanceCount,
      this.resemblance, this.shotAccLowerThresh, this.shotAccUpperThresh)
      : debug = <String, num>{};

  bool checkConditions(
      List<double> maxCorrelationArray, Array signalWithinWindow) {
    bool cond1 = maxCorrelationArray.average > minResemblanceCount;
    int count =
        maxCorrelationArray.where((element) => element > maxResemblance).length;
    bool cond2 = count > resemblance;
    bool cond3 = maxCorrelationArray.max > maxResemblance;
    double signalMax = signalWithinWindow.max;
    bool cond4and5 =
        shotAccLowerThresh < signalMax && signalMax < shotAccUpperThresh;

    debug["maxCorrelationAverage"] = maxCorrelationArray.average;
    // debug["maxResemblenceCount"] = count;
    int i = 0;
    for (var element in maxCorrelationArray.sorted((a, b) => b.compareTo(a))) {
      if (element < maxResemblance) {
        break;
      }
      i++;
    }
    debug["maxResemblenceCount"] = i;
    debug["maxCorrelationMax"] = maxCorrelationArray.max;
    debug["signalMax"] = signalMax;
    if (cond1 || cond2 || cond3 || cond4and5) {
      // if (cond1) {
      // print(maxCorrelationArray);
      // print(
      //     "minResemblanceCount: $cond1, ${maxCorrelationArray.average} > $minResemblanceCount");
      // print("maxResemblenceCount: $cond2, $count > $resemblance");
      // print(
      //     "maxResemblence: $cond3, ${maxCorrelationArray.max} > $maxResemblance");
      // print(
      //     "accThresh: $cond4and5, $shotAccLowerThresh < $signalMax < $shotAccUpperThresh");
    }
    // return cond1 && cond2 && cond3 && cond4and5;
    return cond2;
  }
}

class ShotDataset {
  List<Array> dataSet;
  ShotDataset() : dataSet = <Array>[];
  Future<void> fillFromCsv(String path,
      {String fieldDelimiter = defaultFieldDelimiter,
      String eol = defaultEol}) async {
    var filter = SavitzkyGolayFilter(13, 3);

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
      // dataSet.add(Array(dynamicList.cast<double>()));
      var rawArray = Array(dynamicList.cast<double>());
      var filteredArray = filter.filter(rawArray);
      // print("@@-----------------@@");
      // print(rawArray);
      // print(filteredArray);
      // dataSet.add(filteredArray);
      // var normalizedArray = normalizeCopy(rawArray);
      var normalizedArray = normalizeCopy(filteredArray);
      print(filteredArray);
      print(normalizedArray);
      dataSet.add(rawArray);
    });
  }

  List<double> maxCorrelationList(Array signal, {bool fast = false}) {
    var ret = <double>[];
    for (var sample in dataSet) {
      ret.add(scidart.correlate(sample, signal, fast: fast).max);
    }
    return ret;
  }
}
