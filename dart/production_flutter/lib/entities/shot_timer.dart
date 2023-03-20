class ShotTimerAddRequestModel {
  String shotName;
  String weapon;
  String deviceId;
  double totalTime;
  double sensibility;
  List<Result> result;

  ShotTimerAddRequestModel({
    required this.shotName,
    required this.weapon,
    required this.deviceId,
    required this.totalTime,
    required this.sensibility,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      "shotName": shotName,
      "weapon": weapon,
      "deviceId": deviceId,
      "totalTime": totalTime,
      "sensibility": sensibility,
      "result": result.map((e) => e.toJson()).toList(),
    };
  }
}

class Result {
  String shotCounter;
  double duration;
  double passingTime;

  Result({
    required this.shotCounter,
    required this.duration,
    required this.passingTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "shotCounter": shotCounter,
      "duration": duration,
      "passingTime": passingTime,
    };
  }
}

class ShotTimerListResponseModel {
  String shotName;
  String weapon;
  double totalTime;
  double sensibility;
  String recordId;
  String deviceId;
  String? totalShot = '';
  bool isDeleted;
  String? date = '';

  ShotTimerListResponseModel({
    required this.shotName,
    required this.weapon,
    required this.totalTime,
    required this.sensibility,
    required this.recordId,
    required this.deviceId,
    this.totalShot,
    required this.isDeleted,
    this.date,
  });

  factory ShotTimerListResponseModel.fromJson(Map<String, dynamic> json) {
    String shotName = json["shotName"] as String;
    String weapon = json["weapon"] as String;
    double totalTime = json["totalTime"] as double;
    double sensibility = json["sensibility"] as double;
    String recordId = json["recordId"] as String;
    String deviceId = json["deviceId"] as String;
    String? totalShot = json["totalShot"] as String?;
    String? date = json["date"] as String?;
    bool isDeleted = json["İsDeleted"] as bool;

    return ShotTimerListResponseModel(
        shotName: shotName,
        weapon: weapon,
        totalTime: totalTime,
        sensibility: sensibility,
        recordId: recordId,
        deviceId: deviceId,
        isDeleted: isDeleted,
        date: date,
        totalShot: totalShot);
  }
}

class ShotTimerRecordListResponseModel {
  String recordId;
  String shotCounter;
  double duration;
  double passingTime;

  ShotTimerRecordListResponseModel({
    required this.recordId,
    required this.shotCounter,
    required this.duration,
    required this.passingTime,
  });

  factory ShotTimerRecordListResponseModel.fromJson(Map<String, dynamic> json) {
    String recordId = json["recordId"] as String;
    String shotCounter = json["shotCounter"] as String;
    double duration = json["duration"] as double;
    double passingTime = json["passingTime"] as double;

    return ShotTimerRecordListResponseModel(
        recordId: recordId,
        shotCounter: shotCounter,
        duration: duration,
        passingTime: passingTime);
  }
}

class ShotTimerUpdateRequestModel {
  String shotName;
  String weapon;
  String recordId;

  ShotTimerUpdateRequestModel({
    required this.shotName,
    required this.weapon,
    required this.recordId,
  });

  Map<String, dynamic> toJson() {
    return {
      "shotName": shotName,
      "weapon": weapon,
      "recordId": recordId,
    };
  }
}

class ShotTimerDeleteRequestModel {
  String recordId;

  ShotTimerDeleteRequestModel({
    required this.recordId,
  });

  Map<String, dynamic> toJson() {
    return {
      "recordId": recordId,
    };
  }
}
