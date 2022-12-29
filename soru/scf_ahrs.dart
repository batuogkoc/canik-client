import 'ahrs.dart';
import 'dart:math';
import "package:vector_math/vector_math.dart";
import 'package:dart_numerics/dart_numerics.dart' as numerics;

class ScfAhrs implements Ahrs {
  final double mLambda1, mLambda2;
  final double aLambda1, aLambda2;
  @override
  final Map<String, double> tuningParams;
  @override
  late Quaternion _quaternion;

  ScfAhrs(this.tuningParams)
      : mLambda1 = tuningParams["mLambda1"] ?? 0.1,
        mLambda2 = tuningParams["mLambda2"] ?? 0.1,
        aLambda1 = tuningParams["aLambda1"] ?? 0.1,
        aLambda2 = tuningParams["aLambda2"] ?? 0.1 {
    _quaternion = Quaternion.identity();
  }

  double _fCor(double alpha, double tuningParam1, double tuningParam2) {
    // double alphaLambda1 = alpha * tuningParam1;
    return tuningParam1;
    // return alphaLambda1;
    // if (alphaLambda1 < tuningParam2) {
    //   return alphaLambda1;
    // } else {
    //   return tuningParam2;
    // }
  }

  @override
  void updateIMU(Vector3 gyroRad, Vector3 accel, double dt) {
    accel = accel.clone();
    gyroRad = gyroRad.clone();
    accel.normalize();

    // Vector3 gyroDeltaT = gyroRad * dt;
    // Quaternion qDot = Quaternion(
    //     sin(gyroDeltaT.x / 2), sin(gyroDeltaT.y / 2), sin(gyroDeltaT.z / 2), 0);
    // qDot.w = sqrt(max((1 - qDot.length2), 0)); //TODO: prevent NaNs

    // Quaternion qDot =
    //     Quaternion(gyroDeltaT.x / 2, gyroDeltaT.y / 2, gyroDeltaT.z / 2, 1);
    // // qDot.normalize();
    // Quaternion qPred = qDot * _quaternion;
    Quaternion qDot = Quaternion.dq(_quaternion, gyroRad);
    Quaternion qPred = _quaternion + qDot.scaled(dt);

    Vector3 accelRef = Vector3(0, 0, 1);
    Vector3 accelPred = qPred.rotated(accelRef).normalized();

    double alphaAccel = acos(accel.dot(accelPred).clamp(-1.0, 1.0));

    Vector3 accelCor = accel.cross(accelPred).normalized();

    double betaAccel = _fCor(alphaAccel, aLambda1, aLambda2);

    Vector3 fCorVector = (accelCor * (betaAccel));
    double c = numerics.sinc(fCorVector.length);
    Quaternion qCor = Quaternion(fCorVector.x * c, fCorVector.y * c,
        fCorVector.z * c, sqrt(1 - fCorVector.length2 * c * c));
    _quaternion = qPred * qCor;

    _quaternion.normalize();
  }

  @override
  void updateMag(Vector3 gyroRad, Vector3 accel, Vector3 mag, double dt) {
    accel = accel.clone();
    gyroRad = gyroRad.clone();
    mag = mag.clone();

    accel.normalize();
    mag.normalize();

    // Vector3 gyroDeltaT = gyroRad * dt;
    // Quaternion qDot = Quaternion(
    //     sin(gyroDeltaT.x / 2), sin(gyroDeltaT.y / 2), sin(gyroDeltaT.z / 2), 0);
    // qDot.w = sqrt(max((1 - qDot.length2), 0)); //TODO: prevent NaNs

    // Quaternion qDot =
    //     Quaternion(gyroDeltaT.x / 2, gyroDeltaT.y / 2, gyroDeltaT.z / 2, 1);
    // // qDot.normalize();
    // Quaternion qPred = qDot * _quaternion;
    Quaternion qDot = Quaternion.dq(_quaternion, gyroRad);
    Quaternion qPred = _quaternion + qDot.scaled(dt);

    Vector3 accelRef = Vector3(0, 0, 1);
    Vector3 accelPred = qPred.rotated(accelRef).normalized();
    Vector3 magRef = Vector3(0, 0, accelPred.dot(mag));
    magRef.x = sqrt((1 - (magRef.z) * (magRef.z)).clamp(0.0, 1.0));
    Vector3 magPred = qPred.rotated(magRef);

    double alphaAccel = acos(accel.dot(accelPred).clamp(-1.0, 1.0));
    Vector3 accelCor = accel.cross(accelPred).normalized();
    double alphaMag = acos(mag.dot(magPred).clamp(-1.0, 1.0));
    Vector3 magCor = mag.cross(magPred).normalized();

    double betaAccel = _fCor(alphaAccel, aLambda1, aLambda2);
    double betaMag = _fCor(alphaMag, mLambda1, mLambda2);

    Vector3 fCorVector = (accelCor * (betaAccel / 2) + magCor * (betaMag / 2));
    double c = numerics.sinc(fCorVector.length);
    Quaternion qCor = Quaternion(fCorVector.x * c, fCorVector.y * c,
        fCorVector.z * c, sqrt(1 - fCorVector.length2 * c * c));
    _quaternion = qPred * qCor;

    _quaternion.normalize();
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
