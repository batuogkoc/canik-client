import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/weapon.dart';

import '../repository/repo_weapon.dart';

class WeaponListCubit extends Cubit<WeaponToUserListResponse> {
  WeaponListCubit()
      : super(WeaponToUserListResponse(isError: false, message: '', weaponToUsers: <WeaponToUserListResponseModel>[]));
  var repository = RepositoryWeapon();

  Future<WeaponToUserListResponse> getAllWeaponToUsers(WeaponToUserListRequestModel request) async {
    WeaponToUserListResponse response = await repository.listWeaponToUser(request);

    emit(response);
    return response;
  }
}
