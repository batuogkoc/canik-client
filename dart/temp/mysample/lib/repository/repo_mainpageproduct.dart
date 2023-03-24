import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/response/mainproduct_response.dart';
import 'endpoints.dart';

class RepositoryMainPageProduct {
  Future<MainPageProductResponse> getMainPageProducts() async {
    String uri = EndPoints.domain + EndPoints.getMainPageProduct;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    
    final response = await http.post(
      url,
      headers: requestHeader,
    );

    if (response.statusCode == 200) {
      return MainPageProductResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed get mainPageProducts');
    }
  }
  
}