import 'package:mysample/entities/accessory.dart';

class AccessoryListResponse {
  List<Accessory> accessories;

  AccessoryListResponse({
    required this.accessories,
  });

  factory AccessoryListResponse.fromJson(List<dynamic> json) {
    List<Accessory> accessories = json
        .map((jsonDataObject) => Accessory.fromJson(jsonDataObject))
        .toList();

    return AccessoryListResponse(accessories: accessories);
  }
}
