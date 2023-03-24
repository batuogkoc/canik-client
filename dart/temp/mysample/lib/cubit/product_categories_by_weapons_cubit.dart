import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/response/product_categories_weapons_response.dart';
import '../repository/repo_product_categories_weapons.dart';

class ProductCategoriesByWeaponsCubit extends Cubit<ProductCategoriesByWeaponsResponse> {
  ProductCategoriesByWeaponsCubit() : super(ProductCategoriesByWeaponsResponse(isError: false, message: '',productCategoriesByWeapons:[]));

  var repository = RepositoryProductCategoriesByWeapons();

  Future<ProductCategoriesByWeaponsResponse> getProductCategoriesByWeapons(String language) async {
    ProductCategoriesByWeaponsResponse productCategoriesByWeapons =
        await repository.getProductCategoriesByWeapons(language);

    emit(productCategoriesByWeapons);
    return productCategoriesByWeapons;
  }
}