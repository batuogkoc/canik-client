import 'package:mysample/entities/product_category_assignment.dart';

class ProductCategoryAssignmentResponse {
  List<ProductCategoryAssignment> productCategoryAssignments;
  bool isError;
  String message;

  ProductCategoryAssignmentResponse({
    required this.productCategoryAssignments,
    required this.isError,
    required this.message,
  });

  factory ProductCategoryAssignmentResponse.fromJson(
      Map<String, dynamic> json) {
    bool isError = json["isError"] as bool;
    String message = json["message"] as String;

    List<ProductCategoryAssignment> productCategoryAssignments = json["result"]
        .map<ProductCategoryAssignment>((jsonDataObject) =>
            ProductCategoryAssignment.fromJson(jsonDataObject))
        .toList();

    return ProductCategoryAssignmentResponse(
        productCategoryAssignments: productCategoryAssignments,
        isError: isError,
        message: message);
  }
}
