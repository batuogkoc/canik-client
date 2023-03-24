class UserInfoResponseModel {
  String canikId;
  String? name;
  String? surname;
  String displayName;
  String email;

  UserInfoResponseModel({
    required this.canikId,
    this.name,
    this.surname,
    required this.displayName,
    required this.email,
  });

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    String canikId = json["objectId"] as String;
    String? name = json["givenName"] as String?;
    String? surname = json["surname"] as String?;
    String displayName = json["displayName"] as String;
    String email = json["signInNames.emailAddress"] as String;

//TODO: sonrasında burası degisecektir.
    if (name == null || surname == null) {
      name = '';
      surname = '';
    }

    return UserInfoResponseModel(
      canikId: canikId,
      name: name,
      surname: surname,
      displayName: displayName,
      email: email,
    );
  }
}
