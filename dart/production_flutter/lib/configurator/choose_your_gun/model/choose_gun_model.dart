class ChooseGunModelOne {
  final String imageUrlPath;
  final String gunName;

  ChooseGunModelOne(this.imageUrlPath, this.gunName);

  @override
  String toString() => 'ChooseGunModelOne(imageUrlPath: $imageUrlPath, gunName: $gunName)';
}

final chooseGunListOne = [
  ChooseGunModelOne('assets/images/gun_details_1.png', 'TP SERIES'),
  ChooseGunModelOne('assets/images/mete_gun.png', 'METE SERIES'),
  ChooseGunModelOne('assets/images/canik_store_1.png', 'TRANING LINE'),
];

final clickedGunModel = [
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Sub Elite'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Rival'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Sub'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Elite'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Elite Cas'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Elite-S Combat'),
  ChooseGunModelOne('assets/images/canik_store_2.png', 'TP9 Elite Combat'),
];
