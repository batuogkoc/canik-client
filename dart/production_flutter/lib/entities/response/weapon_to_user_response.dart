import 'package:mysample/entities/weapon.dart';

class WeaponToUserAddResponse {
  bool isError;
  String message;
  List<WeaponToUserAddResponseModel> result;

  WeaponToUserAddResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory WeaponToUserAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<WeaponToUserAddResponseModel> result = json["result"]
        .map<WeaponToUserAddResponseModel>((jsonDataObject) =>
            WeaponToUserAddResponseModel.fromJson(jsonDataObject))
        .toList();

    return WeaponToUserAddResponse(
        isError: isError, message: message, result: result);
  }
}

class WeaponToUserListResponse {
  bool isError;
  String message;
  List<WeaponToUserListResponseModel> weaponToUsers;

  WeaponToUserListResponse({
    required this.isError,
    required this.message,
    required this.weaponToUsers,
  });

  factory WeaponToUserListResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<WeaponToUserListResponseModel> weaponToUsers = json["result"]
        .map<WeaponToUserListResponseModel>((jsonDataObject) =>
            WeaponToUserListResponseModel.fromJson(jsonDataObject))
        .toList();

    return WeaponToUserListResponse(
        isError: isError, message: message, weaponToUsers: weaponToUsers);
  }
}

class WeaponToUserUpdateResponse {
  bool isError;
  String message;
  bool result;

  WeaponToUserUpdateResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory WeaponToUserUpdateResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return WeaponToUserUpdateResponse(
        isError: isError, message: message, result: result);
  }
}

class WeaponNameGetResponse {
  bool isError;
  String message;
  List<WeaponNameGetResponseModel> result;

  WeaponNameGetResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory WeaponNameGetResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<WeaponNameGetResponseModel> weaponName = json["result"]
        .map<WeaponNameGetResponseModel>((jsonDataObject) =>
            WeaponNameGetResponseModel.fromJson(jsonDataObject))
        .toList();

    return WeaponNameGetResponse(
        isError: isError, message: message, result: weaponName);
  }
}

class WeaponToUserGetResponse {
  bool isError;
  String message;
  List<WeaponToUserGetResponseModel> weaponToUser;

  WeaponToUserGetResponse({
    required this.isError,
    required this.message,
    required this.weaponToUser,
  });

  factory WeaponToUserGetResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<WeaponToUserGetResponseModel> weaponToUser = json["result"]
        .map<WeaponToUserGetResponseModel>((jsonDataObject) =>
            WeaponToUserGetResponseModel.fromJson(jsonDataObject))
        .toList();

    return WeaponToUserGetResponse(
        isError: isError, message: message, weaponToUser: weaponToUser);
  }
}
