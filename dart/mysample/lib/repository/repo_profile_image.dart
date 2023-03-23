import 'dart:convert';

import 'package:mysample/entities/only_canik_id.dart';
import 'package:mysample/entities/profile_image.dart';
import 'package:mysample/entities/response/profile_image_response.dart';

import 'endpoints.dart';
import 'package:http/http.dart' as http;

class RepositoryProfileImage {
  Future<ProfileImageGetResponse> GetProfileImage(OnlyCanikId model) async {
    String uri = EndPoints.domain + EndPoints.getProfileImage;
    var url = Uri.parse(uri);
    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };

    var requestBody = jsonEncode(<String, String>{
      'canikId': model.canikId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ProfileImageGetResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      return ProfileImageGetResponse(
          imageModel: ProfileImageGetResponseModel(canikId: '', image: '', id: '', isDeleted: false),
          message: '',
          isError: true);
    }
  }

  Future<ProfileImageAddResponse> AddResponseImage(ProfileImageGetModel model) async {
    String uri = EndPoints.domain + EndPoints.addProfileImage;
    var url = Uri.parse(uri);
    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var requestBody = jsonEncode(<String, String>{'canikId': model.canikId, 'image': model.image});

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ProfileImageAddResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add profile image');
    }
  }

  Future<ProfileImageDeleteResponse> deleteProfileImage(ProfileImageDeleteModel deleteModel) async {
    String uri = EndPoints.domain + EndPoints.deleteProfileImage;
    var url = Uri.parse(uri);
    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
    var requestBody = jsonEncode(<String, String>{'id': deleteModel.id});

    final response = await http.post(url, headers: requestHeader, body: requestBody);

    if (response.statusCode == 200) {
      return ProfileImageDeleteResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to deleted profile image');
    }
  }
}
