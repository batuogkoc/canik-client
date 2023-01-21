import 'package:scidart/numdart.dart';
import 'dart:math' as Math;

import 'package:scidart/scidart.dart';

enum PadType { circular, replicate, symmetric }

Array padArray(Array input, int padLength,
    {PadType padType = PadType.replicate}) {
  Array ret = Array.fromArray(input);
  int inputLen = input.length;
  print(padLength);
  for (int i = 0; i < padLength; i++) {
    switch (padType) {
      case PadType.circular:
        ret.insert(0, input[inputLen - 1 - i]);
        ret.add(input[i]);
        break;
      case PadType.replicate:
        ret.insert(0, input.first);
        ret.add(input.last);
        break;
      case PadType.symmetric:
        ret.insert(0, input[i]);
        ret.add(input[inputLen - 1 - i]);
        break;
      default:
        throw Exception("Invalid padType");
    }
  }
  return ret;
}

int factorial(int n) {
  int r = 1;
  while (n > 0) {
    r *= n--;
  }
  return r;
}

Array savitzkyGolay(Array data, int windowSize, int polyOrder,
    {double spacing = 1.0, int derivative = 0}) {
  String pad = 'none';
  PadType padType = PadType.replicate;
  if (windowSize % 2 == 0 || windowSize < 5) {
    throw RangeError(
      'Invalid window size (should be odd and at least 5 integer number)',
    );
  }
  if (derivative < 0) {
    throw RangeError('Derivative should be a positive integer');
  }
  if (polyOrder < 1) {
    throw RangeError('Polynomial should be a positive integer');
  }

  // let C, norm;
  Array C;
  double norm;
  int step = (windowSize.toDouble() / 2).floor();

  // if (pad == 'pre') {
  //   print("pad pre");
  //   data = padArray(data, step, padType: padType);
  // }
  // if (windowSize == 5 &&
  //     polynomial == 2 &&
  //     (derivative == 1 || derivative == 2)) {
  //   if (derivative == 1) {
  //     C = Array([-2, -1, 0, 1, 2]);
  //     norm = 10;
  //   } else {
  //     C = Array([2, -1, -2, -1, 2]);
  //     norm = 7;
  //   }
  // } else
  {
    // var J = Matrix.generate(windowSize, polynomial + 1);
    Array2d J = Array2d.fixed(windowSize, polyOrder + 1);
    double inic = -(windowSize - 1) / 2;

    for (int i = 0; i < J.row; i++) {
      for (int j = 0; j < J.column; j++) {
        if (inic + 1 != 0 || j != 0) {
          J[i][j] = Math.pow(inic + i, j).toDouble();
        } else {
          J[i][j] = 0;
        }
      }
    }

    var C_temp = matrixInverse(J);
    C = C_temp[derivative];
    norm = 1 / factorial(derivative);
  }
  double det = norm * Math.pow(spacing, derivative);

  Array ans = Array.fixed(data.length);
  // print(C);
  data = padArray(data, step);
  // print(data);
  for (int k = 0; k < data.length - 2 * step; k++) {
    double d = 0;
    for (int l = 0; l < C.length; l++) {
      d += (C[l] * data[l + k]) / det;
    }
    ans[k] = d;
  }

  // if (pad == 'post') {
  //   print("pad post");

  //   ans = padArray(ans, step, padType: padType);
  // }

  return ans;
}

void main(List<String> args) {
  // Math.Random rand = Math.Random();
  // Array data = Array(Iterable.generate(20, (index) {
  //   return rand.nextDouble();
  //   // return 1.0;
  // }).toList());
  Array data = Array([
    0.32956017964328,
    0.7169862483175851,
    0.03879292042419935,
    0.6622507013772669,
    0.47196385280268716,
    0.3016649833750602,
    0.7628882997374368,
    0.19711901139778742,
    0.6746403902307677,
    0.9189687729296612,
    0.5028505239800511,
    0.8491766410471173,
    0.10655970242225565,
    0.7629243018593187,
    0.5632770099542458,
    0.08612421191027197,
    0.068472844261524,
    0.6834288722498995,
    0.06683186311488976,
    0.7228077535608323
  ]);

  var filtered = savitzkyGolay(data, 5, 2);

  // print(data.length);
  // print(filtered.length);
  print(filtered);
}
