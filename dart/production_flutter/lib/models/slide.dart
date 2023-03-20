class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({required this.imageUrl, required this.title, required this.description});
}

final slideList = [
  Slide(
      imageUrl: 'assets/images/why_location.jpeg',
      title: '',
      description:
          'Lokasyonunuza özel, etkinlik ve kampanyalarımızı size sunabilmek için izninizin dahilinde konum bilginizi alıyoruz.'),
  Slide(
      imageUrl: 'assets/images/OnBoardingPush.jpg',
      title: 'ANLIK BİLDİRİM',
      description: 'Anlık Bildirimler ile size özel kampanyalarımızdan ve etkinliklerimizden haberdar olabilirsiniz.'),
  Slide(
      imageUrl: 'assets/images/OnBoardingWeapons.jpg',
      title: 'ÜRÜNLERİMİZ',
      description:
          'Ürünlerimizi ve aksesuarlarımızı daha yakından inceleyebilir, ilgi alanınıza özel ürün önerilerimizden faydalanabilirsiniz.'),
  Slide(
      imageUrl: 'assets/images/shotTimer.png',
      title: 'SHOT TIMER',
      description:
          'Canik Dijital Elektronik Atış Atım Ölçer, atıcılık sporlarında, yarışmacıya sesli bir sinyalle başlatan ve aynı zamanda başlama sinyalinden itibaren süre ile birlikte her atışın  sesini algılayarak kullanıcının zamanını elektronik olarak kaydeden aktif zaman ölçerdir.'),
  Slide(
      imageUrl: 'assets/images/OnBoardingPrivacy.jpg',
      title: 'KİŞİSEL VERİLERİN KORUNMASI KANUNU',
      description:
          'Kişisel verilerinize paylaşım izni vererek üye olduğunuzda; \n • Size özel kampanyalardan yararlanabilirsiniz.\n• Canik Silahlarınızı özelleştirebilirsiniz.\n• Canık profilinizi zenginleştirerek puan kazanabilir ve alışverişlerinizde kullanabilirsiniz.\n• Canik ekibiyle iletişime geçerek her türlü soru ve önerilerinizi bize yazabilirsiniz.'),
];
