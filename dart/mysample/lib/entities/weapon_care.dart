class WeaponCareAddRequestModel {
  String careType;
  String careDate;
  String explanation;
  String serialNumber;
  String canikId;

  WeaponCareAddRequestModel({
    required this.careType,
    required this.careDate,
    required this.explanation,
    required this.serialNumber,
    required this.canikId,
  });
}

class WeaponCareListRequestModel {
  String serialNumber;
  String canikId;

  WeaponCareListRequestModel({
    required this.serialNumber,
    required this.canikId,
  });
}

class WeaponCareUpdateRequestModel {
  String careType;
  String careDate;
  String explanation;
  String recordID;
  bool isDeleted = false;

  WeaponCareUpdateRequestModel({
    required this.careType,
    required this.careDate,
    required this.explanation,
    required this.recordID,
    required this.isDeleted,
  });
}

class WeaponCareListResponseModel {
  String careType;
  String careDate;
  String explanation;
  String recordId;

  WeaponCareListResponseModel({
    required this.careType,
    required this.careDate,
    required this.explanation,
    required this.recordId,
  });

  factory WeaponCareListResponseModel.fromJson(Map<String, dynamic> json) {
    String careType = json["careType"] as String;
    String careDate = json["careDate"] as String;
    String explanation = json["explanation"] == null ? "" : json["explanation"] as String;
    String recordId = json["recordId"] as String;

    return WeaponCareListResponseModel(
        careType: careType,
        careDate: careDate,
        explanation: explanation,
        recordId: recordId);
  }
}
