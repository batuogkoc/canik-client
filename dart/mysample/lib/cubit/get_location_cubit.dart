import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/location_permission.dart';
import '../entities/response/location_permission_response.dart';
import '../repository/repo_location_permission.dart';

class GetLocationCubit extends Cubit<GetLocationPermissionResponse> {
  GetLocationCubit()
      : super(GetLocationPermissionResponse(isError: false, message: '', getLocationPermissionResponseModel: []));

  var repository = RepositoryPermission();

  Future<GetLocationPermissionResponse> getLocationPermission(
      GetLocationPermissionRequestModel getLocationPermissionRequestModel) async {
    GetLocationPermissionResponse getLocationPermissionResponse =
        await repository.getLocationPermission(getLocationPermissionRequestModel);

    emit(getLocationPermissionResponse);
    return getLocationPermissionResponse;
  }
}
