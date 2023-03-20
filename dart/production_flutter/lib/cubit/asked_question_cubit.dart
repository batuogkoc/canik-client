import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/frequently_asked_question.dart';
import 'package:mysample/repository/repo_new.dart';

class AskedQuestionCubit extends Cubit<List<FrequentlyAskedQuestion>> {
  AskedQuestionCubit() : super(<FrequentlyAskedQuestion>[]);

  var repository = RepositoryNew();

  Future<void> getAllFrequentlyAskedQuestions(String language) async {
    List<FrequentlyAskedQuestion> frequentlyAskedQuestions =
        await repository.frequentlyAskedQuestions(language);

    emit(frequentlyAskedQuestions);
  }
}
