class MainPageProduct {
  String productName;
  String imageUrl;
  int isActive;
  String createDate;
  MainPageProduct(
      {required this.productName,
      required this.imageUrl,
      required this.isActive,
      required this.createDate});
      
  factory MainPageProduct.fromJson(Map<String, dynamic> json) {
    String productName = json["productName"] as String;
    String imageUrl = json["imageUrl"] as String;
    int isActive = json["isActive"] as int;
    String createDate = json["createDate"] as String;
    return MainPageProduct(
        productName: productName,
        imageUrl: imageUrl,
        isActive: isActive,
        createDate: createDate);
  }
}
