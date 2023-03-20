import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/response/shot_timer_response.dart';
import 'package:mysample/entities/shot_timer.dart';
import 'endpoints.dart';

class RepositoryShotTimer {
  Future<ShotTimerAddResponse> addShotTimer(
      ShotTimerAddRequestModel shotTimerRecordAddRequest) async {
    String uri = EndPoints.domain + EndPoints.addShotTimer;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var requestBody = jsonEncode(shotTimerRecordAddRequest.toJson());

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotTimerAddResponse.fromJson(
              json.decode(utf8.decode(response.bodyBytes)));
          
    } else {
      throw Exception('Failed to add shottimer');
    }
  }

  Future<List<ShotTimerListResponseModel>> listShotTimersByDeviceId(
      String deviceId) async {
    String uri = EndPoints.domain + EndPoints.listShotTimer;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'deviceId': deviceId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotTimerListResponse.fromJson(
              json.decode(utf8.decode(response.bodyBytes)))
          .shotTimers;
    } else {
      throw Exception('Failed to list shottimers');
    }
  }

  Future<ShotTimerRecordListResponse> listShotTimerRecordsByRecordId(
      String recordId) async {
    String uri = EndPoints.domain + EndPoints.shotTimerRecordList;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'recordId': recordId,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotTimerRecordListResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list shot timer records');
    }
  }

  Future<ShotTimerUpdateResponse> updateShotTimer(
      ShotTimerUpdateRequestModel shotTimerRecordUpdateRequest) async {
    String uri = EndPoints.domain + EndPoints.updateShotTimer;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var requestBody = jsonEncode(shotTimerRecordUpdateRequest.toJson());

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotTimerUpdateResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update shottimer');
    }
  }

  Future<ShotTimerDeleteResponse> deleteShotTimer(
      ShotTimerDeleteRequestModel shotTimerRecordDeleteRequest) async {
    String uri = EndPoints.domain + EndPoints.deleteShotTimer;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var requestBody = jsonEncode(shotTimerRecordDeleteRequest.toJson());

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ShotTimerDeleteResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to delete shottimer');
    }
  }
}
