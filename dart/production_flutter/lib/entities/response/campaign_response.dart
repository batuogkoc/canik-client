import 'package:mysample/entities/campaign.dart';

class CampaignResponse {
  List<Campaign> campaigns;
  String message;
  bool isError;

  CampaignResponse({
    required this.campaigns,
    required this.message,
    required this.isError,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    String message = json["message"] as String;
    bool isError = json["isError"] as bool;

    List<Campaign> campaigns = json["result"]
        .map<Campaign>((jsonDataObject) => Campaign.fromJson(jsonDataObject))
        .toList();

    return CampaignResponse(
      campaigns: campaigns,
      message: message,
      isError: isError,
    );
  }
}
