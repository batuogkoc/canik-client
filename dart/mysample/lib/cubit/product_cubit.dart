import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/main_category.dart';
import 'package:mysample/entities/response/main_category_response.dart';
import 'package:mysample/repository/repo_product.dart';

class ProductCubit extends Cubit<GetAllProductsResponse> {
  ProductCubit()
      : super(
            GetAllProductsResponse(isError: false, message: '', products: []));

  var repository = RepositoryProduct();

  Future<GetAllProductsResponse> getProducts() async {
    GetAllProductsResponse products = await repository.getAllProducts();

    emit(products);
    return products;
  }

  // Future<void> searchProductsByKeyword(
  //     String productName, List<GetAllProducts> productList) async {
  //   var filteredProducts = productList.where((product) => product
  //       .productCategoryName!
  //       .toLowerCase()
  //       .contains(productName.toLowerCase()));
  //   emit(filteredProducts);
  // }
}
