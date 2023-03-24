import 'dart:convert';

import 'package:mysample/entities/user_info.dart';
import 'package:mysample/repository/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RepositoryUserSso {
  Future<UserInfoResponseModel> getUserInfoByBearerToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('idToken');
    String uri = EndPoints.userInfo;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: requestHeader,
    );
    if (response.statusCode == 200) {
      return UserInfoResponseModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add shottimer');
    }
  }
}
