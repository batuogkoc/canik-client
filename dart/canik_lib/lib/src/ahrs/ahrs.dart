import "package:vector_math/vector_math.dart";

abstract class Ahrs {
  final Map<String, double> tuningParams;

  late Quaternion _quaternion;

  Ahrs(this.tuningParams) : _quaternion = Quaternion.identity();

  Quaternion get quaternion {
    return _quaternion.clone();
  }

  set quaternion(Quaternion quat) {
    _quaternion.setFrom(quat);
  }

  void updateIMU(Vector3 gyroRad, Vector3 accel, double dt);
  void updateMag(Vector3 gyroRad, Vector3 accel, Vector3 mag, double dt);
}
