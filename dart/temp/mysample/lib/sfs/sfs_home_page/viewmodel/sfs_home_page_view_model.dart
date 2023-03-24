import 'package:mysample/sfs/sfs_home_page/model/sfs_home_model.dart';

class SfsHomePageViewModel {
  int findToCurrentIndexHomePage(String elementOfList) {
    for (var homeCard in homeCardList) {
      if (homeCard.title == elementOfList) {
        return homeCardList.indexOf(homeCard);
      }
    }
    return 0;
  }
}
