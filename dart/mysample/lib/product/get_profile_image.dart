import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/entities/only_canik_id.dart';

import '../cubit/profile_image_cubit.dart';
import '../entities/response/profile_image_response.dart';
import 'init/SharedPreferences/shared_prefs.dart';

class GetProfileImage {
  String? _canikId;
  Uint8List? _decodedString;
  Future<Uint8List?> getProfileImage(BuildContext context) async {
    await SharedPrefs().getCanikId().then((value) {
      _canikId = value != null ? value : null;
    });
    if (_canikId != null) {
      OnlyCanikId _profileImageGetModel = OnlyCanikId(canikId: _canikId ?? '');
      ProfileImageGetResponse result = await context.read<ProfileImageCubit>().getProfileImage(_profileImageGetModel);

      String string64 = result.imageModel.image;
      _decodedString = base64.decode(string64);
      return _decodedString;
    }
    return null;
  }
}
