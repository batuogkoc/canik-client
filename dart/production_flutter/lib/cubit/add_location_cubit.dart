import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/location_permission_response.dart';
import 'package:mysample/repository/repo_location_permission.dart';

import '../entities/location_permission.dart';

class LocationAddCubit extends Cubit<LocationPermissionAddResponse> {
  LocationAddCubit() : super(LocationPermissionAddResponse(isError: false, message: '', result: false));

  var repository = RepositoryPermission();

  Future<LocationPermissionAddResponse> addLocationIys(
      AddLocationPermissionRequestModel addLocationPermissionRequestModel) async {
    LocationPermissionAddResponse locationAddPermission =
        await repository.addLocation(addLocationPermissionRequestModel);

    emit(locationAddPermission);
    return locationAddPermission;
  }
}
