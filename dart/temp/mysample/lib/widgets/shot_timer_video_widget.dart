

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/views/tabs_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../views/shot_timer_fire.dart';
import '../views/shot_timer_home_page.dart';

class ShotTimerVideo extends StatefulWidget {
  const ShotTimerVideo({Key? key}) : super(key: key);

  @override
  State<ShotTimerVideo> createState() => _ShotTimerVideoState();
}

class _ShotTimerVideoState extends State<ShotTimerVideo> {
  late VideoPlayerController controller;
  bool isClick = true;
  loadnewPage(){
    if(isClick){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShotTimerFire()),
        );
    }
    
  }
  loadVidePlayer()async{
    controller = VideoPlayerController.network("http://164.90.212.149/Videos/shotTimer.mp4");
    await controller.initialize();
    await controller.play();
    setState(() {
              });
    Future.delayed(const Duration(seconds: 9),() {
         loadnewPage();
      },).then((value) => {
        controller.dispose()
      });          
  }
  loadVideoPlayer() {
    controller = VideoPlayerController.network("http://164.90.212.149/Videos/shotTimer.mp4");
    
    controller.initialize().then((value) {
      controller.play();
       setState(() {
              });
      Future.delayed(const Duration(seconds: 9),() {
         loadnewPage();
      },).then((value) => {
        controller.dispose()
      });
    });
  }
  @override
  void initState() {
    loadVidePlayer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body:controller.value.isInitialized ? Stack(
          fit: StackFit.expand,
          children:[
            FittedBox(
              fit: BoxFit.cover,
              child:  SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),),
              ) 
            ),
            Column(
              children: [
                SizedBox(height: 75.h,),
                Align(
                alignment: Alignment.center,
                child: Text("STAND BY...",style: TextStyle(color:ProjectColors().white,fontSize: 24.sp,fontWeight: FontWeight.w500),)),
                SizedBox(height: 2.h,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                          const ShotTimeHomePage()
                            ));
                            setState(() {
                              isClick = false;
                            });
                          controller.dispose();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),side: BorderSide(color: ProjectColors().white)),
                      fixedSize: const Size(315, 54),
                      primary: ProjectColors().black),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Built',
                        fontWeight: FontWeight.w500),
                  )),
              ],
            ),
          ] 
        ): Container(
          color: ProjectColors().black,
          child: const Center(child:  CircularProgressIndicator())),
      ),
    );
  }
}