class ProfileImageGetModel {
  String canikId;
  String image;
  ProfileImageGetModel({required this.canikId, required this.image});

  factory ProfileImageGetModel.fromJson(Map<String, dynamic> json) {
    String canikId = json["canikId"] as String;
    String image = json["image"] as String;

    return ProfileImageGetModel(canikId: canikId, image: image);
  }
}

class ProfileImageGetResponseModel {
  String id;
  String canikId;
  String image;
  bool isDeleted;

  ProfileImageGetResponseModel({
    required this.id,
    required this.canikId,
    required this.image,
    required this.isDeleted,
  });

  factory ProfileImageGetResponseModel.fromJson(Map<String, dynamic> json) {
    String id = json["id"] as String;
    String canikId = json["canikId"] as String;
    String image = json["image"] as String;
    bool isDeleted = json['isDeleted'] as bool;
    return ProfileImageGetResponseModel(id: id, canikId: canikId, image: image, isDeleted: isDeleted);
  }
}

class ProfileImageDeleteModel {
  String id;

  ProfileImageDeleteModel({
    required this.id,
  });
}
