
import '../product_categories_by_weapons.dart';

class ProductCategoriesByWeaponsResponse{
  String message;
  bool isError;
  List<ProductCategoriesByWeapons> productCategoriesByWeapons;
  ProductCategoriesByWeaponsResponse({
    required this.message,
    required this.isError,
    required this.productCategoriesByWeapons
  });

  factory ProductCategoriesByWeaponsResponse.fromJson(Map<String,dynamic> json){
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<ProductCategoriesByWeapons> productCategoriesByWeapons = json["result"].map<ProductCategoriesByWeapons>((jsonDataObject)=> ProductCategoriesByWeapons.fromJson(jsonDataObject)).toList();

    return ProductCategoriesByWeaponsResponse(message: message,isError: isError,productCategoriesByWeapons: productCategoriesByWeapons);
  }
}