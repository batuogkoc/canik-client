import 'package:mysample/entities/weapon_care.dart';

class WeaponCareAddResponse {
  bool isError;
  String message;
  bool result;

  WeaponCareAddResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory WeaponCareAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return WeaponCareAddResponse(
        isError: isError, message: message, result: result);
  }
}

class WeaponCareListResponse {
  bool isError;
  String message;
  List<WeaponCareListResponseModel> weaponCares;

  WeaponCareListResponse({
    required this.isError,
    required this.message,
    required this.weaponCares,
  });

  factory WeaponCareListResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<WeaponCareListResponseModel> weaponCares = json["result"]
        .map<WeaponCareListResponseModel>((jsonDataObject) =>
            WeaponCareListResponseModel.fromJson(jsonDataObject))
        .toList();

    return WeaponCareListResponse(
        weaponCares: weaponCares, isError: isError, message: message);
  }
}

class WeaponCareUpdateResponse {
  bool isError;
  String message;
  String result;

  WeaponCareUpdateResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory WeaponCareUpdateResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    String result = json["result"] as String;
    return WeaponCareUpdateResponse(
        isError: isError, message: message, result: result);
  }
}
