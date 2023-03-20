import 'package:mysample/entities/shot_timer.dart';

class ShotTimerListResponse {
  bool isError;
  String message;
  List<ShotTimerListResponseModel> shotTimers;
  ShotTimerListResponse({
    required this.isError,
    required this.message,
    required this.shotTimers,
  });

  factory ShotTimerListResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<ShotTimerListResponseModel> shotTimers = json["result"]
        .map<ShotTimerListResponseModel>((jsonDataObject) =>
            ShotTimerListResponseModel.fromJson(jsonDataObject))
        .toList();

    return ShotTimerListResponse(
        isError: isError, message: message, shotTimers: shotTimers);
  }
}

class ShotTimerAddResponse {
  bool isError;
  String message;
  bool result;

  ShotTimerAddResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory ShotTimerAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return ShotTimerAddResponse(
        isError: isError, message: message, result: result);
  }
}

class ShotTimerUpdateResponse {
  bool isError;
  String message;
  bool result;

  ShotTimerUpdateResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory ShotTimerUpdateResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return ShotTimerUpdateResponse(
        isError: isError, message: message, result: result);
  }
}

class ShotTimerDeleteResponse {
  bool isError;
  String message;
  bool result;

  ShotTimerDeleteResponse({
    required this.isError,
    required this.message,
    required this.result,
  });

  factory ShotTimerDeleteResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return ShotTimerDeleteResponse(
        isError: isError, message: message, result: result);
  }
}

class ShotTimerRecordListResponse {
  bool isError;
  String message;
  List<ShotTimerRecordListResponseModel> shotTimerRecords;

  ShotTimerRecordListResponse({
    required this.isError,
    required this.message,
    required this.shotTimerRecords,
  });

  factory ShotTimerRecordListResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<ShotTimerRecordListResponseModel> shotTimerRecords = json["result"]
        .map<ShotTimerRecordListResponseModel>((jsonDataObject) =>
            ShotTimerRecordListResponseModel.fromJson(jsonDataObject))
        .toList();

    return ShotTimerRecordListResponse(
        isError: isError, message: message, shotTimerRecords: shotTimerRecords);
  }
}
