import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';

import '../constants/color_constants.dart';

class CertificatesPage extends StatefulWidget {
  CertificatesPage({Key? key}) : super(key: key);

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  //List<Certificates> certificates = <Certificates>[];
  var certificates = [
    Certificates(
        certFinishText: 'Geçerlilik Tarihi:',
        certFinishDate: '12.11.2024',
        certStartText: 'Kursu Bitirime Tarihi:',
        certStartDate: '12.11.2020',
        certName: 'Deneme Sertifika İsmi Random Maksimum İsim...',
        certImg: 'assets/images/certificates_img.png'),
    Certificates(
        certFinishText: 'Geçerlilik Tarihi:',
        certFinishDate: '12.11.2025',
        certStartText: 'Kursu Bitirime Tarihi:',
        certStartDate: '12.11.2021',
        certName: 'Deneme Sertifika İsmi Random Maksimum İsim...',
        certImg: 'assets/images/certificates_img.png')
  ];

  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: projectColors.black3,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    var textStyle2 = TextStyle(
      color: projectColors.blue,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          appBar: const CustomAppBarWithText(text: 'SERTİFİKALARIM'),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SERTİFİKALARIM',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Built',
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: certificates.length,
                      itemBuilder: ((context, index) {
                        var certicate = certificates[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15),
                          child: Container(
                            height: 400,
                            width: 315,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                //stops: Alignment.center,

                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0x393E4647),
                                  projectColors.black,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, top: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        certicate.certFinishText!,
                                        style: textStyle,
                                      ),
                                      Text(certicate.certFinishDate!,
                                          style: textStyle2),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        Text(certicate.certStartText!,
                                            style: textStyle),
                                        Text(certicate.certStartDate!,
                                            style: textStyle2)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      certicate.certName!,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 59.0),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                          certicate.certImg!,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Certificates {
  String? certFinishText;
  String? certFinishDate;
  String? certStartText;
  String? certStartDate;
  String? certName;
  String? certImg;
  Certificates({
    this.certFinishText,
    this.certFinishDate,
    this.certStartText,
    this.certStartDate,
    this.certName,
    this.certImg,
  });
}
