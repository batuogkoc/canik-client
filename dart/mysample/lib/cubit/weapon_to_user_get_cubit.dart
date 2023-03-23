import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/weapon.dart';

import '../repository/repo_weapon.dart';

class WeaponToUserGetCubit extends Cubit<WeaponToUserGetResponse> {
  WeaponToUserGetCubit()
      : super(WeaponToUserGetResponse(
            isError: false,
            message: '',
            weaponToUser: <WeaponToUserGetResponseModel>[]));
  var repository = RepositoryWeapon();

  Future<WeaponToUserGetResponse> getWeaponToUserByRecordId(
      WeaponToUserGetRequestModel request) async {
    WeaponToUserGetResponse response =
        await repository.getWeaponToUserByRecordId(request);

    emit(response);
    return response;
  }

  Future<WeaponNameGetResponse> getWeaponName(
      WeaponNameGetRequestModel request) async {
    WeaponNameGetResponse response = await repository.getWeaponName(request);

    return response;
  }
}
