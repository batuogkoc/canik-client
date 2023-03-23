import 'package:mysample/entities/shot_record.dart';

class ShotRecordAddResponse {
  bool result;
  String message;
  bool isError;

  ShotRecordAddResponse({
    required this.result,
    required this.message,
    required this.isError,
  });

  factory ShotRecordAddResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return ShotRecordAddResponse(result: result, message: message, isError: isError);
  }
}

class ShotRecordUpdateResponse {
  String result;
  String message;
  bool isError;

  ShotRecordUpdateResponse({
    required this.result,
    required this.message,
    required this.isError,
  });

  factory ShotRecordUpdateResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    String result = json["result"] as String;

    return ShotRecordUpdateResponse(result: result, message: message, isError: isError);
  }
}

class ShotRecordListResponse {
  List<ShotRecordModel> shotRecords;
  String message;
  bool isError;

  ShotRecordListResponse({
    required this.shotRecords,
    required this.message,
    required this.isError,
  });

  factory ShotRecordListResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<ShotRecordModel> shotRecords =
        json["result"].map<ShotRecordModel>((jsonDataObject) => ShotRecordModel.fromJson(jsonDataObject)).toList();

    return ShotRecordListResponse(shotRecords: shotRecords, message: message, isError: isError);
  }
}

class ShotRecordListWithCanikIdResponse {
  List<ShotRecordListWithCanikIdResponseModel> shotRecords;
  String message;
  bool isError;

  ShotRecordListWithCanikIdResponse({
    required this.shotRecords,
    required this.message,
    required this.isError,
  });

  factory ShotRecordListWithCanikIdResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    List<ShotRecordListWithCanikIdResponseModel> shotRecordsWithCanikId = json["result"]
        .map<ShotRecordListWithCanikIdResponseModel>(
            (jsonDataObject) => ShotRecordListWithCanikIdResponseModel.fromJson(jsonDataObject))
        .toList();

    return ShotRecordListWithCanikIdResponse(shotRecords: shotRecordsWithCanikId, message: message, isError: isError);
  }
 
}
