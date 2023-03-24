class Campaign {
  String title;
  String explanation;
  String? startDate;
  String? endDate;
  int status;
  String language;
  String? videoUrl;
  String? url;
  String? pdfUrl;
  String? youtubeUrl;
  String? imageUrl;

  Campaign({
    required this.title,
    required this.explanation,
    this.startDate,
    this.endDate,
    required this.status,
    required this.language,
    this.videoUrl,
    this.url,
    this.pdfUrl,
    this.youtubeUrl,
    this.imageUrl,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    String title = json["title"] != null ? json["title"] as String : "";
    String explanation = json["explanation"] != null ? json["explanation"] as String : "";
    String? startDate = json["startDate"] != null ? json["startDate"] as String? : null;
    String? endDate = json["endDate"] != null ? json["endDate"] as String? : null;
    int status = json["status"] as int;
    String language = json["language"] != null ? json["language"] as String : "tr";
    String? videoUrl = json["videoUrl"] != null ? json["videoUrl"] as String? : null;
    String? url = json["url"] != null ? json["url"] as String? : null;
    String? pdfUrl = json["pdfUrl"] != null ? json["pdfUrl"] as String? : null;
    String? youtubeUrl = json["youtubeUrl"] != null ? json["youtubeUrl"] as String? : null;
    String? imageUrl = json["imageUrl"] != null ? json["imageUrl"] as String? : null;

    return Campaign(
        title: title,
        explanation: explanation,
        startDate: startDate,
        endDate: endDate,
        status: status,
        language: language,
        videoUrl: videoUrl,
        url: url,
        pdfUrl: pdfUrl,
        youtubeUrl: youtubeUrl,
        imageUrl: imageUrl);
  }
}
