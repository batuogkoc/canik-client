import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/response/dealer_response.dart';
import 'package:mysample/repository/repo_dealer.dart';

class DealerCubit extends Cubit<DealerResponse> {
  DealerCubit() : super(DealerResponse(dealerResponseList: [], message: '', isError: false));

  var repository = RepositoryDealer();

  Future<DealerResponse> getDealerList() async {
    DealerResponse dealerList = await repository.getDealerList();
    emit(dealerList);
    return dealerList;
  }
}
