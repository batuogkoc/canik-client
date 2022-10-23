import 'dart:async';
import 'package:circular_buffer/circular_buffer.dart';
import 'dart:math';
import 'package:canik_lib/canik_lib.dart';

//Circular-Buffer ataması
var x_axis = CircularBuffer<double>(50);
var y_axis = CircularBuffer<double>(50);
var z_axis = CircularBuffer<double>(50);

var V = CircularBuffer<double>(50);
var V_sort = CircularBuffer<double>(50);

var X_sort = CircularBuffer<double>(50);
var Z_sort = CircularBuffer<double>(50);
var Y_sort = CircularBuffer<double>(50);

var X_abs_sort = CircularBuffer<double>(50);
var Z_abs_sort = CircularBuffer<double>(50);
var Y_abs_sort = CircularBuffer<double>(50);

//Condition setlerde karşılaştırılacak verilerin ataması
late final Stream<ProcessedData> processedDataStream;

double vAvarageMax = 0,
    vMean = 0,
    vStd = 0,
    xAvarageMax = 0,
    yAvarageMax = 0,
    zAvarageMax = 0,
    xAbsAvarageMax = 0,
    yAbsAvarageMax = 0,
    zAbsAvarageMax = 0;

bool gunChragerState = false;
bool firstCall = true;
bool backArrowPressed = false;
int bulletCount = 12; //User defined normally

enum SFS_States { idle, run }

SFS_States _sfs_state = SFS_States.idle;

void start() {
  processedDataStream.forEach(_update);
}

void _update(ProcessedData data) {
  //Condition setler için map ataması
  Map<String, bool> condSet1 = {
    "cond1": vAvarageMax > 5000,
    "cond2": vMean > 100,
    "cond3": vStd > 1600,
    "cond4": xAvarageMax > yAvarageMax,
    "cond5": xAvarageMax > zAvarageMax,
    "cond6": xAbsAvarageMax > yAbsAvarageMax,
    "cond7": xAbsAvarageMax > zAbsAvarageMax
  };

  Map<String, bool> condSet2 = {
    "cond1": vAvarageMax > 4000,
    "cond2": vMean > 1000,
    "cond3": vStd > 1300,
    "cond4": xAvarageMax > yAvarageMax,
    "cond5": zAvarageMax > yAvarageMax,
    "cond6": yAbsAvarageMax > xAbsAvarageMax,
    "cond7": yAbsAvarageMax > zAbsAvarageMax
  };

  Map<String, bool> condSet3 = {
    "cond1": vAvarageMax > 8000,
    "cond2": vMean > 2000,
    "cond3": vStd > 2700,
    "cond4": xAvarageMax >= yAvarageMax,
    "cond5": xAvarageMax >= zAvarageMax
  };
  //Datalardan gerekli işlemleri yapan fonksiyon
  Calculator(data);
  switch (_sfs_state) {
    case SFS_States.idle:
      if (condSet2.values.every((element) => element)) {
        gunChragerState = true;
      }
      if (condSet1.values.every((element) => element)) {
        _sfs_state = SFS_States.run;
      }
      break;
    case SFS_States.run:
      if (firstCall == true) {
        //Set bullet count to user defined value
      }
      if (condSet3.values.every((element) => element)) {
        bulletCount = bulletCount - 1;
        print("Shot detected, bullet count: ${bulletCount}");
      }
      if (bulletCount == 0 || backArrowPressed == true) {
        _sfs_state = SFS_States.idle;
      }

      break;
  }
}

//Condition setlerdeki hesaplamaları yapan fonksiyon
void Calculator(ProcessedData data) {
  x_axis.add(data.deviceAccelG.x);
  y_axis.add(data.deviceAccelG.y);
  z_axis.add(data.deviceAccelG.z);

  for (var i = 0; i < z_axis.length; i++) {
    V.add(
        sqrt(pow(x_axis[i], 2) + pow(y_axis[i], 2) + pow(z_axis[i], 2)) * 1000);
  }

  // V_sort = {...V} as CircularBuffer<double>;
  V_sort = _copyCircularBuffer(V);
  V_sort.sort((b, a) => a.compareTo(b));
  if (V_sort.length >= 5) {
    vAvarageMax = _lastNAverage(V_sort, 5);
  }

  vMean = V.reduce((a, b) => a + b) / V.length;

  double t = 0;
  for (var z = 0; z < V.length; z++) {
    t = t + pow(V[z] - vMean, 2);
    if (z == V.length - 1) {
      vStd = sqrt(t / V.length);
    }
  }

  // X_sort = {...x_axis} as CircularBuffer<double>;
  X_sort = _copyCircularBuffer(x_axis);
  X_sort.sort((b, a) => a.compareTo(b));
  if (Y_sort.length >= 5) {
    xAvarageMax = _lastNAverage(X_sort, 5);
  }

  // Y_sort = {...y_axis} as CircularBuffer<double>;
  Y_sort = _copyCircularBuffer(y_axis);
  Y_sort.sort((b, a) => a.compareTo(b));
  if (Y_sort.length >= 5) {
    yAvarageMax = _lastNAverage(Y_sort, 5);
  }

  // Z_sort = {...z_axis} as CircularBuffer<double>;
  Z_sort = _copyCircularBuffer(z_axis);
  Z_sort.sort((b, a) => a.compareTo(b));
  if (Z_sort.length >= 5) {
    zAvarageMax = _lastNAverage(Z_sort, 5);
  }

  // X_abs_sort = {...x_axis} as CircularBuffer<double>;
  X_abs_sort = _copyCircularBuffer(x_axis);
  X_abs_sort.forEach((n) => {n = n.abs()});
  X_abs_sort.sort((b, a) => a.compareTo(b));
  if (X_abs_sort.length >= 5) {
    xAbsAvarageMax = _lastNAverage(X_abs_sort, 5);
  }

  // Y_abs_sort = {...y_axis} as CircularBuffer<double>;
  Y_abs_sort = _copyCircularBuffer(y_axis);
  Y_abs_sort.forEach((n) => {n = n.abs()});
  Y_abs_sort.sort((b, a) => a.compareTo(b));
  if (Y_abs_sort.length >= 5) {
    yAbsAvarageMax = _lastNAverage(Y_abs_sort, 5);
  }

  // Z_abs_sort = {...z_axis} as CircularBuffer<double>;
  Z_abs_sort = _copyCircularBuffer(z_axis);
  Z_abs_sort.forEach((n) => {n = n.abs()});
  Z_abs_sort.sort((b, a) => a.compareTo(b));
  if (Z_abs_sort.length >= 5) {
    zAbsAvarageMax = _lastNAverage(Z_abs_sort, 5);
  }
}

CircularBuffer<T> _copyCircularBuffer<T>(CircularBuffer<T> buffer) {
  CircularBuffer<T> ret = CircularBuffer<T>(buffer.capacity);

  for (final value in buffer) {
    ret.add(value);
  }
  return ret;
}

double _lastNAverage(CircularBuffer<double> buffer, int n) {
  assert(n > 0);
  assert(buffer.length >= n);
  double ret = 0;
  for (int i = 0; i < n; i++) {
    ret += buffer[buffer.length - i - 1];
  }
  return ret / n;
}
