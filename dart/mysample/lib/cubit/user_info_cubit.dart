import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/user_info.dart';
import 'package:mysample/repository/repo_user_sso.dart';

class UserInfoCubit extends Cubit<UserInfoResponseModel> {
  UserInfoCubit()
      : super(UserInfoResponseModel(
            canikId: '', displayName: '', email: '', name: '', surname: ''));

  var repositoryUser = RepositoryUserSso();

  Future<void> getUserInfoByBearerToken() async {
    UserInfoResponseModel result =
        await repositoryUser.getUserInfoByBearerToken();

    emit(result);
  }
}
