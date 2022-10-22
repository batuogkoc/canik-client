import 'package:circular_buffer/circular_buffer.dart';
import 'package:csv/csv.dart';
import 'package:vector_math/vector_math.dart';
import "dart:io";
import 'dart:convert';
import 'canik_data.dart';
import 'dart:math';
import 'detectors/simplified_det.dart' as simplified_det;

double copySign(double magnitude, double sign) {
  // The highest order bit is going to be zero if the
  // highest order bit of m and s is the same and one otherwise.
  // So (m^s) will be positive if both m and s have the same sign
  // and negative otherwise.
  /*final long m = Double.doubleToRawLongBits(magnitude); // don't care about NaN
  final long s = Double.doubleToRawLongBits(sign);
  if ((m^s) >= 0) {
      return magnitude;
  }
  return -magnitude; // flip sign*/
  if (sign == 0.0 || sign.isNaN || magnitude.sign == sign.sign) {
    return magnitude;
  }
  return -magnitude; // flip sign
}

Vector3 quaternionToEuler(Quaternion q) {
  double w = q.w;
  double x = q.x;
  double y = q.y;
  double z = q.z;
  Vector3 ret = Vector3.zero(); //yaw pitch roll

  //roll (x-axis rotation)
  double sinr_cosp = 2 * (w * x + y * z);
  double cosr_cosp = 1 - 2 * (x * x + y * y);
  ret.x = atan2(sinr_cosp, cosr_cosp);

  //pitch (y-axis rotation)
  double sinp = 2 * (w * y - z * x);
  if ((sinp).abs() >= 1) {
    ret.y = copySign(pi / 2, sinp); // use 90 degrees if out of range
  } else {
    ret.y = asin(sinp);
  }

  // yaw (z-axis rotation)
  double siny_cosp = 2 * (w * z + x * y);
  double cosy_cosp = 1 - 2 * (y * y + z * z);
  ret.z = atan2(siny_cosp, cosy_cosp);

  return ret;
}

void main(List<String> args) {
  // final buffer = CircularBuffer<int>(2);
  // buffer
  //   ..add(1)
  //   ..add(2)
  //   ..add(3);
  // for (final element in buffer) {
  //   print(element);
  // }
  String path;
  if (args.isEmpty) {
    // stderr.write("No file specified\n");
    // return;
    path = "../test_data/DATA.csv";
  } else {
    path = args[0];
  }
  CsvToProccessedData(path);
}

void CsvToProccessedData(String path) async {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    return;
  }
  double time = 0;
  var stream = File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .where((event) {
    return event.every((element) {
      try {
        double value = element as double;
        value *= 2;
      } catch (e) {
        return false;
      }
      return true;
    });
  }).map((dynamicList) {
    List<double> list = dynamicList.cast<double>();
    var accel = Vector3(list[0], list[1], list[2]) / 1000;
    var gyro = Vector3(list[3], list[4], list[5]);
    double dt = list[6];
    time += dt;
    return RawData(accel, gyro, time);
  }).transform(RawDataToProcessedDataTransformer());
  // .forEach((element) {
  //   print(element.orientation);
  //   print(element.time);
  // });
  simplified_det.processedDataStream = stream;
  simplified_det.start();
}
