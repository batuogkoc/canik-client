class WeaponToUserAddRequestModel {
  String canikId;
  String serialNumber;
  String name;

  WeaponToUserAddRequestModel({
    required this.canikId,
    required this.serialNumber,
    required this.name,
  });
}

class WeaponToUserAddResponseModel {
  String recordId;

  WeaponToUserAddResponseModel({
    required this.recordId,
  });

  factory WeaponToUserAddResponseModel.fromJson(Map<String, dynamic> json) {
    String recordId = json["recordId"] as String;

    return WeaponToUserAddResponseModel(recordId: recordId);
  }
}

class WeaponToUserListRequestModel {
  String canikId;

  WeaponToUserListRequestModel({
    required this.canikId,
  });
}

class WeaponToUserUpdateRequestModel {
  String serialNumber;
  String name;

  String recordID;
  bool isDeleted;

  WeaponToUserUpdateRequestModel({
    required this.serialNumber,
    required this.name,
    required this.recordID,
    required this.isDeleted,
  });
}

class WeaponToUserListResponseModel {
  String serialNumber;
  String name;
  String? imageUrl;
  String recordId;
  String date;
  WeaponToUserListResponseModel(
      {required this.serialNumber, required this.name, required this.recordId, this.imageUrl, required this.date});

  factory WeaponToUserListResponseModel.fromJson(Map<String, dynamic> json) {
    String serialNumber = json["serialNumber"] as String;
    String name = json["name"] as String;
    String imageUrl = json["imageUrl"] as String;
    String recordId = json["recordId"] as String;
    String date = json["date"] as String;
    return WeaponToUserListResponseModel(
        serialNumber: serialNumber, name: name, recordId: recordId, imageUrl: imageUrl,date: date);
  }
}

class WeaponNameGetRequestModel {
  String serialNumber;

  WeaponNameGetRequestModel({
    required this.serialNumber,
  });
}

class WeaponNameGetResponseModel {
  String name;
  String model;

  WeaponNameGetResponseModel({
    required this.name,
    required this.model,
  });

  factory WeaponNameGetResponseModel.fromJson(Map<String, dynamic> json) {
    String name = json["name"] as String;
    String model = json["model"] as String;

    return WeaponNameGetResponseModel(
      name: name,
      model: model,
    );
  }
}

class WeaponToUserGetRequestModel {
  String recordId;

  WeaponToUserGetRequestModel({
    required this.recordId,
  });
}

class WeaponToUserGetResponseModel {
  String serialNumber;
  String name;
  String imageUrl;
  String recordId;
  bool isDeleted;
  String date;
  WeaponToUserGetResponseModel({
    required this.serialNumber,
    required this.name,
    required this.recordId,
    required this.isDeleted,
    required this.imageUrl,
    required this.date
  });

  factory WeaponToUserGetResponseModel.fromJson(Map<String, dynamic> json) {
    String serialNumber = json["serialNumber"] as String;
    String name = json["name"] as String;
    String imageUrl = json["imageUrl"] as String;
    String recordId = json["recordId"] as String;
    bool isDeleted = json["isDeleted"] as bool;
    String date = json["date"] as String;

    return WeaponToUserGetResponseModel(
        serialNumber: serialNumber, name: name, recordId: recordId, isDeleted: isDeleted,imageUrl: imageUrl,date: date);
  }
}
