


import 'package:http/http.dart';

class CompareAllWeapons{
  bool isError;
  String message;
  List<GetAllWeaponsResponseModel> result;
  CompareAllWeapons({
    required this.isError,
    required this.message,
    required this.result
  });

  factory CompareAllWeapons.fromJson(Map<String,dynamic> json){
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<GetAllWeaponsResponseModel> result = json["result"].map<GetAllWeaponsResponseModel>((jsonobject) => GetAllWeaponsResponseModel.fromJson(jsonobject)).toList();
    // List Olarak Gelmeseydi 
    // GetAllWeaponsResponseModel result2 = GetAllWeaponsResponseModel.fromJson(json["result"]);
    return CompareAllWeapons(isError: isError, message: message, result: result);
  }
}

class GetAllWeaponsResponseModel{
  String categoryName;
  String parentProductCategoryName;

  GetAllWeaponsResponseModel({
    required this.categoryName,
    required this.parentProductCategoryName
  });

  factory GetAllWeaponsResponseModel.fromJson(Map<String,dynamic> json){
    String categoryName = json["categoryName"] as String;
    String parentProductCategoryName = json["parentProductCategoryName"] as String;

    return GetAllWeaponsResponseModel(categoryName: categoryName, parentProductCategoryName: parentProductCategoryName);
  }
}