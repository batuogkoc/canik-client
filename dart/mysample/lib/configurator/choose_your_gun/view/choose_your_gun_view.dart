import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:mysample/configurator/choose_your_gun/model/choose_gun_model.dart';
import 'package:mysample/configurator/choose_your_gun/viewmodel/choose_your_gun_view_model.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../views/canik_id_profile.dart';
import '../../../views/canik_id_profile_login_page.dart';
import 'categories_for_gun_view.dart';
import 'confignavbar.dart';

class ChooseYourGunView extends StatefulWidget {
  const ChooseYourGunView({Key? key}) : super(key: key);

  @override
  State<ChooseYourGunView> createState() => _ChooseYourGunViewState();
}

class _ChooseYourGunViewState extends State<ChooseYourGunView> {

  // MOCK DATA CONFİG SAYFASI - 3D - ICIN
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
  GeneralMockData mockData = GeneralMockData(checkedList: [], imagePath: "");
   // MOCK DATA CONFİG SAYFASI - 3D - ICIN

  final String _configuratorText = 'CONFIGRATOR';
  final String _guns = 'GUNS';
  final double _paddingValue = 5.h;
  final String _nextButtonText = 'Next';
  bool isVisible = false;
  Color borderColor = Colors.transparent;
  List<bool> allIndex = [];
  List<bool> allIndexGrid = [];
  int _currentIndex = 0;
  int _currentIndexGrid = 0;
  @override
  void initState() {
    super.initState();

    // MOCK DATA CONFİG SAYFASI - 3D - ICIN
    isClick = List<bool>.filled(images.length, false);
    setState(() {
      mockData = GeneralMockData(checkedList: isClick, imagePath: "assets/images/3d/mac10.obj");
    });
    // MOCK DATA CONFİG SAYFASI - 3D - ICIN

    allIndex = List<bool>.filled(chooseGunListOne.length, false);
    allIndexGrid = List<bool>.filled(clickedGunModel.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:const ConfiguratorNavbar(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const _ChooseYourGunPadding.all(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.choose_your_gun, style: _ChooseYourGunTextStyle.built24),
                  SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chooseGunListOne.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _CustomCardView(
                          borderColor: allIndex[index] == false ? borderColor : ProjectColors().blue,
                          function: () {
                            setState(() {
                              allIndex = List<bool>.filled(chooseGunListOne.length, false);
                              _currentIndex =
                                  ChooseYourGunViewModel().findToCurrentIndex(chooseGunListOne[index].gunName);
                              allIndex[_currentIndex] = true;
                              isVisible = true;
                            });
                          },
                          textStyle: _ChooseYourGunTextStyle.akhand18,
                          padding: const _ChooseYourGunPadding.only(),
                          cardImagePath: chooseGunListOne[index].imageUrlPath,
                          cardText: chooseGunListOne[index].gunName,
                          containerHeight: 30.h,
                          containerWidth: 40.w,
                          imageHeight: 15.h,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _paddingValue),
                    child: Text(AppLocalizations.of(context)!.guns, style: _ChooseYourGunTextStyle.built24),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _paddingValue),
                    child: SizedBox(
                      height: 65.h,
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 1 / 1, mainAxisSpacing: 5.h),
                        itemCount: clickedGunModel.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _CustomCardView(
                            function: () {
                              setState(() {
                                _currentIndexGrid = ChooseYourGunViewModel()
                                    .findToCurrentIndexClickedGrid(clickedGunModel[index].gunName);
                                allIndexGrid[_currentIndexGrid] = true;
                              });
                            },
                            borderColor: allIndexGrid[index] == false ? borderColor : ProjectColors().blue,
                            textStyle: _ChooseYourGunTextStyle.akhand16,
                            padding: const EdgeInsets.only(right: 15),
                            containerHeight: 0,
                            containerWidth: 0,
                            imageHeight: 8.h,
                            cardImagePath: clickedGunModel[index].imageUrlPath,
                            cardText: clickedGunModel[index].gunName,
                          );
                        },
                      ),
                    ),
                  ).toVisible(isVisible),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                             context.navigateToPage( CategoriesForGun(accessories: mockData));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: ProjectColors().blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(AppLocalizations.of(context)!.next),
                          )).toVisible(isVisible),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomAppBarConfigurator extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBarConfigurator({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading:false,
        centerTitle: true,
        title: Text(
          text,
          style: TextStyle(color: ProjectColors().black3, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ProjectColors().black2,
        leading: GestureDetector(
            onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarPage(index: 0)));
          },
          child: 
       const Icon(Icons.home)),
        actions: [
          IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var isLogin = prefs.getBool('isLogin');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => isLogin == true ? CanikProfile() : const CanikIdProfileLogin()));
              },
              icon: Image.asset('assets/images/profil_icon.png')),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
          ),
        ));
  }
}

class _CustomGridView extends StatelessWidget {
  const _CustomGridView({
    Key? key,
    required double paddingValue,
  })  : _paddingValue = paddingValue,
        super(key: key);

  final double _paddingValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: _paddingValue),
      child: SizedBox(
        height: 65.h,
        child: GridView.builder(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1 / 1, mainAxisSpacing: 5.h),
          itemCount: clickedGunModel.length,
          itemBuilder: (BuildContext context, int index) {
            return _CustomCardView(
              borderColor: Colors.transparent,
              textStyle: _ChooseYourGunTextStyle.akhand16,
              padding: const EdgeInsets.only(right: 15),
              containerHeight: 0,
              containerWidth: 0,
              imageHeight: 10.h,
              cardImagePath: clickedGunModel[index].imageUrlPath,
              cardText: clickedGunModel[index].gunName,
            );
          },
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    Key? key,
  }) : super(key: key);

  final String _searchInGuns = 'Search In Guns';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: SizedBox(
        height: 10.h,
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            alignLabelWithHint: false,
            fillColor: ProjectColors().black2,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ProjectColors().blue, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ProjectColors().black3, width: 1),
            ),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            prefixIconColor: Colors.white,
            hintText: _searchInGuns,
            hintStyle: TextStyle(fontSize: 17, color: ProjectColors().black3, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _CustomCardView extends StatefulWidget {
  _CustomCardView({
    Key? key,
    this.borderColor,
    this.function,
    required this.cardImagePath,
    required this.cardText,
    required this.containerHeight,
    required this.containerWidth,
    required this.imageHeight,
    required this.padding,
    required this.textStyle,
  }) : super(key: key);
  final String cardImagePath;
  final String cardText;
  final double containerHeight;
  final double containerWidth;
  final double imageHeight;
  final EdgeInsets padding;
  final TextStyle textStyle;
  Function()? function;
  Color? borderColor;

  @override
  State<_CustomCardView> createState() => __CustomCardViewState();
}

class __CustomCardViewState extends State<_CustomCardView> {
  final String _gunBackgroundImagePath = 'assets/images/gun_background.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: InkWell(
        onTap: widget.function,
        child: Container(
          height: widget.containerHeight,
          width: widget.containerWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.borderColor ?? Colors.transparent),
              image: DecorationImage(image: AssetImage(_gunBackgroundImagePath), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.cardImagePath, height: widget.imageHeight),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SizedBox(
                  height: 3.h,
                  child: Text(
                    widget.cardText,
                    style: widget.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChooseYourGunPadding extends EdgeInsets {
  const _ChooseYourGunPadding.all() : super.all(30);
  const _ChooseYourGunPadding.only() : super.only(right: 45, top: 30);
}

class _ChooseYourGunTextStyle {
  static TextStyle built24 =
      TextStyle(fontSize: 24, fontFamily: 'Built', color: ProjectColors().white, fontWeight: FontWeight.w600);

  static TextStyle akhand18 = TextStyle(fontSize: 18, color: ProjectColors().white, fontWeight: FontWeight.w500);
  static TextStyle akhand16 = TextStyle(fontSize: 16, color: ProjectColors().white, fontWeight: FontWeight.w300);
}
