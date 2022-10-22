import 'dart:async';
import "canik_backend.dart";
import 'package:circular_buffer/circular_buffer.dart';
import "dart:math";

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
late final Stream<ProcessedData> _processedDataStream;

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

//Condition setler için map ataması
//TODO: are these functions or bool values evaluated at declaration time
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

void start() {
  _processedDataStream.forEach(_update);
}

void _update(ProcessedData data) {
  //Datalardan gerekli işlemleri yapan fonksiyon
  Calculator(data);
  switch (_sfs_state) {
    case SFS_States.idle:
      if (condSet2.values.every((element) => true)) {
        gunChragerState = true;
      }
      if (condSet1.values.every((element) => true)) {
        _sfs_state = SFS_States.run;
      }
      break;
    case SFS_States.run:
      if (firstCall == true) {
        //TODO: Set bullet count to user defined value
      }
      if (condSet3.values.every((element) => true)) {
        bulletCount = bulletCount - 1;
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

  for (var i = 0; i < 50; i++) {
    V.add(sqrt(pow(x_axis[i], 2) + pow(y_axis[i], 2) + pow(z_axis[i], 2)) /
        1000); //TODO: kiloG or milliG
  }

  V_sort = V;
  V_sort.sort((b, a) => a.compareTo(b));
  vAvarageMax = (V_sort[0] + V_sort[1] + V_sort[2] + V_sort[3] + V_sort[4]) / 5;
  vMean = V.reduce((a, b) => a + b) / V.length;

  double t = 0;
  for (var z = 0; z < 50; z++) {
    t = t + pow(V[z] - vMean, 2);
    if (z == 49) {
      vStd = sqrt(t / 49);
    }
  }

  X_sort = x_axis; //TODO: COPY!!
  X_sort.sort((b, a) => a.compareTo(b));
  xAvarageMax = (X_sort[0] + X_sort[1] + X_sort[2] + X_sort[3] + X_sort[4]) / 5;

  Y_sort = y_axis;
  Y_sort.sort((b, a) => a.compareTo(b));
  yAvarageMax = (Y_sort[0] + Y_sort[1] + Y_sort[2] + Y_sort[3] + Y_sort[4]) / 5;

  Z_sort = z_axis;
  Z_sort.sort((b, a) => a.compareTo(b));
  zAvarageMax = (Z_sort[0] + Z_sort[1] + Z_sort[2] + Z_sort[3] + Z_sort[4]) / 5;

  X_abs_sort = x_axis;
  for (var z in X_abs_sort) {
    //TODO: is it by reference?
    z = z.abs();
  }
  X_abs_sort.sort((b, a) => a.compareTo(b));
  xAbsAvarageMax = (X_abs_sort[0] +
          X_abs_sort[1] +
          X_abs_sort[2] +
          X_abs_sort[3] +
          X_abs_sort[4]) /
      5;

  Y_abs_sort = y_axis;
  for (var z in Y_abs_sort) {
    z = z.abs();
  }
  Y_abs_sort.sort((b, a) => a.compareTo(b));
  yAbsAvarageMax = (Y_abs_sort[0] +
          Y_abs_sort[1] +
          Y_abs_sort[2] +
          Y_abs_sort[3] +
          Y_abs_sort[4]) /
      5;

  Z_abs_sort = z_axis;
  for (var z in Z_abs_sort) {
    z = z.abs();
  }
  Z_abs_sort.sort((b, a) => a.compareTo(b));
  zAbsAvarageMax = (Z_abs_sort[0] +
          Z_abs_sort[1] +
          Z_abs_sort[2] +
          Z_abs_sort[3] +
          Z_abs_sort[4]) /
      5;
}
