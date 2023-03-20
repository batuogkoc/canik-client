class HomePageSlide {
  final String iconUrl;
  final String title;
  final String subtitle;
  HomePageSlide({
    required this.iconUrl,
    required this.title,
    required this.subtitle,
  });
}

final homePageSlideList = [
  HomePageSlide(
      iconUrl: 'assets/images/task-planning.png',
      title: 'MY SHOTS',
      subtitle:
          'It is a long established fact that a\n reader will be distracted.'),
  // HomePageSlide(
  //     iconUrl: 'assets/images/certificates.png',
  //     title: 'CERTIFICATES',
  //     subtitle:
  //         'It is a long established fact that a\n reader will be distracted.'),
];
