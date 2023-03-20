import 'package:flutter/material.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/app_bar_widget.dart';

class AccDetail extends StatefulWidget {
  AccDetail({Key? key}) : super(key: key);

  @override
  State<AccDetail> createState() => _AccDetailState();
}

class _AccDetailState extends State<AccDetail> {
  @override
  bool isCheckedG = true;
  bool isCheckedB = false;

  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: const Color(0xff7C9098),
            appBar: const CustomAppBarWithText(text: 'AKSESUAR DETAYI'),
            bottomNavigationBar: Container(
              color: ProjectColors().black,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'DETAYLI BİLGİ İÇİN EN YAKIN CANİK DİSTRİBÜTÖRÜNE DANIŞABİLİRSİNİZ',
                  style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Built',
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            body: ListView(
              children: [
                Container(
                    color: const Color(0xff7C9098),
                    width: 500,
                    height: 250,
                    child: Image.asset('assets/images/big_equ.png')),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/image_9.png",
                      ),
                    ),
                  ),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 185.0),
                            child: Text('Renk \n TUNGSTEN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300)),
                          ),
                          Checkbox(
                              activeColor: const Color(0xff606060),
                              value: isCheckedG,
                              onChanged: (bool? value) {}),
                          Checkbox(
                              activeColor: const Color(0xff1A1A1A),
                              value: isCheckedB,
                              onChanged: (bool? value) {}),
                        ],
                      ),
                      ColoredBox(
                        color: ProjectColors().black,
                        child: TabBar(
                            isScrollable: true,
                            labelColor: projectColors.blue,
                            unselectedLabelColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            tabs: const [
                              Tab(
                                child: Text(
                                  'Uyumlu Modeller',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 41.0, right: 41),
                                child: Tab(
                                  child: Text(
                                    'Özellikler',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Açıklama',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: TabBarView(children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, left: 30.0),
                                child: Row(
                                  children: [
                                    customBullet(),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    const Text(
                                      'TP9 ELITE-S COMBAT',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 30.0),
                                child: Row(
                                  children: [
                                    customBullet(),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    const Text(
                                      'TP9 ELITE COMBAT',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 30.0),
                                child: Row(
                                  children: [
                                    customBullet(),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    const Text(
                                      'TP9 ELITE-S EXECUTIVE',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 30.0),
                                child: Row(
                                  children: [
                                    customBullet(),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    const Text(
                                      'TP9 SF METE-S',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 30.0),
                                child: Row(
                                  children: [
                                    customBullet(),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    const Text(
                                      'TP9 SF METE',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontFamily: 'Built',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Temel Özellikler',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Built',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Row(
                                    children: [
                                      customBullet(),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      const Text(
                                        'Touting “quick and simple image placeholders”.',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Built',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Row(
                                    children: [
                                      customBullet(),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      const Text(
                                        'It’s high time we had a celeb appear on.',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Built',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Row(
                                    children: [
                                      customBullet(),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      const Text(
                                        'This placeholder image generator offers.',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Built',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Row(
                                    children: [
                                      customBullet(),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      const Text(
                                        'A fun twist on the popular photo sharing site.',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Built',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: Row(
                                    children: [
                                      customBullet(),
                                      const SizedBox(
                                        width: 9,
                                      ),
                                      const Text(
                                        'It’s high time we had a celeb appear on.',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Built',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: const [
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit vitae montes, odio erat ac, dis. Varius aliquam, bibendum ut turpis consectetur bibendum proin. Eget augue amet vitae, sit dictum ac sit neque. Hendrerit eu sapien etiam neque. Et elit sit eros tortor in tempus eget lacus montes. Quis vestibulum cras eget molestie dictum potenti urna, sed. Massa vestibulum nisi laoreet in pharetra.',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontFamily: 'Built',
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

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
}
