import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/response/shot_record_response.dart';
import '../entities/shot_record.dart';
import '../repository/repo_shot_record.dart';

class AllShotRecordCubit extends Cubit<ShotRecordListWithCanikIdResponse> {
  AllShotRecordCubit() : super(ShotRecordListWithCanikIdResponse(isError: false, message: '', shotRecords: []));

  var repository = RepositoryShotRecord();

  Future<ShotRecordListWithCanikIdResponse> listShotRecords(ShotRecordListWithCanikIdRequestModel shotRecordListWithCanikIdRequestModel) async {
    ShotRecordListWithCanikIdResponse shotRecords =
        await repository.listShotRecordWithcanikId(shotRecordListWithCanikIdRequestModel);

    emit(shotRecords);
    return shotRecords;
  }
}
