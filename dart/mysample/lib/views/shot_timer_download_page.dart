import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../constants/color_constants.dart';
import '../entities/shot_timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShotTimerDownload extends StatefulWidget {
  ShotTimerListResponseModel shotTimerListResponseModel;
  ShotTimerDownload({Key? key, required this.shotTimerListResponseModel}) : super(key: key);

  @override
  State<ShotTimerDownload> createState() => _ShotTimerDownloadState();
}

class _ShotTimerDownloadState extends State<ShotTimerDownload> {
  final screenController = ScreenshotController();

  bool didCaptured = false;

  Future<void> capture() async {
    await screenController.capture().then((image) {
      didCaptured = true;
      ShowCapturedWidget(context, image!);
      Future.delayed(const Duration(seconds: 1), () {
        saveImage(image).whenComplete(() =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShotTimeHomePage())));
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> saveImage(Uint8List bytes) async {
    [Permission.storage].request();

    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');

    final name = 'screenshot_$time';
    ImageGallerySaver.saveImage(bytes, name: name);
  }

  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    );
    var textStyle2 = TextStyle(
      color: projectColors.blue,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    var textStyle3 = TextStyle(
      color: projectColors.blue,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    if (didCaptured == false) {
      Future.delayed(const Duration(seconds: 1), () {
        capture();
      });
    }

    return Screenshot(
      controller: screenController,
      child: Stack(
        children: [
          const BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: projectColors.black3,
                        height: 2,
                      ),
                      Text(
                        widget.shotTimerListResponseModel.shotName,
                        style: TextStyle(
                          color: projectColors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.shotTimerListResponseModel.weapon,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Divider(
                        color: projectColors.black3,
                        height: 2,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      midCustomRow(AppLocalizations.of(context)!.shot_count,
                          widget.shotTimerListResponseModel.totalShot!, textStyle, textStyle2),
                      context.emptySizedHeightBoxLow,
                      midCustomRow(AppLocalizations.of(context)!.total_time,
                          widget.shotTimerListResponseModel.totalTime.toStringAsFixed(2), textStyle, textStyle2),
                      context.emptySizedHeightBoxLow,
                      midCustomRow(
                          AppLocalizations.of(context)!.date,
                          widget.shotTimerListResponseModel.date
                              .toString()
                              .substring(0, 10)
                              .split('-')
                              .reversed
                              .join('-'),
                          textStyle,
                          textStyle3)
                    ],
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/canik_super.png',
                      color: projectColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row midCustomRow(String text1, String text2, TextStyle textStyle, TextStyle textStyle2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: textStyle,
        ),
        Container(
          height: 38,
          width: 84,
          decoration: BoxDecoration(
            color: projectColors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text2,
              style: textStyle2,
            ),
          ),
        )
      ],
    );
  }
}

Future<dynamic> ShowCapturedWidget(BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      body: Center(child: capturedImage != null ? Image.memory(capturedImage) : Container()),
    ),
  );
}
