import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/accessory.dart';
import 'package:mysample/repository/repo_accessory.dart';

class AccessoryCubit extends Cubit<List<Accessory>> {
  AccessoryCubit() : super(<Accessory>[]);

  var repository = RepositoryAccessory();

  Future<bool> addAccessory(AccessoryAddRequestModel accesoryAddRequest) async {
    bool result = await repository.addAccessory(accesoryAddRequest);

    return result;
  }

  Future<bool> deleteAccessory(
      AccessoryDeleteRequestModel accessoryDeleteRequest) async {
    bool result = await repository.deleteAccessory(accessoryDeleteRequest);

    return result;
  }

  Future<void> getAllAccessories(
      AccessoryListRequestModel accessoryListRequest) async {
    List<Accessory> accessories =
        await repository.listAccessory(accessoryListRequest);

    emit(accessories);
  }
}
