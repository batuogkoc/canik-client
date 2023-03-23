import 'dart:convert';

import 'package:mysample/entities/response/weapon_care_response.dart';
import 'package:mysample/entities/weapon_care.dart';

import 'package:http/http.dart' as http;
import 'endpoints.dart';

class RepositoryWeaponCare {
  Future<WeaponCareAddResponse> addWeaponCare(
      WeaponCareAddRequestModel weaponCareAddRequestModel) async {
    String uri = EndPoints.domain + EndPoints.addWeaponCare;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'careType': weaponCareAddRequestModel.careType,
      'careDate': weaponCareAddRequestModel.careDate.toString(),
      'explanation': weaponCareAddRequestModel.explanation,
      'serialNumber': weaponCareAddRequestModel.serialNumber,
      'canikId': weaponCareAddRequestModel.canikId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponCareAddResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add weapon care');
    }
  }

  Future<WeaponCareListResponse> listWeaponCare(
      WeaponCareListRequestModel weaponCareListRequestModel) async {
    String uri = EndPoints.domain + EndPoints.listWeaponCare;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'serialNumber': weaponCareListRequestModel.serialNumber,
      'canikId': weaponCareListRequestModel.canikId
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return WeaponCareListResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list weapon care');
    }
  }

  Future<bool> updateWeaponCare(
      WeaponCareUpdateRequestModel weaponCareUpdateRequestModel) async {
    String uri = EndPoints.domain + EndPoints.updateWeaponCare;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'careType': weaponCareUpdateRequestModel.careType,
      'careDate': weaponCareUpdateRequestModel.careDate.toString(),
      'explanation': weaponCareUpdateRequestModel.explanation,
      'recordID': weaponCareUpdateRequestModel.recordID,
      'isDeleted': weaponCareUpdateRequestModel.isDeleted
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update weapon care');
    }
  }
}
