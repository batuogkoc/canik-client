import 'dart:convert';

class ProductCategory {
  String categoryName;
  String categoryCode;
  List<SubCategory> productSubCategory;

  ProductCategory({
    required this.categoryName,
    required this.categoryCode,
    required this.productSubCategory,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    String categoryName = json["categoryName"] as String;
    String categoryCode = json["categoryCode"] as String;
    List<SubCategory> productSubCategory =
        json["productSubCategory"].map<SubCategory>((jsonDataObject) => SubCategory.fromJson(jsonDataObject)).toList();

    return ProductCategory(
        categoryName: categoryName, categoryCode: categoryCode, productSubCategory: productSubCategory);
  }
}

class SubCategory {
  String? productNumber;
  String categoryName;
  String categoryCode;
  String? parentProductCategoryName;
  String? imageUrl;

  SubCategory({
    required this.categoryName,
    required this.categoryCode,
    this.parentProductCategoryName,
    this.productNumber,
    this.imageUrl
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    String categoryName = json["categoryName"] as String;
    String categoryCode = json["categoryCode"] as String;
    String? parentProductCategoryName = json["parentProductCategoryName"] as String?;
    String? productNumber = json["productNumber"] as String?;
    String? imageUrl = json["imageUrl"] as String?;

    return SubCategory(
        categoryName: categoryName, categoryCode: categoryCode, parentProductCategoryName: parentProductCategoryName,productNumber: productNumber,imageUrl: imageUrl);
  }
}
