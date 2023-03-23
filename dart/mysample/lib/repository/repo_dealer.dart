import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/response/dealer_response.dart';
import 'package:mysample/repository/endpoints.dart';

class RepositoryDealer {
  Future<DealerResponse> getDealerList() async {
    String uri = EndPoints.domain + EndPoints.dealerList;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.post(
      url,
      headers: requestHeader,
    );

    if (response.statusCode == 200) {
      return DealerResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed get to dealer list!!');
    }
  }
}
