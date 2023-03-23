import 'dart:math' as Math;

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysample/configurator/choose_your_gun/view/categories_for_gun_view.dart';
import 'package:mysample/configurator/splash_screen/view/configurator_splash_view.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/canik_home_page.dart';
import 'package:mysample/views/canik_store_home_page.dart';
import 'package:mysample/views/gun_details.dart';
import 'package:mysample/views/gun_home_page.dart';
import 'package:mysample/views/register_Login_screen.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:mysample/views/special_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/app_bar_icon_widget.dart';
import '../widgets/bottom_app_bar_widget.dart';

class TabBarPage extends StatefulWidget {
  int index = 0;
  TabBarPage({Key? key, required this.index}) : super(key: key);
  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBarPage> {
  final pages = <Widget>[CanikHomePage(), GunHome(), const Special(), const CanikStore(), GunDetails()];
  bool isLogin = false;
  bool isClick = false;
  Future<void> getLogin() async{
    var prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool("isLogin")!;
    setState(() {
      isLogin = login;
    });
    print(isLogin);
  }
  @override
  void initState() {
    getLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {return false;} ,
    child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: const CustomAppBarWithImage(index: 0, imagePath: 'assets/images/canik_super.png'),
          extendBody: true,
          body: pages[widget.index],
          bottomNavigationBar: TabBarMaterialWidget(index: widget.index, onChangedTab: onChangedTab),
          floatingActionButton: FloatingActionButton(
           
          child: SvgPicture.asset("assets/images/walkie-talkie-radio.svg"),
          backgroundColor: projectColors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShotTimeHomePage()));
          },
          
          // floatingActionButton: isLogin ? 
          // CircularMenu(
          //     toggleButtonColor: projectColors.blue,
          //     toggleButtonIconColor: Colors.white,
          //     toggleButtonMargin: 20.0,
          //     toggleButtonPadding: 15.0,
          //     toggleButtonSize: 35.0,
          //     startingAngleInRadian: 1.25 * Math.pi,
          //     endingAngleInRadian: 1.75 * Math.pi,
          //     items: [
          //     CircularMenuItem(
          //         icon: Icons.timer,
          //         iconSize: 35,
          //         color: projectColors.blue,
          //         onTap: () {
          //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShotTimeHomePage()));
          //         },
          //       ), 
          //       CircularMenuItem(
          //         icon: Icons.settings,
          //         iconSize: 35,
          //         color: projectColors.blue,
          //         onTap: () {
          //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfiguratorSplashView()));
          //         },
          //       ),
          //     ]):
          // CircularMenu(
          //     toggleButtonColor: projectColors.blue,
          //     toggleButtonIconColor: Colors.white,
          //     toggleButtonMargin: 20.0,
          //     toggleButtonPadding: 15.0,
          //     toggleButtonSize: 35.0,
          //     startingAngleInRadian: 1.25 * Math.pi,
          //     endingAngleInRadian: 1.75 * Math.pi,
          //     items: [
          //     CircularMenuItem(
          //         icon: Icons.timer,
          //         iconSize: 35,
          //         color: projectColors.blue,
          //         onTap: () {
          //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginRegister()));
          //         },
          //       ), 
          //       CircularMenuItem(
          //         icon: Icons.settings,
          //         iconSize: 35,
          //         color: projectColors.blue,
          //         onTap: () {
          //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfiguratorSplashView()));
          //         },
          //       ),
          //     ]),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  ));

  onChangedTab(int index) {
    setState(() {
      widget.index = index;
    });
  }
}
