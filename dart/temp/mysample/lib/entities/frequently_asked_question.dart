import 'package:flutter/cupertino.dart';

class FrequentlyAskedQuestion {
  String title;
  String explanation;
  int status;
  bool isExpanded = false;

  FrequentlyAskedQuestion({
    required this.title,
    required this.explanation,
    required this.status,
    required this.isExpanded,
  });

  factory FrequentlyAskedQuestion.fromJson(Map<String, dynamic> json) {
    String title = json["title"] as String;
    String explanation = json["explanation"] as String;
    int status = json["status"] as int;

    return FrequentlyAskedQuestion(
        title: title,
        explanation: explanation,
        status: status,
        isExpanded: false);
  }
}
