import 'package:vector_math/vector_math.dart';
import 'dart:math';

Vector3 quaternionToEuler(Quaternion q) {
  q = q.normalized();
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
  ret.y = asin(sinp.clamp(-1.0, 1.0));

  // yaw (z-axis rotation)
  double siny_cosp = 2 * (w * z + x * y);
  double cosy_cosp = 1 - 2 * (y * y + z * z);
  ret.z = atan2(siny_cosp, cosy_cosp);

  return ret;
}

Vector3 accelToEuler(Vector3 accel) {
  // Vector3 euler = Vector3(0, 0, 0);
  //roll x axis
  double roll = atan2(accel.y, sqrt(accel.z * accel.z + accel.x + accel.x));
  //pitch y axis
  double pitch = atan2(-accel.x, sqrt(accel.z * accel.z + accel.y + accel.y));
  //yaw y axis
  double yaw = atan2(accel.y, accel.x);

  return Vector3(roll, pitch, 0);
}

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

extension QuaternionUtils on Quaternion {
  Vector3 toEuler() {
    double w = this.w;
    double x = this.x;
    double y = this.y;
    double z = this.z;
    Vector3 ret = Vector3.zero(); //roll pitch yaw

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
}
