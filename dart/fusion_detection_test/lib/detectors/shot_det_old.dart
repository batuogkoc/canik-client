import "dart:async";
import 'package:moving_average/moving_average.dart';
import 'package:scidart/numdart.dart';
import 'package:circular_buffer/circular_buffer.dart';
import 'package:canik_lib/canik_lib.dart';
import 'package:scidart/scidart.dart';
import 'package:collection/collection.dart';

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

//condition constants
double maxResemblance = 0;
double detMinResemblance = 0;
double detResemblance = 0;
double detLowerThresh = 0;
double detUpperThresh = 0;

//size of sample datasets (n shot signals all length m(?))
int n = 0; // %size(s,1)

int shotCounter = 0;
int dataCounter = 0;

int shotLen = 20;
int samplingRate = 400; //hz
int windowSize = shotLen * 2 + 10;
double t = (shotLen * 2) * (1 / samplingRate) * 1 / 3;
List<List<double>> dataSet = [];
//TODO: create data set

bool first = true;
bool lastWindowShotCandidate = false;

// var objList = [];
var windowSignals = List<double>.filled(50, 0);
// var xList = [];
// var yList = [];
// var zList = [];
// var updatedWindowSignals = [];
var accelNormBuffer = CircularBuffer<double>(50);

void onDataReceive(ProcessedData data) {
  accelNormBuffer.add(data.deviceAccelG.length);
  dataCounter++;
  if (dataCounter >= 33) {
    dataCounter = 0;
    if (first) {
      calculator(50);
      first = false;
    } else {
      calculator(33);
    }
  }
}

void _shotDetected() {
  shotCounter++;
  print("Shot detected");
}

bool condchecker(Iterable<double> maxCorrelationArray, int count,
    Iterable<double> windowSignals) {
  if (!(maxCorrelationArray.average > detMinResemblance)) {
    return false;
  }
  if (!(count > detResemblance)) {
    return false;
  }
  if (!(maxCorrelationArray.max > maxResemblance)) {
    return false;
  }
  if (!(detLowerThresh < windowSignals.max)) {
    return false;
  }
  if (!(windowSignals.max > detUpperThresh)) {
    return false;
  }
  return true;
}

// List crossCorrelation(
//   List signal1,
//   List signal2,
// ) {
//   var array = [];
//   return array;
// }

//TODO: Is normalization done like this?
void normalizeInPlace(List<double> signal) {
  double scalar = 1 / signal.max;
  signal.map((e) => e * scalar);
}

void calculator(dataCount) {
  // for (int i = 0; i < 50; i++) {
  //   windowSignals[i] =
  //       (sqrt((pow(xCirc[i], 2)) + (pow(yCirc[i], 2)) + pow(zCirc[i], 2)));
  // }
  windowSignals = accelNormBuffer.toList(growable: false);
  final movingAverage = MovingAverage<double>(
    averageType: AverageType.simple,
    windowSize: 13,
    partialStart: true,
    getValue: (double n) => n,
    add: (List<double> data, num value) => value.toDouble(),
  );
  final filteredWindowSignals = movingAverage(windowSignals);

  var maxCorrelationArray = List<double>.filled(n, 0);
  // var zero = Array([0]);
  // for (var i = 0; i < n; i++) {
  //   maxCorreleationArray.add(zero);
  // }
  int count = 0;
  normalizeInPlace(filteredWindowSignals);
  for (int i = 0; i < dataSet.length; i++) {
    //Normalize signal within window
    normalizeInPlace(dataSet[i]); //Move this to the "constructor"
    Array crossCorr =
        correlate(Array(dataSet[i]), Array(filteredWindowSignals));
    // List crossCorr = crossCorrelation(dataSet[j], filteredWindowSignals);
    maxCorrelationArray[i] = crossCorr.max;
    if (crossCorr.max > maxResemblance) {
      count++;
    }
  }
  bool condition = condchecker(maxCorrelationArray, count, windowSignals);
  bool shotDetected = condition && lastWindowShotCandidate;
  lastWindowShotCandidate = condition;

  if (shotDetected) {
    _shotDetected();
  }

  dataCounter = 0;
}