class DealerResponseModel {
  String latitude;
  String longitude;
  String dealerName;
  String location;
  String openingTime;
  String closedTime;
  bool active;

  DealerResponseModel({
    required this.latitude,
    required this.longitude,
    required this.dealerName,
    required this.location,
    required this.openingTime,
    required this.closedTime,
    required this.active,
  });

  factory DealerResponseModel.fromJson(Map<String, dynamic> json) {
    String latitude = json["latitude"] as String;
    String longitude = json["longitude"] as String;
    String dealerName = json["dealerName"] as String;
    String location = json["location"] as String;
    String openingTime = json["openingTime"] as String;
    String closedTime = json["closedTime"] as String;

    bool active = json['active'] as bool;
    return DealerResponseModel(
        latitude: latitude,
        longitude: longitude,
        dealerName: dealerName,
        location: location,
        openingTime: openingTime,
        closedTime: closedTime,
        active: active);
  }
}
