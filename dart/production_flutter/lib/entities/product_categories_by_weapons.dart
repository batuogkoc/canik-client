class ProductCategoriesByWeapons{
      String categoryName;
      String categoryCode;
      List<ProductSubCategory> productSubCategory;
      ProductCategoriesByWeapons({
        required this.categoryName,
        required this.categoryCode,
        required this.productSubCategory
      });

      factory ProductCategoriesByWeapons.fromJson(Map<String, dynamic> json) {
        String categoryName = json["categoryName"] != null ? json["categoryName"] as String : "";
        String categoryCode = json["categoryCode"] != null ? json["categoryCode"] as String : "";
        List<ProductSubCategory> productSubCategory = json["productSubCategory"].map<ProductSubCategory>((itemjson) => ProductSubCategory.fromJson(itemjson)).toList();
        return ProductCategoriesByWeapons(categoryName: categoryName,categoryCode: categoryCode,productSubCategory:productSubCategory);
      }
}

class ProductSubCategory{
  String  productNumber;
      String  categoryName;
      String  categoryCode;
      String  parentProductCategoryName;
      String  imageUrl;
      ProductSubCategory({
        required this.productNumber,
        required this.categoryName,
        required this.categoryCode,
        required this.parentProductCategoryName,
        required this.imageUrl
      });

      factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
        String productNumber = json["productNumber"] != null ? json["productNumber"] as String : "";
        String categoryName = json["categoryName"] != null ? json["categoryName"] as String : "";
        String categoryCode = json["categoryCode"] != null ? json["categoryCode"] as String : "";
        String parentProductCategoryName = json["parentProductCategoryName"] != null ? json["parentProductCategoryName"] as String : "";
        String imageUrl = json["imageUrl"] != null ? json["imageUrl"] as String : "";
        return ProductSubCategory(productNumber: productNumber,categoryName: categoryName,categoryCode: categoryCode,parentProductCategoryName: parentProductCategoryName,imageUrl: imageUrl);
      }
}