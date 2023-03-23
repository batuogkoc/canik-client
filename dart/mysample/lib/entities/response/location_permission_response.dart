import '../location_permission.dart';

class LocationPermissionAddResponse {
  bool result;
  String message;
  bool isError;

  LocationPermissionAddResponse({
    required this.result,
    required this.message,
    required this.isError,
  });
  factory LocationPermissionAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] ;

    return LocationPermissionAddResponse(result: result, message: message, isError: isError);
  }
}

class GetLocationPermissionResponse {
  List<GetLocationPermissionResponseModel> getLocationPermissionResponseModel;
  String message;
  bool isError;

  GetLocationPermissionResponse({
    required this.getLocationPermissionResponseModel,
    required this.message,
    required this.isError,
  });

  factory GetLocationPermissionResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<GetLocationPermissionResponseModel> getLocationPermissionResponseModel = json["result"]
        .map<GetLocationPermissionResponseModel>(
            (jsonDataObject) => GetLocationPermissionResponseModel.fromJson(jsonDataObject))
        .toList();

    return GetLocationPermissionResponse(
      getLocationPermissionResponseModel: getLocationPermissionResponseModel,
      message: message,
      isError: isError,
    );
  }
}
