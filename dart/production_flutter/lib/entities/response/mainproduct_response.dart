import 'package:flutter/cupertino.dart';
import 'package:mysample/entities/main_page_product.dart';

class MainPageProductResponse {
  List<MainPageProduct> mainPageProducts;
  String message;
  bool isError;

  MainPageProductResponse({
    required this.mainPageProducts,
    required this.message,
    required this.isError,
  });

  factory MainPageProductResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<MainPageProduct> mainPageProducts = json["result"].map<MainPageProduct>((jsonDataObject) => MainPageProduct.fromJson(jsonDataObject)).toList();

    return MainPageProductResponse(
        mainPageProducts: mainPageProducts, message: message, isError: isError);
  }
}

