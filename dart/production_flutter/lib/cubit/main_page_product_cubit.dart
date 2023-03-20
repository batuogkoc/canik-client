

import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/response/mainproduct_response.dart';
import '../repository/repo_mainpageproduct.dart';

class MainPageProductCubit extends Cubit<MainPageProductResponse>{
  MainPageProductCubit(): super(MainPageProductResponse(isError: false,message: "",mainPageProducts: []));

  var repository = RepositoryMainPageProduct();
  
  Future<MainPageProductResponse> getMainPageProducts() async{
    MainPageProductResponse result = await repository.getMainPageProducts();
    emit(result);
    return result;
  }
}