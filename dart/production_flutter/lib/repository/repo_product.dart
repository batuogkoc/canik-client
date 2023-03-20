import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysample/entities/main_category.dart';
import 'package:mysample/entities/product_category.dart';
import 'package:mysample/entities/product_category_assignment.dart';
import 'package:mysample/entities/response/main_category_response.dart';
import 'package:mysample/entities/response/product_category_assignment.dart';
import 'package:mysample/repository/endpoints.dart';

import '../entities/response/product_category_response.dart';

class RepositoryProduct {
  Future<List<MainCategory>> getAllMainCategories() async {
    String uri = EndPoints.domain + EndPoints.getMainCategories;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
    var requestBody = jsonEncode(<String, String>{
      'categoryName': 'CANİK STORE',
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return MainCategoryResponse.fromJson(
              json.decode(utf8.decode(response.bodyBytes)))
          .mainCategories;
    } else {
      throw Exception('Failed to get main categories');
    }
  }

  Future<List<ProductCategory>> getProductCategories(
      String categoryName) async {
    String uri = EndPoints.domain + EndPoints.getProductCategories;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
    var requestBody = jsonEncode(<String, String>{
      'categoryName': categoryName,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var y = utf8.decode(response.bodyBytes);
      var x = json.decode(utf8.decode(response.bodyBytes));
      return ProductCategoryResponse.fromJson(
              json.decode(utf8.decode(response.bodyBytes)))
          .productCategories;
    } else {
      throw Exception('Failed to get main categories');
    }
  }

  Future<List<ProductCategoryAssignment>> getAllProductCategoryAssignments(
      String productCategoryCode) async {
    String uri = EndPoints.domain + EndPoints.getProductCategoryAssigments;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };
    var requestBody = jsonEncode(<String, String>{
      'productCategoryCode': productCategoryCode,
    });

    final response = await http.post(
      url,
      headers: requestHeader,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return ProductCategoryAssignmentResponse.fromJson(
              json.decode(utf8.decode(response.bodyBytes)))
          .productCategoryAssignments;
    } else {
      throw Exception('Failed to get category assignments');
    }
  }

  Future<GetAllProductsResponse> getAllProducts() async {
    String uri = EndPoints.domain + EndPoints.getAllProducts;
    var url = Uri.parse(uri);

    var requestHeader = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    };

    final response = await http.post(
      url,
      headers: requestHeader,
    );

    if (response.statusCode == 200) {
      return GetAllProductsResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get all products');
    }
  }
}
