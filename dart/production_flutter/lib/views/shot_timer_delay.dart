import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../widgets/background_image_widget.dart';

class ShotTimerDelay extends StatefulWidget {
  ShotTimerDelay({Key? key}) : super(key: key);

  @override
  State<ShotTimerDelay> createState() => _ShotTimerDelayState();
}

class _ShotTimerDelayState extends State<ShotTimerDelay> {
  int selectedValue = 0;
  int selectedInner = 0;
  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: const Icon(Icons.arrow_back_ios_sharp),
              color: projectColors.black3,
            ),
            title: Text(
              'GECİKME ZAMANI SEÇİMİ',
              style: TextStyle(
                  color: projectColors.black3,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: projectColors.black2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.0),
                bottomRight: Radius.circular(18.0),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 102,
                      decoration: BoxDecoration(
                        color: projectColors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/stopwatch.png',
                          color: projectColors.blue,
                        ),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                          unselectedWidgetColor: projectColors.white1),
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 0,
                            groupValue: selectedValue,
                            activeColor: projectColors.blue,
                            title: Text(
                              'Hemen Başlat',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: selectedValue == 0
                                      ? projectColors.blue
                                      : projectColors.white1,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (value) => setState(() {
                              selectedValue = 0;
                              selectedInner = 0;
                            }),
                          ),
                          RadioListTile(
                            value: 1,
                            groupValue: selectedValue,
                            activeColor: projectColors.blue,
                            title: Text(
                              'Sabit Zaman (0-60sn)',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: selectedValue == 1
                                      ? projectColors.blue
                                      : projectColors.white1,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (value) => setState(() {
                              selectedValue = 1;
                              selectedInner = 0;
                            }),
                          ),
                          selectedValue == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, bottom: 45),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.25,
                                        child: TextField(
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: projectColors.blue),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedValue,
                            activeColor: projectColors.blue,
                            title: Text(
                              'Random Zaman (0-60sn)',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: selectedValue == 2
                                      ? projectColors.blue
                                      : projectColors.white1,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (value) => setState(() {
                              selectedValue = 2;
                              selectedInner = 0;
                            }),
                          ),
                          selectedValue == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, bottom: 45),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Başlanıç Zamanı',
                                            style: TextStyle(
                                              color: projectColors.white1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.25,
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            projectColors.blue),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 30),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bitiş Zamanı',
                                            style: TextStyle(
                                              color: projectColors.white1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.25,
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            projectColors.blue),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedValue,
                            activeColor: projectColors.blue,
                            title: Text(
                              'Zaman Aralığı',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: selectedValue == 3
                                      ? projectColors.blue
                                      : projectColors.white1,
                                  fontWeight: FontWeight.w400),
                            ),
                            onChanged: (value) => setState(() {
                              selectedValue = 3;
                            }),
                          ),
                          selectedValue == 3
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 45.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RadioListTile(
                                        value: 4,
                                        groupValue: selectedInner,
                                        activeColor: projectColors.blue,
                                        title: Text(
                                          'Hemen Başlat',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: selectedInner == 4
                                                  ? projectColors.blue
                                                  : projectColors.white1,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        onChanged: (value) => setState(() {
                                          selectedInner = 4;
                                        }),
                                      ),
                                      selectedInner == 4
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Bitiş Zamanı',
                                                    style: TextStyle(
                                                      color:
                                                          projectColors.white1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                    child: TextField(
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: projectColors
                                                                        .blue),
                                                              )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      RadioListTile(
                                        value: 5,
                                        groupValue: selectedInner,
                                        activeColor: projectColors.blue,
                                        title: Text(
                                          'Gecikme Zamanı',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: selectedInner == 5
                                                  ? projectColors.blue
                                                  : projectColors.white1,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        onChanged: (value) => setState(() {
                                          selectedInner = 5;
                                        }),
                                      ),
                                      selectedInner == 5
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0, bottom: 45),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Gecikme Zamanı',
                                                        style: TextStyle(
                                                          color: projectColors
                                                              .white1,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.25,
                                                        child: TextField(
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                projectColors.blue),
                                                                  )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 30),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Bitiş Zamanı',
                                                        style: TextStyle(
                                                          color: projectColors
                                                              .white1,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.25,
                                                        child: TextField(
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                projectColors.blue),
                                                                  )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container(),
                          selectedValue == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: Container(
                                    height: 68,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff20272F),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.warning_amber,
                                              color: projectColors.blue,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              'Random zaman özelliği bağlangıç ve bitiş için belirlenen aralıkta rasgele bir zamanda Shot Timer’ı başlatacaktır.',
                                              maxLines: null,
                                              style: TextStyle(
                                                  color: projectColors.white1,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 54),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5)),
                              primary: Colors.transparent),
                          child: const Text(
                            'KAPAT',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Built',
                                fontWeight: FontWeight.w400),
                          )),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              primary: projectColors.blue),
                          child: const Text(
                            'BAŞLAT',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Built',
                                fontWeight: FontWeight.w400),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
