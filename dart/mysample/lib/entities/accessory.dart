class AccessoryAddRequestModel {
  String accessoryName;
  String serialNumber;
  String canikId;
  bool isDeleted;

  AccessoryAddRequestModel({
    required this.accessoryName,
    required this.serialNumber,
    required this.canikId,
    this.isDeleted = false,
  });
}

class AccessoryDeleteRequestModel {
  String serialNumber;
  String recordID;

  AccessoryDeleteRequestModel({
    required this.serialNumber,
    required this.recordID,
  });
}

class AccessoryListRequestModel {
  String serialNumber;
  String canikId;

  AccessoryListRequestModel({
    required this.serialNumber,
    required this.canikId,
  });
}

class Accessory {
  String accessoryName;
  String recordId;
  DateTime dateTime;

  Accessory({
    required this.accessoryName,
    required this.recordId,
    required this.dateTime,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) {
    String accessoryName = json["accessoryName"] as String;
    String recordId = json["recordId"] as String;
    DateTime dateTime = json["dateTime "] as DateTime;

    return Accessory(
        accessoryName: accessoryName, recordId: recordId, dateTime: dateTime);
  }
}
