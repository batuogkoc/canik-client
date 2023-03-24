import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/only_canik_id.dart';
import 'package:mysample/entities/profile_image.dart';
import 'package:mysample/entities/response/profile_image_response.dart';
import 'package:mysample/repository/repo_profile_image.dart';

class ProfileImageCubit extends Cubit<ProfileImageGetResponse> {
  ProfileImageCubit()
      : super(ProfileImageGetResponse(
            imageModel: ProfileImageGetResponseModel(canikId: "", image: "", id: '', isDeleted: false),
            isError: false,
            message: ""));

  var repository = RepositoryProfileImage();

  Future<ProfileImageGetResponse> getProfileImage(OnlyCanikId request) async {
    ProfileImageGetResponse response = await repository.GetProfileImage(request);

    emit(response);
    return response;
  }

  Future<ProfileImageAddResponse> addProfileImage(ProfileImageGetModel request) async {
    ProfileImageAddResponse response = await repository.AddResponseImage(request);

    return response;
  }

  Future<ProfileImageDeleteResponse> deleteProfileImage(ProfileImageDeleteModel deleteModel) async {
    ProfileImageDeleteResponse response = await repository.deleteProfileImage(deleteModel);
    return response;
  }
}
