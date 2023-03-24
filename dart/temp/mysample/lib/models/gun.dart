import 'package:flutter/widgets.dart';

class CSearchGun {
  final int id;
  final String title;
  final String imgPath;

  const CSearchGun(
      {required this.id, required this.title, required this.imgPath});
}

final gunListt = [
  CSearchGun(
      id: 2, title: 'TP9 SF ELITE', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 3, title: 'TP9 ELITE COMBAT', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(id: 4, title: 'METE SFT', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(id: 5, title: 'METE SFT', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 6, title: 'METE SUB METE', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 7, title: 'MANEVRA TABANCASI', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 8, title: 'TALİM TABANCASI', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 9, title: 'KESİT TABANCA', imgPath: 'assets/images/mete_gun.png'),
  CSearchGun(
      id: 1, title: 'TP9 SUB ELITE', imgPath: 'assets/images/mete_gun.png'),
];
