


import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/response/compare_weapon_response.dart';
import '../repository/repo_compareweapon.dart';

class CompareWeaponCubit extends Cubit<CompareAllWeapons>{
  CompareWeaponCubit() : super(CompareAllWeapons(isError: false,message: "",result: []));

  var repository = CompareWeaponRepository();

  Future<CompareAllWeapons> getAllCompareWeapons() async{
   CompareAllWeapons getCompareWeapons = await repository.getCompareWeapons();
   emit(getCompareWeapons);
   return getCompareWeapons; 
  }


}