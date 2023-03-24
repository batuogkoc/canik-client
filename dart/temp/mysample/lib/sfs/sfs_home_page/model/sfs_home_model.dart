class HomeCardModel {
  final String title;
  final String subtitle;
  final String explanation;

  HomeCardModel({
    required this.title,
    required this.subtitle,
    required this.explanation,
  });
}

final homeCardList = [
  HomeCardModel(
      title: 'Fast Draw',
      subtitle: 'Active',
      explanation: 'Goal; Canik SFS breaks down your holster draw into key phase...'),
  HomeCardModel(
      title: 'Rapid Fire', subtitle: 'Active', explanation: 'Goal: Precision marksmanship.Instructions: Shoot...'),
  HomeCardModel(
      title: 'Shot Timer',
      subtitle: 'de-Active',
      explanation:
          '• Rapid Fire / Open Training\n•Primary Hand Only Training \n• Support Hand Only Training \n• Reload Training'),
  HomeCardModel(title: '', subtitle: '', explanation: '')
];
