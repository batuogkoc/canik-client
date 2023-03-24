import 'package:flutter_test/flutter_test.dart';
import 'package:mysample/entities/only_canik_id.dart';
import 'package:mysample/entities/profile_image.dart';
import 'package:mysample/repository/repo_profile_image.dart';

void main() {
  late ProfileImageDeleteModel deleteModel;
  late final OnlyCanikId canikIdModel;
  setUp(
    () {
      // 3ad635ec-8495-4fcf-938a-8c15200d899f
      deleteModel = ProfileImageDeleteModel(id: '3ad635ec-8495-4fcf-938a-8c15200d899f');
      canikIdModel = OnlyCanikId(canikId: '3ad635ec-8495-4fcf-938a-8c15200d899f');
    },
  );
  test(
    'Delete profile image test',
    () async {
      var repository = RepositoryProfileImage();
      final response = await repository.deleteProfileImage(deleteModel);

      expect(response.result, 'true');
    },
  );
  test('List profile image', () async {
    var repository = RepositoryProfileImage();
    final response = await repository.GetProfileImage(canikIdModel);
    expect(response.imageModel.image.isNotEmpty, true);
  });
}
