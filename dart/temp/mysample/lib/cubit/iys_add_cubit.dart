import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/iys.dart';
import 'package:mysample/entities/response/iys_response.dart';
import 'package:mysample/repository/repo_iys.dart';

class IysAddCubit extends Cubit<IysAddResponse> {
  IysAddCubit() : super(IysAddResponse(isError: false, message: '', result: ''));

  var repository = RepositoryIys();

  Future<IysAddResponse> addIys(IysAddRequestModel iysAddRequestModel) async {
    IysAddResponse addedIysResponse = await repository.addIys(iysAddRequestModel);

    emit(addedIysResponse);
    return addedIysResponse;
  }
}
