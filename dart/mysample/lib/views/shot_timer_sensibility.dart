import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysample/views/shot_timer_fire.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:mysample/widgets/background_image_widget.dart';

import '../constants/color_constants.dart';

class ShotTimerSensi extends StatefulWidget {
  ShotTimerSensi({Key? key}) : super(key: key);

  @override
  State<ShotTimerSensi> createState() => _ShotTimerSensiState();
}

class _ShotTimerSensiState extends State<ShotTimerSensi> {
  double _currentSliderValue = 0;
  final GlobalKey _key = GlobalKey();
  ProjectColors projectColors = ProjectColors();

  // Coordinates
  double _x = 0.0, _y = 0.0;

  // This function is called when the user presses the floating button
  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);

    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyleValue = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400);
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
              'HASSASİYET',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 102,
                decoration: BoxDecoration(
                  color: projectColors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/wave.png',
                    color: projectColors.blue,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        _currentSliderValue.toInt().toString() + ' db',
                        style: TextStyle(
                            color: projectColors.blue,
                            fontSize: 64,
                            fontWeight: FontWeight.w400),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            '0',
                            style: textStyleValue,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                  inactiveTrackColor: projectColors.white1,
                                  activeTrackColor: projectColors.blue,
                                  trackHeight: 1,
                                  thumbColor: projectColors.blue,
                                  thumbShape: const RoundSliderThumbShape(
                                    elevation: 4,
                                    enabledThumbRadius: 15,
                                  )),
                              child: Stack(
                                children: [
                                  Slider(
                                    key: _key,
                                    value: _currentSliderValue,
                                    max: 100,
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSliderValue = value;
                                      });
                                    },
                                  ),
                                  // Positioned(
                                  //   left: _x,
                                  //   bottom: _y + 12,
                                  //   //bottom: 150,
                                  //   //bottom: _z == null ? _getPosition(_key) - 10 : _z,
                                  //   child: Container(
                                  //     height: 10,
                                  //     width: 10,
                                  //     color: Colors.amber,
                                  //   ),
                                  // ),
                                  // Positioned(
                                  //   left: screenWidth / 2 + 50,
                                  //   bottom: _y + 12,
                                  //   //bottom: 150,
                                  //   //bottom: _z == null ? _getPosition(_key) - 10 : _z,
                                  //   child: Container(
                                  //     height: 10,
                                  //     width: 10,
                                  //     color: Colors.amber,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          const Text(
                            '100',
                            style: textStyleValue,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 68,
                            decoration: BoxDecoration(
                                color: const Color(0xff20272F),
                                borderRadius: BorderRadius.circular(15)),
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
                                      'İç mekan ve dış mekan için önerilen hassasiyetler silah modeline göre farklılık gösterebilmektedir.',
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
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShotTimeHomePage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(150, 54),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            side: const BorderSide(
                                                color: Colors.white,
                                                width: 1.5)),
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShotTimerFire(
                                                    sensibility:
                                                        _currentSliderValue,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(150, 54),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
