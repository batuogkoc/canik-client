class New {
  String title;
  String explanation;
  String date;
  String? videoUrl;
  String? url;
  String? pdfUrl;
  String? youtubeUrl;
  String? imageUrl;
  New({
    required this.title,
    required this.explanation,
    required this.date,
    this.videoUrl,
    this.url,
    this.pdfUrl,
    this.youtubeUrl,
    this.imageUrl,
  });

  factory New.fromJson(Map<String, dynamic> json) {
    String title = json["title"] != null ? json["title"] as String : "";
    String explanation = json["explanation"] != null ? json["explanation"] as String : "";
    String date = json["date"] != null ? json["date"] as String : "";
    String? videoUrl = json["videoUrl"] != null ? json["videoUrl"] as String? : null;
    String? url = json["url"] != null ? json["url"] as String? : null;
    String? pdfUrl = json["pdfUrl"] != null ? json["pdfUrl"] as String? : null;
    String? youtubeUrl = json["youtubeUrl"] != null ? json["youtubeUrl"] as String? : null;
    String? imageUrl = json["imageUrl"] != null ? json["imageUrl"] as String? : null;

    return New(
        title: title,
        explanation: explanation,
        date: date,
        videoUrl: videoUrl,
        url: url,
        pdfUrl: pdfUrl,
        youtubeUrl: youtubeUrl,
        imageUrl: imageUrl);
  }
}
