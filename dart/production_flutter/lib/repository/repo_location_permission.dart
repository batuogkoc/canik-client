import 'dart:convert';

import 'package:mysample/repository/endpoints.dart';

import '../entities/location_permission.dart';
import '../entities/response/location_permission_response.dart';

import 'package:http/http.dart' as http;

class RepositoryPermission {
  Future<LocationPermissionAddResponse> addLocation(
      AddLocationPermissionRequestModel addLocationPermissionRequestModel) async {
    String uri = EndPoints.domain + EndPoints.addLocationPermission;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      "deviceId": addLocationPermissionRequestModel.deviceId,
      "recordId": addLocationPermissionRequestModel.recordId,
      "status": addLocationPermissionRequestModel.status,
      "isUpdated": addLocationPermissionRequestModel.isUpdated
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return LocationPermissionAddResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add location');
    }
  }

  Future<GetLocationPermissionResponse> getLocationPermission(
      GetLocationPermissionRequestModel getLocationPermissionRequestModel) async {
    String uri = EndPoints.domain + EndPoints.getLocationPermission;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      "deviceId": getLocationPermissionRequestModel.deviceId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return GetLocationPermissionResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list location');
    }
  }
}
