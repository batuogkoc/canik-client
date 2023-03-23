import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/weapon.dart';
import 'package:mysample/repository/repo_weapon.dart';

class WeaponAddCubit extends Cubit<void> {
  WeaponAddCubit() : super(false);

  var repository = RepositoryWeapon();

  Future<WeaponToUserAddResponse> addWeaponToUser(
      WeaponToUserAddRequestModel request) async {
    WeaponToUserAddResponse result = await repository.addWeaponToUser(request);

    return result;
  }
}
