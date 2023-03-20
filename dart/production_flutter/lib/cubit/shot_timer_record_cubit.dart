import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/response/shot_timer_response.dart';
import '../repository/repo_shotTimer.dart';

class ShotTimerRecordListCubit extends Cubit<ShotTimerRecordListResponse> {
  ShotTimerRecordListCubit()
      : super(ShotTimerRecordListResponse(
            isError: false, message: '', shotTimerRecords: []));

  var repository = RepositoryShotTimer();

  Future<void> listShotTimerRecordsByRecordId(String recordId) async {
    ShotTimerRecordListResponse shotTimerRecords =
        await repository.listShotTimerRecordsByRecordId(recordId);

    emit(shotTimerRecords);
  }
}
