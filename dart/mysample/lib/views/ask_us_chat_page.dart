import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:mysample/views/ask_us_questions_page.dart';
import 'package:mysample/widgets/app_bar_widget.dart';

import '../constants/color_constants.dart';
import '../widgets/background_image_widget.dart';

class AskUsChatPage extends StatefulWidget {
  AskUsChatPage({Key? key}) : super(key: key);

  @override
  State<AskUsChatPage> createState() => _AskUsChatPageState();
}

class _AskUsChatPageState extends State<AskUsChatPage> {
  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/image_9.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBarWithText(text: 'Bize Sorun'),
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        padding: EdgeInsets.only(left: 20, right: 30),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: projectColors.black,
                        ),
                        child: Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Cevap Yazın",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 50, height: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              primary: projectColors.blue),
                          onPressed: () {},
                          child: (Image.asset('assets/images/paper-plane.png',
                              width: 30, height: 30)),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: projectColors.black3),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'ÜRÜNLER',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: projectColors.blue),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                'TOUTING "QUICK AND SIMPLE IMAGE PLACEHOLDERS".',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text('12.12.2020',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text('CEVAPLANDI',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                        color: Color.fromARGB(
                                            255, 255, 255, 255))),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
                ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sistem Yöneticisi',
                                      style: TextStyle(
                                          color: projectColors.black3,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('15:42',
                                        style: TextStyle(
                                            color: projectColors.black3,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: projectColors.black,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
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
