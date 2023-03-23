class ProductCategoryAssignment {
  String productNumber;
  String productCategoryName;
  String? productImageUrl;

  ProductCategoryAssignment({required this.productNumber, required this.productCategoryName, this.productImageUrl});

  factory ProductCategoryAssignment.fromJson(Map<String, dynamic> json) {
    String productNumber = json["productNumber"] as String;
    String productCategoryName = json["productCategoryName"] as String;
    String? productImageUrl = json['productImageUrl'] as String?;
    return ProductCategoryAssignment(
        productNumber: productNumber, productCategoryName: productCategoryName, productImageUrl: productImageUrl);
  }
}
