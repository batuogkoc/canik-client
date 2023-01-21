import 'package:scidart/numdart.dart';
import 'dart:math' as Math;

enum PadType { circular, replicate, symmetric }

Array padArray(Array input, int padLength,
    {PadType padType = PadType.replicate}) {
  Array ret = Array.fromArray(input);
  int inputLen = input.length;
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
        ret.insert(0, input[i + 1]);
        ret.add(input[inputLen - 2 - i]);
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

class SavitzkyGolayFilter {
  final int windowSize;
  final int polyOrder;
  final double spacing;
  final int derivative;
  final Array coefficients;
  SavitzkyGolayFilter(this.windowSize, this.polyOrder,
      {this.spacing = 1.0, this.derivative = 0})
      : coefficients = SavitzkyGolayFilter.generateCoefficients(
            windowSize, polyOrder,
            spacing: spacing, derivative: derivative);
  static Array generateCoefficients(int windowSize, int polyOrder,
      {double spacing = 1.0, int derivative = 0}) {
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
    double norm;

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

    var coefficientsTemp = matrixInverse(J);
    Array coefficients = coefficientsTemp[derivative];

    norm = 1 / factorial(derivative);

    double det = norm * Math.pow(spacing, derivative);
    for (int i = 0; i < coefficients.length; i++) {
      coefficients[i] /= det;
    }

    return coefficients;
  }

  Array filter(Array signal, {PadType padType = PadType.replicate}) {
    int step = (windowSize.toDouble() / 2).floor();

    Array ans = Array.fixed(signal.length, initialValue: 0);

    signal = padArray(signal, step, padType: padType);
    for (int k = 0; k < signal.length - 2 * step; k++) {
      double d = 0;
      for (int l = 0; l < coefficients.length; l++) {
        d += (coefficients[l] * signal[l + k]);
      }
      ans[k] = d;
    }
    return ans;
  }
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
  var filter = SavitzkyGolayFilter(5, 2);
  var filtered = filter.filter(data, padType: PadType.symmetric);

  // print(data.length);
  // print(filtered.length);
  print(filtered);
}
