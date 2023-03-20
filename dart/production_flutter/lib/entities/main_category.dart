class MainCategory {
  String parentProductCategoryName;

  MainCategory({required this.parentProductCategoryName});

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    String parentProductCategoryName =
        json["parentProductCategoryName"] as String;

    return MainCategory(parentProductCategoryName: parentProductCategoryName);
  }
}

class GetAllProducts {
  String? productNumber;
  String? productCategoryName;

  GetAllProducts({
    this.productNumber,
    this.productCategoryName,
  });

  factory GetAllProducts.fromJson(Map<String, dynamic> json) {
    String? productNumber = json["productNumber"] as String?;
    String? productCategoryName = json["productCategoryName"] as String?;

    return GetAllProducts(
        productNumber: productNumber, productCategoryName: productCategoryName);
  }
}
