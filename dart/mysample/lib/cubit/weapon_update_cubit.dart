import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';

import '../entities/weapon.dart';
import '../repository/repo_weapon.dart';

class WeaponUpdateCubit extends Cubit<void> {
  WeaponUpdateCubit() : super(false);

  var repository = RepositoryWeapon();

  Future<WeaponToUserUpdateResponse> updateWeaponToUser(
      WeaponToUserUpdateRequestModel request) async {
    WeaponToUserUpdateResponse result =
        await repository.updateWeaponToUser(request);

    return result;
  }
}
