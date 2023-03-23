import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/campaign.dart';
import '../repository/repo_new.dart';

class CampaignCubit extends Cubit<List<Campaign>> {
  CampaignCubit() : super(<Campaign>[]);

  var repository = RepositoryNew();

  Future<void> getCampaigns(String language) async {
    List<Campaign> campaigns = await repository.getCampaigns(language);

    emit(campaigns);
  }
}
