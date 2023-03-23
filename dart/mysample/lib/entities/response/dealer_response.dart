import 'package:mysample/entities/dealer.dart';

class DealerResponse {
  List<DealerResponseModel> dealerResponseList;
  String message;
  bool isError;

  DealerResponse({
    required this.dealerResponseList,
    required this.message,
    required this.isError,
  });

  factory DealerResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<DealerResponseModel> dealerResponseList = json["result"]
        .map<DealerResponseModel>((jsonDataObject) => DealerResponseModel.fromJson(jsonDataObject))
        .toList();

    return DealerResponse(dealerResponseList: dealerResponseList, message: message, isError: isError);
  }
}
