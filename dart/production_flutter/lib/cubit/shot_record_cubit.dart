import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/shot_record.dart';
import 'package:mysample/repository/repo_shot_record.dart';

import '../entities/response/shot_record_response.dart';

class ShotRecordCubit extends Cubit<ShotRecordListResponse> {
  ShotRecordCubit()
      : super(ShotRecordListResponse(
            isError: false, message: '', shotRecords: []));

  var repository = RepositoryShotRecord();

  Future<ShotRecordAddResponse> addShotRecord(
      ShotRecordAddRequestModel shotRecordAddRequestModel) async {
    ShotRecordAddResponse result =
        await repository.addShotRecord(shotRecordAddRequestModel);

    return result;
  }

  Future<ShotRecordListResponse> listShotRecords(
      ShotRecordListRequestModel shotRecordListRequestModel) async {
    ShotRecordListResponse shotRecords =
        await repository.listShotRecords(shotRecordListRequestModel);

    emit(shotRecords);
    return shotRecords;
  }

  Future<bool> updateShotRecord(
      ShotRecordUpdateRequestModel shotRecordUpdateRequestModel) async {
    bool result =
        await repository.updateShotRecord(shotRecordUpdateRequestModel);

    return result;
  }
}
