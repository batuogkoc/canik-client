import 'dart:convert';

import 'package:mysample/repository/endpoints.dart';

import '../entities/iys.dart';
import '../entities/response/iys_response.dart';
import 'package:http/http.dart' as http;

class RepositoryIys {
  Future<IysAddResponse> addIys(IysAddRequestModel iysAddRequestModel) async {
    String uri = EndPoints.domain + EndPoints.addIys;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      "ipAddress": iysAddRequestModel.ipAddress,
      "canikID": iysAddRequestModel.canikId,
      "type": iysAddRequestModel.type,
      "recipient": iysAddRequestModel.recipient,
      "status": iysAddRequestModel.status
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return IysAddResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add iys');
    }
  }

  Future<IysPermissionResponse> permissionQuestioing(IysPermissionRequestModel iysPermissionRequestModel) async {
    String uri = EndPoints.domain + EndPoints.permissionQuestionin;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(
        <String, String>{"eMail": iysPermissionRequestModel.eMail, "mobile": iysPermissionRequestModel.mobile ?? ''});

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return IysPermissionResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to list iys');
    }
  }
}
