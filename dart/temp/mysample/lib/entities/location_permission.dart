class AddLocationPermissionRequestModel {
  String deviceId;
  String recordId;
  bool status;
  bool? isUpdated;

  AddLocationPermissionRequestModel({
    required this.deviceId,
    required this.recordId,
    required this.status,
    this.isUpdated,
  });
}

class GetLocationPermissionRequestModel {
  String deviceId;

  GetLocationPermissionRequestModel({
    required this.deviceId,
  });
}

class GetLocationPermissionResponseModel {
  bool status;
  String recordId;

  GetLocationPermissionResponseModel({
    required this.status,
    required this.recordId,
  });

  factory GetLocationPermissionResponseModel.fromJson(Map<String, dynamic> json) {
    bool status = json['status'] as bool;
    String recordId = json['recordId'] as String;
    return GetLocationPermissionResponseModel(status: status, recordId: recordId);
  }
}
