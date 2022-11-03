import "package:vector_math/vector_math.dart";

abstract class Ahrs {
  final Map<String, double> tuningParams;

  late Quaternion quaternion;

  Ahrs(this.tuningParams) : quaternion = Quaternion.identity();

  void updateIMU(Vector3 gyroRad, Vector3 accel, double dt);
  void updateMag(Vector3 gyroRad, Vector3 accel, Vector3 mag, double dt);
}
