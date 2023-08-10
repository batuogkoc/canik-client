import 'package:canik_lib/src/stream_transformer_helpers.dart';
import 'package:scidart/numdart.dart';
import 'package:circular_buffer/circular_buffer.dart';

import 'dart:convert';

import 'package:scidart/scidart.dart' as scidart;
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:collection/collection.dart';
import "dart:async";
import 'package:canik_lib/canik_lib.dart';

class ShotInstance {
  final DateTime time;
  final double? deltaT;
  final ProcessedData processedData;
  final int shotCount;
  ShotInstance.zero()
      : time = DateTime.fromMillisecondsSinceEpoch(0),
        processedData = ProcessedData.zero(),
        shotCount = 0,
        deltaT = 0;
  ShotInstance(
      this.time, this.deltaT, this.shotCount, ProcessedData processedData)
      : processedData = processedData.copy();
}

class ShotConditions {
  double resemblenceThresh;
  double corrAvgThresh;
  int minResemblanceCount;
  double accLowerThresh;
  double accUpperThresh;
  Map<String, num> debug;
  bool debugEnabled;

  ShotConditions(this.resemblenceThresh, this.corrAvgThresh,
      this.minResemblanceCount, this.accLowerThresh, this.accUpperThresh,
      {this.debugEnabled = false})
      : debug = <String, num>{};

  bool checkConditions(
      List<double> maxCorrelationArray, Array signalWithinWindow) {
    bool corrAvgThreshCond = maxCorrelationArray.average > corrAvgThresh;
    int count = maxCorrelationArray
        .where((element) => element > resemblenceThresh)
        .length;
    bool resemblenceCountCond = count > minResemblanceCount;
    double signalMax = signalWithinWindow.max;
    bool accThreshCond =
        accLowerThresh < signalMax && signalMax < accUpperThresh;

    if (debugEnabled) {
      debug["maxCorrelationAverage"] = maxCorrelationArray.average;
      // debug["maxResemblenceCount"] = count;
      int i = 0;
      for (var element
          in maxCorrelationArray.sorted((a, b) => b.compareTo(a))) {
        if (element < resemblenceThresh) {
          break;
        }
        i++;
      }
      debug["maxResemblenceCount"] = i;
      debug["maxCorrelationMax"] = maxCorrelationArray.max;
      debug["signalMax"] = signalMax;
    }

    // return cond1 && cond2 && cond3 && cond4and5;
    return resemblenceCountCond && accThreshCond;
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
    var list = await file
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
    }).toList();
    fillFromList(list);
  }

  void fillFromList(List<List<dynamic>> list) {
    for (List<dynamic> line in list) {
      var rawArray = Array(line.cast<double>());
      dataSet.add(rawArray);
    }
  }

  List<double> maxCorrelationList(Array signal, {bool fast = false}) {
    var ret = <double>[];
    for (var sample in dataSet) {
      ret.add(scidart.correlate(sample, signal, fast: fast).max);
    }
    return ret;
  }
}

class ShotDetector {
  int shotCounter = 0;

  final int windowSize;
  final int algorithmPeriod;

  int _dataCounter = 0;

  ShotDataset _shotDataset;

  ShotConditions _shotConditions;

  bool _lastWindowShotCandidate = false;

  final CircularBuffer<ProcessedData> _processedDataBuffer;

  ShotInstance? previousShot;

  ShotDetector(this._shotConditions, this._shotDataset,
      {this.windowSize = 90, this.algorithmPeriod = 40})
      : _processedDataBuffer = CircularBuffer(windowSize);

  ShotInstance? onDataReceive(ProcessedData data) {
    _processedDataBuffer.add(data);
    _dataCounter++;
    if (_dataCounter >= algorithmPeriod) {
      _dataCounter = 0;
      return _shotCalculator();
    }
    return null;
  }

  bool processFilteredShotSignal(Array rawSignalWithinWindow,
      ShotDataset dataset, ShotConditions conditions) {
    var maxCorrelationArray = dataset.maxCorrelationList(rawSignalWithinWindow);
    return conditions.checkConditions(
        maxCorrelationArray, rawSignalWithinWindow);
  }

  ShotInstance? _shotCalculator() {
    var windowSignal = _processedDataBuffer
        .map((element) => element.deviceAccelG.length)
        .toList(growable: false);
    bool shotCandidateDetected = processFilteredShotSignal(
        Array(windowSignal), _shotDataset, _shotConditions);

    bool shotDetected =
        _lastWindowShotCandidate == false && shotCandidateDetected == true;
    _lastWindowShotCandidate = shotCandidateDetected;

    if (shotDetected) {
      shotCounter++;
      ProcessedData currData =
          _processedDataBuffer[_processedDataBuffer.length - 1];
      ShotInstance currentShot = ShotInstance(
          DateTime.now(),
          previousShot == null
              ? null
              : currData.time - previousShot!.processedData.time,
          shotCounter,
          currData);
      previousShot = currentShot;
      return currentShot;
    }
    return null;
  }

  void reset() {
    shotCounter = 0;
    _dataCounter = 0;
  }

  ShotConditions get conditions {
    return _shotConditions;
  }

  ShotDataset get dataset {
    return _shotDataset;
  }

  void updateShotConditionsAndDataset(
      ShotConditions shotConditions, ShotDataset shotDataset) {
    _shotConditions = shotConditions;
    _shotDataset = shotDataset;
  }
}

class ShotDetectorTransformer
    extends PersistentStreamTransformerTemplate<ProcessedData, ShotInstance> {
  ShotDetector shotDetector;

  ShotDetectorTransformer(this.shotDetector,
      {bool sync = false, bool cancelOnError = false})
      : super(cancelOnError: cancelOnError, sync: sync);
  ShotDetectorTransformer.broadcast(this.shotDetector,
      {bool sync = false, bool cancelOnError = true})
      : super.broadcast(cancelOnError: cancelOnError, sync: sync);

  void onData(ProcessedData data) {
    ShotInstance? shotInstance = shotDetector.onDataReceive(data);
    if (shotInstance != null) {
      publishData(shotInstance);
    }
  }
}
