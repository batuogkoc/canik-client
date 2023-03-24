import 'package:mysample/entities/frequently_asked_question.dart';

class FrequentlyAskedResponse {
  List<FrequentlyAskedQuestion> frequentlyAskedQuestions;
  String message;
  bool isError;

  FrequentlyAskedResponse({
    required this.frequentlyAskedQuestions,
    required this.message,
    required this.isError,
  });

  factory FrequentlyAskedResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<FrequentlyAskedQuestion> frequentlyAskedQuestions = json["result"]
        .map<FrequentlyAskedQuestion>((jsonDataObject) =>
            FrequentlyAskedQuestion.fromJson(jsonDataObject))
        .toList();

    return FrequentlyAskedResponse(
      frequentlyAskedQuestions: frequentlyAskedQuestions,
      message: message,
      isError: isError,
    );
  }
}
