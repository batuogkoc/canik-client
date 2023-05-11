class MailResponse {
  bool result;
  String message;
  bool isError;

  MailResponse({
    required this.result,
    required this.message,
    required this.isError,
  });
  factory MailResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;
    bool result = json["result"] as bool;

    return MailResponse(result: result, message: message, isError: isError);
  }
}