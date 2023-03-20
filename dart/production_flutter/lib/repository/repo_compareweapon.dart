

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../entities/response/compare_weapon_response.dart';
import 'endpoints.dart';

class CompareWeaponRepository{

  Future<CompareAllWeapons> getCompareWeapons() async{
    String uri = EndPoints.domain + EndPoints.getAllWeapons;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      url,
      headers: requestHeader,
    );

    if (response.statusCode == 200) {
      return CompareAllWeapons.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to add weapon to user');
    }
  }
}