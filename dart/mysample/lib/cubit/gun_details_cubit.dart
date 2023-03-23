import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/product_category_assignment.dart';

import '../repository/repo_product.dart';

class GunDetailPageCubit extends Cubit<List<ProductCategoryAssignment>> {
  GunDetailPageCubit() : super(<ProductCategoryAssignment>[]);

  var repository = RepositoryProduct();

  Future<void> getProductCategoryAssignments(String productCategoryCode) async {
    List<ProductCategoryAssignment> productCategoryAssignments =
        await repository.getAllProductCategoryAssignments(productCategoryCode);

    emit(productCategoryAssignments);
  }
}
