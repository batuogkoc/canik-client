class IysAddRequestModel {
  String ipAddress;
  String canikId;
  String type;
  String recipient;
  String status;

  IysAddRequestModel({
    required this.ipAddress,
    required this.canikId,
    required this.type,
    required this.recipient,
    required this.status,
  });
}

class IysPermissionRequestModel {
  String eMail;
  String? mobile;

  IysPermissionRequestModel({
    required this.eMail,
    this.mobile,
  });
}

class IysPermissionResponseModel {
  bool eMail;
  bool call;
  bool sms;

  IysPermissionResponseModel({
    required this.eMail,
    required this.call,
    required this.sms,
  });

  factory IysPermissionResponseModel.fromJson(Map<String, dynamic> json) {
    bool eMail = json['eMail'] as bool;
    bool call = json['call'] as bool;
    bool sms = json['sms'] as bool;
    return IysPermissionResponseModel(eMail: eMail, call: call, sms: sms);
  }
}
