import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/new.dart';
import 'package:mysample/repository/repo_new.dart';

class SpecialPageCubit extends Cubit<List<New>> {
  SpecialPageCubit() : super(<New>[]);

  var repository = RepositoryNew();

  Future<void> getNews(String language) async {
    List<New> news = await repository.getNews(language);

    emit(news);
  }
}
