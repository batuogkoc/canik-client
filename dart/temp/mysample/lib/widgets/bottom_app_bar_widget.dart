import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysample/views/canik_store_home_page.dart';
import 'package:mysample/views/special_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color_constants.dart';
import '../views/register_Login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final onChangedTab;

  const TabBarMaterialWidget({required this.index, required this.onChangedTab}) : super();

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  get placeHolder => const Opacity(
      child: IconButton(
        icon: Icon(Icons.no_cell),
        onPressed: null,
      ),
      opacity: 0);
  ProjectColors projectColors = ProjectColors();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: BottomAppBar(
        color: projectColors.black2,
        notchMargin: 15.0,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            buildTabItem(index: 0, icon: 'assets/images/hangar.svg', text: AppLocalizations.of(context)!.home_page),
            buildTabItem(index: 1, icon: 'assets/images/gun 2.svg', text: AppLocalizations.of(context)!.my_arms),
            placeHolder,
            buildTabItem(index: 2, icon: 'assets/images/dog-tag.svg', text: AppLocalizations.of(context)!.for_you),
            buildTabItem(index: 3, icon: 'assets/images/rucksack.svg', text: AppLocalizations.of(context)!.store)
          ]),
        ),
      ),
    );
  }

  Widget buildTabItem({required int index, required String icon, required String text}) {
    final isSelected = index == widget.index;
    return SizedBox.fromSize(
      size: Size(60, 65), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: Column(
            children: <Widget>[
              IconButton(
                icon: SvgPicture.asset(
                  icon,
                  color: isSelected
                      ? projectColors.blue
                      : index == 3
                          ? projectColors.black3
                          : null,
                ),
                onPressed: () async {
                  if (index == 1 || index == 2) {
                    await checkLoginStatu();
                  }
                  widget.onChangedTab(index);
                },
              ),
              Text(
                text,
                style: TextStyle(
                    color: isSelected ? projectColors.blue : projectColors.black3,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ), // text
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkLoginStatu() async {
    final prefs = await SharedPreferences.getInstance();
    var isLogin = await prefs.getBool('isLogin');
    if (isLogin == false) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginRegister()));
    }
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId', deviceId!);
  }
}
