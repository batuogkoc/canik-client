import 'ahrs.dart';
import 'dart:math';
import "package:vector_math/vector_math.dart";
import 'package:dart_numerics/dart_numerics.dart' as numerics;

class FscfCcAhrs implements Ahrs {
  final double mLambda1;
  final double aLambda1;
  @override
  final Map<String, double> tuningParams;
  @override
  late Quaternion _quaternion;

  FscfCcAhrs(this.tuningParams)
      : mLambda1 = tuningParams["mLambda1"] ?? 0.1,
        aLambda1 = tuningParams["aLambda1"] ?? 0.1 {
    _quaternion = Quaternion.identity();
  }

  double _fCor(double alpha, double tuningParam1) {
    return tuningParam1;
  }

  @override
  void updateIMU(Vector3 gyroRad, Vector3 accel, double dt) {
    throw UnimplementedError("updateImu of fscf_cc not implemented");
  }

  @override
  void updateMag(Vector3 gyroRad, Vector3 accel, Vector3 mag, double dt) {
    accel = accel.clone();
    gyroRad = gyroRad.clone();
    mag = mag.clone();

    accel.normalize();
    mag.normalize();
    _quaternion.normalize();
    Quaternion qDot =
        _quaternion * Quaternion(gyroRad.x, gyroRad.y, gyroRad.z, 0);
    // Quaternion qDot = Quaternion.dq(_quaternion, gyroRad);

    Quaternion qp = _quaternion + qDot;
    qp.normalize();

    Matrix3 R = Matrix3.zero();
    R.setRow(
        0,
        Vector3(2 * (0.5 - qp.y * qp.y - qp.z * qp.z), 0,
            2 * (qp.x * qp.z - qp.w * qp.y)));
    R.setRow(
        1,
        Vector3(2 * (qp.x * qp.y - qp.w * qp.z), 0,
            2 * (qp.w * qp.x + qp.y * qp.z)));
    R.setRow(
        2,
        Vector3(2 * (qp.w * qp.y + qp.x * qp.z), 0,
            2 * (0.5 - qp.x * qp.x - qp.y * qp.y)));

    Vector3 accMesPred = R.getColumn(2).normalized();
    Vector3 h = _quaternion.rotate(mag);
    double mr_z = accMesPred.dot(mag);
    double mr_x = sqrt((1 - mr_z * mr_z).clamp(0.0, 1.0));
    Vector3 mr = Vector3(mr_x, 0, mr_z);
    Vector3 magMesPred = R * mr;

    final veca = accel.cross(accMesPred).normalized();
    final vecm = mag.cross(magMesPred).normalized();
    final aPlusm = veca * (aLambda1 / 2) + vecm * (mLambda1 / 2);
    final qCor = Quaternion(aPlusm.x, aPlusm.y, aPlusm.z, 0);
    Quaternion quat = qp * qCor;

    if (quat.w < 0) {
      quat = -quat;
    }
    if (quat.storage.any((element) => element.isNaN)) {
      print("nan");
    }

    _quaternion = quat.normalized();
  }

  @override
  Quaternion get quaternion {
    return _quaternion.clone();
  }

  @override
  set quaternion(Quaternion quat) {
    _quaternion.setFrom(quat);
  }
}
