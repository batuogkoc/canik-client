import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/response/weapon_to_user_response.dart';
import 'package:mysample/entities/weapon.dart';

import 'endpoints.dart';

class RepositoryWeapon {
  Future<WeaponToUserAddResponse> addWeaponToUser(
      WeaponToUserAddRequestModel request) async {
    String uri = EndPoints.domain + EndPoints.addWeaponToUser;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'canikId': request.canikId,
      'serialNumber': request.serialNumber,
      'name': request.name,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponToUserAddResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add weapon to user');
    }
  }

  Future<WeaponToUserListResponse> listWeaponToUser(
      WeaponToUserListRequestModel request) async {
    String uri = EndPoints.domain + EndPoints.listWeaponToUser;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{'canikId': request.canikId});

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponToUserListResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get weapon to user list');
    }
  }

  Future<WeaponToUserUpdateResponse> updateWeaponToUser(
      WeaponToUserUpdateRequestModel request) async {
    String uri = EndPoints.domain + EndPoints.updateWeaponToUser;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'serialNumber': request.serialNumber,
      'name': request.name,
      'recordID': request.recordID,
      'isDeleted': request.isDeleted
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponToUserUpdateResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update weapon');
    }
  }

  Future<WeaponToUserGetResponse> getWeaponToUserByRecordId(
      WeaponToUserGetRequestModel request) async {
    String uri = EndPoints.domain + EndPoints.getWeaponToUser;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'recordId': request.recordId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponToUserGetResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get weapon to user by record id!');
    }
  }

  Future<WeaponNameGetResponse> getWeaponName(
      WeaponNameGetRequestModel request) async {
    String uri = EndPoints.domain + EndPoints.getWeaponName;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'serialNumber': request.serialNumber,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponNameGetResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get weapon name!');
    }
  }
}
