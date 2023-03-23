import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/shot_timer.dart';
import 'package:mysample/repository/repo_shotTimer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/response/shot_timer_response.dart';

class ShotTimerCubit extends Cubit<List<ShotTimerListResponseModel>> {
  ShotTimerCubit() : super(<ShotTimerListResponseModel>[]);

  var repository = RepositoryShotTimer();

  Future<ShotTimerAddResponse> addShotTimer(
      ShotTimerAddRequestModel shotTimerAddRequest) async {
    ShotTimerAddResponse result = await repository.addShotTimer(shotTimerAddRequest);

    return result;
  }

  Future<ShotTimerDeleteResponse> deleteShotTimer(
      ShotTimerDeleteRequestModel shotTimerDeleteRequest) async {
    ShotTimerDeleteResponse result =
        await repository.deleteShotTimer(shotTimerDeleteRequest);

    return result;
  }

  Future<List<ShotTimerListResponseModel>> listShotTimersByDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = await prefs.getString('deviceId');
    List<ShotTimerListResponseModel> shotTimers =
        await repository.listShotTimersByDeviceId(deviceId!);

    emit(shotTimers);
    return shotTimers;
  }

  Future<ShotTimerUpdateResponse> updateShotTimer(
      ShotTimerUpdateRequestModel request) async {
    ShotTimerUpdateResponse result = await repository.updateShotTimer(request);

    return result;
  }
}
