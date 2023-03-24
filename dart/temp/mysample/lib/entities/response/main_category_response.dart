import 'package:mysample/entities/main_category.dart';

class MainCategoryResponse {
  List<MainCategory> mainCategories;
  String message;
  bool isError;

  MainCategoryResponse({
    required this.mainCategories,
    required this.message,
    required this.isError,
  });

  factory MainCategoryResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<MainCategory> mainCategories = json["result"]
        .map<MainCategory>(
            (jsonDataObject) => MainCategory.fromJson(jsonDataObject))
        .toList();

    return MainCategoryResponse(
        mainCategories: mainCategories, message: message, isError: isError);
  }
}

class GetAllProductsResponse {
  List<GetAllProducts> products;
  String message;
  bool isError;

  GetAllProductsResponse({
    required this.products,
    required this.message,
    required this.isError,
  });

  factory GetAllProductsResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<GetAllProducts> products = json["result"]
        .map<GetAllProducts>(
            (jsonDataObject) => GetAllProducts.fromJson(jsonDataObject))
        .toList();

    return GetAllProductsResponse(
        products: products, message: message, isError: isError);
  }
}
