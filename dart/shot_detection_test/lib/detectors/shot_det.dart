import "dart:async";
import 'package:moving_average/moving_average.dart';
import 'package:scidart/numdart.dart';
import 'package:circular_buffer/circular_buffer.dart';
import 'package:canik_lib/canik_lib.dart';

late final Stream<ProcessedData> processedDataStream;

//moving average instead of savitzky golay filter
//shot signal length = 20
// 400 Hz
// window_size =  shot_len*2 +10 = 50
// as shot_len = 50 window_size = 100+10
// T =(shot_len*2)*(1/freq)* 1/3
//shot_len = 50, T =100*1/400*1/3 =
// signal length = 20
// 40*1/400*1/3 = 1/3
// s = [[0,0,0,0,0](length = 50), [0,0,0,0,0,0,...](length = 50)]
var maxResemblance = 0;
var detMinResemblance = 0;
var detResemblance = 0;
var detLowerThresh = 0;
var detUpperThresh = 0;
var n = 0; // %size(s,1)

var shotCounter = 0;
var dataCounter = 0;

var shotLen = 20;
var samplingRate = 400; //hz
var windowSize = shotLen * 2 + 10;
var t = (shotLen * 2) * (1 / samplingRate) * 1 / 3;
var dataSet = [];
//todo: create data set

bool first = true;
bool detected = false;

var objList = [];
var windowSignals = List<num>.filled(50, 0);
var xList = [];
var yList = [];
var zList = [];
var updatedWindowSignals = [];
var xCirc = CircularBuffer<double>(50);
var yCirc = CircularBuffer<double>(50);
var zCirc = CircularBuffer<double>(50);

void shotDetectortwo(ProcessedData data) {
  if (first) {
    calculator(50, data);
    first = false;
  } else {
    calculator(33, data);
  }
}

void condchecker(maxCorrelationArray, count, windowSignals) {
  bool shot = false;
  if (maxCorrelationArray.average > detMinResemblance) {
    if (count > detResemblance) {
      if (maxCorrelationArray.max > maxResemblance) {
        if (detLowerThresh < windowSignals.max) {
          if (windowSignals.max > detUpperThresh) {
            shot = true;
          }
        }
      }
    }
  }
  if (shot) {
    detected = true;
    shotCounter++;
  }
}

List crossCorrelation(
  List signal1,
  List signal2,
) {
  var array = [];
  return array;
}

void normalize(List signal) {}

void calculator(dataCount, ProcessedData data) {
  while (dataCounter < dataCount) {
    xCirc.add(data.deviceAccelG.x);
    yCirc.add(data.deviceAccelG.y);
    zCirc.add(data.deviceAccelG.z);
    dataCounter++;
  }
  for (int i = 0; i < 50; i++) {
    windowSignals[i] =
        (sqrt((pow(xCirc[i], 2)) + (pow(yCirc[i], 2)) + pow(zCirc[i], 2)));
  }
  final movingAverage = MovingAverage<num>(
    averageType: AverageType.simple,
    windowSize: 13,
    partialStart: true,
    getValue: (num n) => n,
    add: (List<num> data, num value) => value,
  );
  final filteredWindowSignals = movingAverage(windowSignals);

  var maxCorreleationArray = Array2d.empty();
  var zero = Array([0]);
  for (var i = 0; i < n; i++) {
    maxCorreleationArray.add(zero);
  }
  var count = 0;
  normalize(filteredWindowSignals);
  for (var j = 0; j < n; j++) {
    //Normalize signal within window
    normalize(dataSet[j]);

    List crossCorr = crossCorrelation(dataSet[j], filteredWindowSignals);
    maxCorreleationArray[1][j] = crossCorr.max;
    bool cond = crossCorr.max > maxResemblance;
    if (cond) {
      count++;
    }

    //Normalize ith instance from data set
  }

  dataCounter = 0;
}
