import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/weapon_care_response.dart';
import 'package:mysample/entities/weapon_care.dart';
import 'package:mysample/repository/repo_weapon_care.dart';

class WeaponCareCubit extends Cubit<WeaponCareListResponse> {
  WeaponCareCubit()
      : super(WeaponCareListResponse(
            isError: false, message: '', weaponCares: []));

  var repository = RepositoryWeaponCare();

  Future<WeaponCareAddResponse> addWeaponCare(
      WeaponCareAddRequestModel weaponCareAddRequestModel) async {
    WeaponCareAddResponse result =
        await repository.addWeaponCare(weaponCareAddRequestModel);

    return result;
  }

  Future<WeaponCareListResponse> getAllWeaponCares(
      WeaponCareListRequestModel weaponCareListRequestModel) async {
    WeaponCareListResponse weaponCares =
        await repository.listWeaponCare(weaponCareListRequestModel);

    emit(weaponCares);
    return weaponCares;
  }

  Future<bool> updateWeaponCare(
      WeaponCareUpdateRequestModel weaponCareUpdateRequestModel) async {
    bool result =
        await repository.updateWeaponCare(weaponCareUpdateRequestModel);

    return result;
  }
}
