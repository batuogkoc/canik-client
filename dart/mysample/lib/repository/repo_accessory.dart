import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/accessory.dart';
import 'package:mysample/entities/response/accessory_response.dart';
import 'endpoints.dart';

class RepositoryAccessory {
  Future<bool> addAccessory(
      AccessoryAddRequestModel accessoryAddRequest) async {
    String uri = EndPoints.domain + EndPoints.addAccessory;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'accessoryName': accessoryAddRequest.accessoryName,
      'serialNumber': accessoryAddRequest.serialNumber,
      'canikId': accessoryAddRequest.canikId,
      'isDeleted': accessoryAddRequest.isDeleted.toString(),
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception('Failed to add accessory');
    }
  }

  Future<bool> deleteAccessory(
      AccessoryDeleteRequestModel accessoryDeleteRequest) async {
    String uri = EndPoints.domain + EndPoints.deleteAccessory;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'serialNumber': accessoryDeleteRequest.serialNumber,
      'recordID': accessoryDeleteRequest.recordID,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception('Failed to delete accessory');
    }
  }

  Future<List<Accessory>> listAccessory(
      AccessoryListRequestModel accessoryListRequest) async {
    String uri = EndPoints.domain + EndPoints.listAccessory;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'serialNumber': accessoryListRequest.serialNumber,
      'canikId': accessoryListRequest.canikId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return AccessoryListResponse.fromJson(json.decode(response.body))
          .accessories;
    } else {
      throw Exception('Failed to list accessories');
    }
  }
}
