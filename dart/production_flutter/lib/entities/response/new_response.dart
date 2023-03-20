import '../new.dart';

class NewResponse {
  List<New> news;
  String message;
  bool isError;

  NewResponse({
    required this.message,
    required this.isError,
    required this.news,
  });

  factory NewResponse.fromJson(Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;
    List<New> news = json["result"]
        .map<New>((jsonDataObject) => New.fromJson(jsonDataObject))
        .toList();

    return NewResponse(isError: isError, message: message, news: news);
  }
}
