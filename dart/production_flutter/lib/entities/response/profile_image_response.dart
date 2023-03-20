import '../profile_image.dart';

class ProfileImageGetResponse {
  ProfileImageGetResponseModel imageModel;
  bool isError;
  String message;

  ProfileImageGetResponse({required this.imageModel, required this.isError, required this.message});

  factory ProfileImageGetResponse.fromJson(Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;
    ProfileImageGetResponseModel imageModel = ProfileImageGetResponseModel.fromJson(json["result"]);
    return ProfileImageGetResponse(imageModel: imageModel, isError: isError, message: message);
  }
}

class ProfileImageAddResponse {
  bool result;
  bool isError;
  String message;

  ProfileImageAddResponse({required this.isError, required this.message, required this.result});

  factory ProfileImageAddResponse.fromJson(Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;
    bool result = json["result"] as bool;

    return ProfileImageAddResponse(isError: isError, message: message, result: result);
  }
}

class ProfileImageDeleteResponse {
  bool result;
  bool isError;
  String message;

  ProfileImageDeleteResponse({required this.isError, required this.message, required this.result});

  factory ProfileImageDeleteResponse.fromJson(Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;
    bool result = json["result"] as bool;

    return ProfileImageDeleteResponse(isError: isError, message: message, result: result);
  }
}
