import 'package:mysample/entities/iys.dart';

class IysAddResponse {
  String result;
  String message;
  bool isError;

  IysAddResponse({
    required this.result,
    required this.message,
    required this.isError,
  });
  factory IysAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    String result = json["result"] as String;

    return IysAddResponse(result: result, message: message, isError: isError);
  }
}

class IysPermissionResponse {
  IysPermissionResponseModel iysPermissionResponse;
  String message;
  bool isError;

  IysPermissionResponse({
    required this.iysPermissionResponse,
    required this.message,
    required this.isError,
  });

  factory IysPermissionResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    IysPermissionResponseModel result = IysPermissionResponseModel.fromJson(json["result"]);

    return IysPermissionResponse(iysPermissionResponse: result, message: message, isError: isError);
  }
}
