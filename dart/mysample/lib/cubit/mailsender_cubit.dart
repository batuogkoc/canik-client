
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/mailsender.dart';
import '../entities/response/mail_response.dart';
import '../repository/repo_mailsender.dart';

class MailSenderCubit extends Cubit<MailResponse> {
  MailSenderCubit() : super(MailResponse(isError: false, message: '', result: false));

  var repository = RepositoryMail();

  Future<MailResponse> sendMailcubit(MailSenderRequestModel mailSenderRequestModel) async {
    MailResponse sendMailResponse = await repository.sendMail(mailSenderRequestModel);

    emit(sendMailResponse);
    return sendMailResponse;
  }
}