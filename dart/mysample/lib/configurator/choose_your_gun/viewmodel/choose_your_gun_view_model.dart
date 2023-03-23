import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/choose_gun_model.dart';

class ChooseYourGunViewModel {
  Color changeColor(Color color) {
    return color;
  }

  Future<bool?> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin');
  }

  int findToCurrentIndex(String elementOfList) {
    for (var chooseYourGun in chooseGunListOne) {
      if (chooseYourGun.gunName == elementOfList) {
        return chooseGunListOne.indexOf(chooseYourGun);
      }
    }
    return 0;
  }

  int findToCurrentIndexClickedGrid(String elementOfList) {
    for (var clickedGun in clickedGunModel) {
      if (clickedGun.gunName == elementOfList) {
        return clickedGunModel.indexOf(clickedGun);
      }
    }
    return 0;
  }
}
