import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/iys.dart';

import '../entities/response/iys_response.dart';
import '../repository/repo_iys.dart';

class IysQuestioningListCubit extends Cubit<IysPermissionResponse> {
  IysQuestioningListCubit()
      : super(IysPermissionResponse(
            isError: false,
            iysPermissionResponse: IysPermissionResponseModel(call: false, eMail: false, sms: false),
            message: ''));

  var repository = RepositoryIys();

  Future<IysPermissionResponse> questioningListIys(IysPermissionRequestModel iysPermissionRequestModel) async {
    IysPermissionResponse iysPermissionResponseModel = await repository.permissionQuestioing(iysPermissionRequestModel);

    emit(iysPermissionResponseModel);
    return iysPermissionResponseModel;
  }
}
