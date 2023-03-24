import 'package:flutter/material.dart';
import 'package:mysample/views/acc_details.dart';
import 'package:mysample/views/add_gun_home.dart';

import 'package:mysample/widgets/app_bar_widget.dart';

import '../constants/color_constants.dart';
import '../entities/product_category_assignment.dart';
import '../models/all_acc_model.dart';
import '../models/canik_gun_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GunDetails extends StatefulWidget {
  ProductCategoryAssignment? productCategoryAssignment;

  GunDetails({Key? key, this.productCategoryAssignment}) : super(key: key);

  @override
  State<GunDetails> createState() => _GunDetailsState();
}

class _GunDetailsState extends State<GunDetails> {
  @override
  bool isCheckedG = true;
  bool isCheckedB = false;
  Text? text;
  var guns = gunList;
  static const customTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  ProjectColors projectColors = ProjectColors();

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: GunDetailsColor.suitBlue,
        appBar: CustomAppBarWithText(
          text: 'Silah',
          // text: widget.productCategoryAssignment!.productCategoryName,
        ),
        bottomNavigationBar: Container(
          color: projectColors.black,
          child: TextButton(
            onPressed: () {},
            child: Text(
              AppLocalizations.of(context)!.detail_info,
              style: GunDetailsTextStyle.built17,
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          children: [
            const HeaderImage(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/images/backgroundNew.png",
                  ),
                ),
              ),
              child: Column(
                children: [
                  GunInfo(),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 30, top: 28),
                    child: Container(
                      decoration: BoxDecoration(color: projectColors.black, borderRadius: BorderRadius.circular(18.5)),
                      child: _CustomTabBar(projectColors: projectColors),
                    ),
                  ),
                  SizedBox(
                    height: 1100,
                    child: TabBarView(children: [
                      primeFeatures(),
                      techFeatures(),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column techFeatures() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 30, bottom: 15),
          child: Text(
            AppLocalizations.of(context)!.dimensions,
            style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Built', fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          children: [
            _customRowDimensions('1', 'Uzunluk', '170,5 mm', '6,71 inch'),
            _customRowDimensions('2', 'Yükseklik', '116 mm', '4,57 inch'),
            _customRowDimensions('3', 'Genişlik', '37 mm', '1,46 inch'),
            _customRowDimensions('4', 'Namlu Uzunluğu', '91,5 mm', '3,60 inch'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  AppLocalizations.of(context)!.other,
                  style: const TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: 'Built', fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _customContainerWithIcon('assets/images/gunDetailIcon1.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 45,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 296,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'KALİBRE',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '9mm - 12 rounds',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 296,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'ŞARJÖR KAPASİTESİ',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '.40S&W - NA',
                                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _customContainerWithIcon('assets/images/gunDetailIcon2.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'TETİK HAREKETİ',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'SAO',
                            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _customPlayCard(),
              CustomViewAllWidget(
                  paddingTop: 48, paddingBottom: 15, customText: AppLocalizations.of(context)!.related_products),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: gunList.length,
                    itemBuilder: (context, index) {
                      var gun = gunList[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: buildListview(item: gun),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container _customContainerWithIcon(String imagePath) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: GunDetailsColor.crypt,
          image: DecorationImage(image: AssetImage(imagePath))),
    );
  }

  Padding _customRowDimensions(String text1, String text2, String text3, String text4) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  text1,
                  style: TextStyle(color: projectColors.blue, fontSize: 17, fontWeight: FontWeight.w300),
                ),
              ),
              Text(
                text2,
                style: GunDetailsTextStyle.w300,
              ),
            ],
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    text3,
                    style: GunDetailsTextStyle.w300,
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    '|',
                    style: GunDetailsTextStyle.w300,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    text4,
                    style: GunDetailsTextStyle.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding primeFeatures() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.basic_features.toUpperCase(),
            style: GunDetailsTextStyle.builtW600,
          ),
          _customRow("Touting “quick and simple image placeholders”."),
          _customRow('It’s high time we had a celeb appear on.'),
          _customRow('This placeholder image generator offers.'),
          _customRow('A fun twist on the popular photo sharing site.'),
          _customRow('It’s high time we had a celeb appear on.'),
          _customPlayCard(),
          CustomViewAllWidget(
              paddingTop: 48, paddingBottom: 15, customText: AppLocalizations.of(context)!.related_products),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 210,
              child: ListView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
                itemCount: gunList.length,
                itemBuilder: (context, index) {
                  var gun = gunList[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: buildListview(item: gun),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _customPlayCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 38, bottom: 48),
      child: Container(
        height: 331,
        width: 338,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage('assets/images/gunDetailVideoImg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 19.0, right: 5, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'TP 9 SUB METE ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                'Our progressive pistol development courses offer a logical shooting evolution designed to build a complete shooter, from beginner to.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _customRow(String text) {
    return Row(
      children: [
        customBullet(),
        const SizedBox(
          width: 9,
        ),
        Text(
          text,
          style: GunDetailsTextStyle.built17White,
        ),
      ],
    );
  }

  Column GunInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 34),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SİLAHLAR',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff909090)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  Text(
                    '(4.8)',
                    style: TextStyle(color: Color(0xff3F4343), fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    '(231)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xff909090)),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                // widget.productCategoryAssignment!.productCategoryName,
                'Silah',
                style: textStyleTitle(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff909090)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' \$2,999',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: projectColors.blue),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9.0),
                          height: 24.0,
                          width: 24.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(9.0),
                          height: 24.0,
                          width: 24.0,
                          decoration: const BoxDecoration(
                            color: Color(0xffCCC6BA),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          padding: const EdgeInsets.all(9.0),
                          height: 24.0,
                          width: 24.0,
                          decoration: const BoxDecoration(
                            color: Color(0xffCFCFCF),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildListview({
    required Gun item,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/gun_background.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              item.imageUrl,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16, right: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    color: projectColors.black3,
                    child: const Text(
                      'YENi',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(item.productName, style: customTextStyle),
                  ),
                  const Text(
                    '.380ACP, 9mm, .40S&W',
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyleTitle() =>
      TextStyle(fontSize: 22, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white);

  Container customBullet() {
    return Container(
      padding: const EdgeInsets.all(9.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(
        color: projectColors.blue,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildCard({required Acces item}) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.blueGrey.shade300,
              borderRadius: BorderRadius.circular(20),
              child: Ink.image(
                height: 150,
                width: 150,
                image: AssetImage(
                  item.imageUrl,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccDetail()));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: TextStyle(
                        fontSize: 17,
                        color: projectColors.blue,
                      ),
                    ),
                    Text(
                      item.hastag,
                      style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _CustomTabBar extends StatelessWidget {
  const _CustomTabBar({
    Key? key,
    required this.projectColors,
  }) : super(key: key);

  final ProjectColors projectColors;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        isScrollable: true,
        labelColor: GunDetailsColor.metropolitAnsil,
        unselectedLabelColor: projectColors.white1,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white,
        indicator: BoxDecoration(borderRadius: BorderRadius.circular(18.5), color: Colors.white),
        tabs: [
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.basic_features,
                style: GunDetailsTextStyle.w700,
              ),
            ),
          ),
          Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.technical_features,
                style: GunDetailsTextStyle.w700,
              ),
            ),
          ),
        ]);
  }
}

class HeaderImage extends StatelessWidget {
  const HeaderImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GunDetailsPadding().onlyBottom20Padding,
      child: Container(
          decoration: const BoxDecoration(
              color: GunDetailsColor.suitBlue,
              image: DecorationImage(image: AssetImage('assets/images/homepage_gun_1.png'))),
          height: 320,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: GunDetailsPadding().onlyRightPadding,
                child: _circleWhiteContainer(),
              ),
              Padding(
                padding: GunDetailsPadding().onlyRightPadding,
                child: Container(
                  height: 6,
                  width: 24,
                  decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(50)),
                ),
              ),
              _circleWhiteContainer()
            ],
          )),
    );
  }

  Container _circleWhiteContainer() {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
    );
  }
}

class CustomViewAllWidget extends StatelessWidget {
  final double paddingTop;
  final double paddingBottom;
  final String customText;

  const CustomViewAllWidget({Key? key, required this.paddingTop, required this.paddingBottom, required this.customText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(customText,
              style:
                  const TextStyle(fontSize: 22, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white)),
          TextButton(
              onPressed: () {}, child: Text(AppLocalizations.of(context)!.view_all, style: GunDetailsTextStyle.blue14))
        ],
      ),
    );
  }
}

class GunDetailsPadding {
  final EdgeInsets onlyRightPadding = const EdgeInsets.only(right: 15);
  final EdgeInsets onlyBottom20Padding = const EdgeInsets.only(bottom: 20);
}

class GunDetailsColor {
  static const Color suitBlue = Color(0xff2b3037);
  static const Color metropolitAnsil = Color(0xff3F4343);
  static const Color crypt = Color(0xff333B43);
}

class GunDetailsTextStyle {
  static const TextStyle w700 = TextStyle(fontSize: 17, fontWeight: FontWeight.w700);
  static const TextStyle built17 = TextStyle(fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.w600);
  static const TextStyle built17White =
      TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Built', fontWeight: FontWeight.w600);

  static const TextStyle builtW600 =
      TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Built', fontWeight: FontWeight.w600);

  static TextStyle blue14 = TextStyle(
    fontSize: 14,
    color: projectColors.blue,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle w300 = TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300);
}
