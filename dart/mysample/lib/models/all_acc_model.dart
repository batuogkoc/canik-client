class Acces {
  final String imageUrl;

  final String productName;
  final String hastag;
  Acces(
      {required this.imageUrl,
      required this.productName,
      required this.hastag});
}

final accessoryList = [
  Acces(
      imageUrl: 'assets/images/equipment_1.png',
      productName: 'SARJÖR HUNİLERİ(MAG-WELL) VE ARKA KABZALAR',
      hastag: '#234'),
  Acces(
      imageUrl: 'assets/images/equipment_2.png',
      productName: 'YÜKSELTME VE GÖREV PAKETLERİ',
      hastag: '#2345'),
  Acces(
    imageUrl: 'assets/images/equipment_1.png',
    productName: 'ELEKTRONİK ATIŞ ATIM ÖLÇERLER',
    hastag: '#234132',
  ),
  Acces(
    imageUrl: 'assets/images/equipment_2.png',
    productName: 'KEMERLER',
    hastag: '#234132',
  ),
  Acces(
    imageUrl: 'assets/images/equipment_1.png',
    productName: 'EĞİTİM VE SİMÜLASYON KİTLERİ',
    hastag: '#234132',
  ),
];
