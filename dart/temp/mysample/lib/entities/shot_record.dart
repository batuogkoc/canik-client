class ShotRecordAddRequestModel {
  String serialNumber;
  String canikId;
  String polygon;
  String explanation;
  String numberShots;
  String date;

  ShotRecordAddRequestModel({
    required this.serialNumber,
    required this.canikId,
    required this.polygon,
    required this.explanation,
    required this.numberShots,
    required this.date,
  });
}
class ShotRecordSummaryModel {
  String serialNumber;
  String numberShots;
  String name;

  ShotRecordSummaryModel({
    required this.serialNumber,
    required this.numberShots,
    required this.name,
  });
}
class ShotRecordUpdateRequestModel {
  String polygon;
  String explanation;
  String numberShots;
  String date;
  bool isDeleted = false;
  String recordID;

  ShotRecordUpdateRequestModel({
    required this.polygon,
    required this.explanation,
    required this.numberShots,
    required this.date,
    required this.isDeleted,
    required this.recordID,
  });
}

class ShotRecordListRequestModel {
  String serialNumber;
  String canikId;

  ShotRecordListRequestModel({
    required this.serialNumber,
    required this.canikId,
  });
}

class ShotRecordModel {
  String polygon;
  String explanation;
  String numberShots;
  String date;
  String recordId;

  ShotRecordModel({
    required this.polygon,
    required this.explanation,
    required this.numberShots,
    required this.date,
    required this.recordId,
  });

  factory ShotRecordModel.fromJson(Map<String, dynamic> json) {
    String polygon = json["polygon"] as String;
    String explanation = json["explanation"] == null ? "" : json["explanation"] as String;
    String numberShots = json["numberShots"] as String;
    String date = json["date"] as String;
    String recordId = json["recordId"] as String;

    return ShotRecordModel(
        polygon: polygon, explanation: explanation, numberShots: numberShots, date: date, recordId: recordId);
  }
}

class ShotRecordListWithCanikIdRequestModel {
  String canikId;

  ShotRecordListWithCanikIdRequestModel({
    required this.canikId,
  });
}

class ShotRecordListWithCanikIdResponseModel {
  String polygon;
  String explanation;
  String numberShots;
  String date;
  String recordId;
  String serialNumber;

  ShotRecordListWithCanikIdResponseModel({
    required this.polygon,
    required this.explanation,
    required this.numberShots,
    required this.date,
    required this.recordId,
    required this.serialNumber,
  });

  factory ShotRecordListWithCanikIdResponseModel.fromJson(Map<String, dynamic> json) {
    String polygon = json["polygon"] as String;
    String explanation = json["explanation"] == null ? "" : json["explanation"] as String;
    String numberShots = json["numberShots"] as String;
    String date = json["date"] as String;
    String recordId = json["recordId"] as String;
    String serialNumber = json["serialNumber"] as String;

    return ShotRecordListWithCanikIdResponseModel(
        polygon: polygon,
        explanation: explanation,
        numberShots: numberShots,
        date: date,
        recordId: recordId,
        serialNumber: serialNumber);
  }
   
}

