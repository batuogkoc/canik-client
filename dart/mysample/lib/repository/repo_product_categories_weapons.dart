import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/repository/endpoints.dart';

import '../entities/response/product_categories_weapons_response.dart';

class RepositoryProductCategoriesByWeapons{
    Future<ProductCategoriesByWeaponsResponse> getProductCategoriesByWeapons(String language) async {
    String uri = EndPoints.domain + EndPoints.getProductCategoriesByWeapons;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{'language': language});
    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ProductCategoriesByWeaponsResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed get news');
    }
  }
}