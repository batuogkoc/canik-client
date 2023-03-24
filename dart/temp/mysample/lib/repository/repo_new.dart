import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/campaign.dart';
import 'package:mysample/entities/frequently_asked_question.dart';
import 'package:mysample/entities/new.dart';
import 'package:mysample/entities/response/campaign_response.dart';
import 'package:mysample/entities/response/frequently_asked_question_response.dart';
import 'package:mysample/entities/response/new_response.dart';
import 'package:mysample/repository/endpoints.dart';

class RepositoryNew {
  Future<List<New>> getNews(String language) async {
    String uri = EndPoints.domain + EndPoints.getNews;
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
      return NewResponse.fromJson(json.decode(utf8.decode(response.bodyBytes))).news;
    } else {
      throw Exception('Failed get news');
    }
  }

  Future<List<FrequentlyAskedQuestion>> frequentlyAskedQuestions(String language) async {
    String uri = EndPoints.domain + EndPoints.getFraquentlyAskedQuestions;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'language': language.toUpperCase(),
    });
    final response = await http.post(url, headers: requestHeader, body: requestBody);

    if (response.statusCode == 200) {
      return FrequentlyAskedResponse.fromJson(json.decode(utf8.decode(response.bodyBytes))).frequentlyAskedQuestions;
    } else {
      throw Exception('Failed get frequently asked questions');
    }
  }

  Future<List<Campaign>> getCampaigns(String language) async {
    String uri = EndPoints.domain + EndPoints.getCampaigns;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      'language': language,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return CampaignResponse.fromJson(json.decode(utf8.decode(response.bodyBytes))).campaigns;
    } else {
      throw Exception('Failed get campaigns');
    }
  }
}
