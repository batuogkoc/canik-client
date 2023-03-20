import 'package:mysample/entities/product_category.dart';

class ProductCategoryResponse {
  List<ProductCategory> productCategories;
  bool isError;
  String message;
  ProductCategoryResponse({
    required this.productCategories,
    required this.isError,
    required this.message,
  });

  factory ProductCategoryResponse.fromJson(Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;
    List<ProductCategory> productCategories = json["result"]
        .map<ProductCategory>(
            (jsonDataObject) => ProductCategory.fromJson(jsonDataObject))
        .toList();

    return ProductCategoryResponse(
        productCategories: productCategories,
        isError: isError,
        message: message);
  }
}
