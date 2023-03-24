import 'dart:convert';

import 'package:mysample/entities/response/shot_record_response.dart';
import 'package:mysample/entities/shot_record.dart';

import 'package:http/http.dart' as http;
import 'endpoints.dart';

class RepositoryShotRecord {
  Future<ShotRecordAddResponse> addShotRecord(ShotRecordAddRequestModel shotRecordAddRequest) async {
    String uri = EndPoints.domain + EndPoints.addShotRecord;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'serialNumber': shotRecordAddRequest.serialNumber,
      'canikId': shotRecordAddRequest.canikId,
      'polygon': shotRecordAddRequest.polygon,
      'explanation': shotRecordAddRequest.explanation,
      'numberShots': shotRecordAddRequest.numberShots,
      'date': shotRecordAddRequest.date.toString(),
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotRecordAddResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add shot record');
    }
  }

  Future<bool> updateShotRecord(ShotRecordUpdateRequestModel shotRecordUpdateRequest) async {
    String uri = EndPoints.domain + EndPoints.updateShotRecord;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, dynamic>{
      'polygon': shotRecordUpdateRequest.polygon,
      'explanation': shotRecordUpdateRequest.explanation,
      'numberShots': shotRecordUpdateRequest.numberShots,
      'date': shotRecordUpdateRequest.date.toString(),
      'isDeleted': shotRecordUpdateRequest.isDeleted,
      'recordID': shotRecordUpdateRequest.recordID
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update shot record');
    }
  }

  Future<ShotRecordListResponse> listShotRecords(ShotRecordListRequestModel shotRecordListRequestModel) async {
    String uri = EndPoints.domain + EndPoints.listShotRecord;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'canikId': shotRecordListRequestModel.canikId,
      'serialNumber': shotRecordListRequestModel.serialNumber
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotRecordListResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list shot records');
    }
  }

  Future<ShotRecordListWithCanikIdResponse> listShotRecordWithcanikId(
      ShotRecordListWithCanikIdRequestModel shotRecordListWithCanikIdRequestModel) async {
    String uri = EndPoints.domain + EndPoints.listShotRecordWithcanikId;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{'canikId': shotRecordListWithCanikIdRequestModel.canikId});

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotRecordListWithCanikIdResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list shot records');
    }
  }
}
