import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/configurator/choose_your_gun/view/categories_for_gun_view.dart';
import 'package:mysample/configurator/choose_your_gun/view/test.dart';
import 'package:mysample/l10n/l10n.dart';
import 'package:mysample/product/init/product_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/bloc/language_form_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mysample/sfs/sfs_calibration_page/sfs_calibration_page.dart';
import 'package:mysample/sfs/sfs_connect_page/sfs_connect_page.dart';
import 'package:mysample/sfs/sfs_counter_pages/views/sfs_waiting_page_view.dart';
import 'package:mysample/sfs/sfs_modes_advanced_settings_page/sfs_modes_advanced_settings.dart';
import 'package:mysample/sfs/sfs_rapid_fire/view/sfs_rapid_fire_page_3_view.dart';
import 'package:mysample/sfs/sfs_rapid_fire/view/sfs_rapid_fire_page_4_view.dart';
import 'package:mysample/sfs/sfs_rapid_fire/view/sfs_rapid_fire_page_view.dart';
import 'package:mysample/views/add_gun_with_barcode.dart';
import 'package:mysample/views/ask_us_page.dart';
import 'package:mysample/views/canik_id_profile.dart';
import 'package:mysample/views/compare_guns_page.dart';
import 'package:mysample/views/gun_details.dart';
import 'package:mysample/views/location_and_language_choice.dart';
import 'package:mysample/views/seller_finder.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:mysample/widgets/sfs_error_page.dart';
import 'package:mysample/widgets/shot_timer_video_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';

void main() async {
  //Uygulamanın başladığı bölüm
  runApp(const Main());
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("1a3bc94c-945d-42a2-b5cf-497824922cfe");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<Main> {
  bool status = false;
  GeneralMockData mockData = GeneralMockData(checkedList: [], imagePath: "");
  List<String> images = [
    "assets/images/configurator/AnaKategoriler/1-0renk.png",
    "assets/images/configurator/AnaKategoriler/2-0namlu.png",
    "assets/images/configurator/AnaKategoriler/3-0nisangah.png",
    "assets/images/configurator/AnaKategoriler/4-0taktik-fener.png",
    "assets/images/configurator/AnaKategoriler/5-0tetik.png",
    "assets/images/configurator/AnaKategoriler/6-0sarjor.png",
    "assets/images/configurator/AnaKategoriler/7-0dipcik.png",
    "assets/images/configurator/AnaKategoriler/8-0tutamak.png",
    "assets/images/configurator/AnaKategoriler/9-0susturucu.png",
    "assets/images/configurator/AnaKategoriler/10-0arka-kabza.png",
    "assets/images/configurator/AnaKategoriler/11-0magwell.png",
    "assets/images/configurator/AnaKategoriler/12-0kilif.png",
    "assets/images/configurator/AnaKategoriler/13-0sarjor-kilidi.png",
  ];
  List<bool> isClick = [];
  String? selectedLang;
  Future<bool> choicePageStatus() async {
    final prefs = await SharedPreferences.getInstance();
    var choicePage = prefs.getBool('choicePageStatus');
    choicePage = choicePage == null ? false : true;
    selectedLang = prefs.getString('language');
    // return choicePage;
    return Future<bool>.value(choicePage);
  }

  @override
  void initState() {
    isClick = List<bool>.filled(images.length, false);
    setState(() {
      mockData = GeneralMockData(checkedList: isClick, imagePath: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiBlocProvider(
      providers: ProductInit().providers.cast(),
      child: BlocBuilder<LanguageFormBloc, LanguageFormState>(
        builder: (context, state) {
          return FutureBuilder<bool>(
            future: choicePageStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Sizer(
                  builder: (context, orientation, deviceType) {
                    return MaterialApp(
                      builder: EasyLoading.init(),
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(fontFamily: 'Akhand'),
                      locale: (selectedLang == "TR" || selectedLang == null)
                          ? const Locale("tr")
                          : const Locale("en"),
                      supportedLocales: L10n.all,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],

                      //home: CategoriesForGun(accessories: mockData),
                      home: snapshot.data == true
                          ? TabBarPage(index: 0)
                          : const Choice(),
                    );
                  },
                );
              }
              return const Center();
            },
          );
        },
      ),
    );
  }
}
