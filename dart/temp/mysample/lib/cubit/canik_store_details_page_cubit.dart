import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/product_category.dart';
import 'package:mysample/repository/repo_product.dart';

class CanikStoreDetailPageCubit extends Cubit<List<ProductCategory>> {
  CanikStoreDetailPageCubit() : super(<ProductCategory>[]);

  var repository = RepositoryProduct();

  Future<void> getAllProductCategories(String categoryName) async {
    List<ProductCategory> productCategories =
        await repository.getProductCategories(categoryName);

    emit(productCategories);
  }
}
