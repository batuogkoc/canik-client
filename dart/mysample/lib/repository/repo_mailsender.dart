import 'dart:convert';

import 'package:http/http.dart' as http;
import '../entities/mailsender.dart';
import '../entities/response/mail_response.dart';
import 'endpoints.dart';

class RepositoryMail {
  Future<MailResponse> sendMail(MailSenderRequestModel mailSenderRequestModel) async {
    String uri = EndPoints.domain + EndPoints.mailSender;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var requestBody = jsonEncode(<String, String>{
      "toEmail": mailSenderRequestModel.toEmail,
      "userName": mailSenderRequestModel.userName
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return MailResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to send eMail');
    }
  }
  }