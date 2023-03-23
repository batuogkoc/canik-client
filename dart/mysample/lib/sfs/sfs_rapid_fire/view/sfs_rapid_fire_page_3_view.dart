import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/widgets/sfs_bottom_circle_buttons.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../widgets/background_image_sfs_widget.dart';

class SfsRapidFirePageView3 extends StatefulWidget {
  const SfsRapidFirePageView3({Key? key}) : super(key: key);

  @override
  State<SfsRapidFirePageView3> createState() => _SfsRapidFirePageView3State();
}

class _SfsRapidFirePageView3State extends State<SfsRapidFirePageView3> {
  List<int> mockListData = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  List<bool> isClick = [];
  @override
  void initState() {
    isClick = List<bool>.filled(mockListData.length, false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Image.asset(
          "assets/images/image_9.png",
          height: context.height,
          width: context.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar:const _CustomAppBarRapidFire(),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Padding(
                  padding:  EdgeInsets.only(left: 5),
                  child:  _ArchOfMovement(),
                ),
                Image.asset("assets/images/rapid_fire_arch_image.png",fit: BoxFit.cover,),
                const SizedBox(height: 15,),
                Container(
                  height: 350,
                  decoration: BoxDecoration(color: ProjectColors().black,borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15,left: 20,right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(AppLocalizations.of(context)!.sfs_page3_title,style: TextStyle(color: ProjectColors().white,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                          )),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                              flex: 1,
                              child: Text(AppLocalizations.of(context)!.sfs_page3_shot,style: TextStyle(color: ProjectColors().black3,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                              Expanded(
                                flex: 1,
                                child: Text(AppLocalizations.of(context)!.sfs_page3_score,style: TextStyle(color: ProjectColors().black3,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                              Expanded(
                                flex: 1,
                                child: Text(AppLocalizations.of(context)!.sfs_page3_time,style: TextStyle(color: ProjectColors().black3,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                              Expanded(
                                flex: 1,
                                child: Text(AppLocalizations.of(context)!.sfs_page3_split,style: TextStyle(color: ProjectColors().black3,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: mockListData.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(!isClick[index]){
                                        isClick[index] = true;
                                      }
                                      else{
                                        isClick[index] = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration:isClick[index]?BoxDecoration(color: ProjectColors().blue) : mockListData[index] %2 != 0 ?  BoxDecoration(color: ProjectColors().black2) : BoxDecoration(color: ProjectColors().black),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(mockListData[index].toString(),style: TextStyle(color: ProjectColors().white,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        Expanded(
                                          flex: 1,
                                          child: Text("66.7",style: TextStyle(color: ProjectColors().white,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        Expanded(
                                          flex: 1,
                                          child: Text("5.54",style: TextStyle(color: ProjectColors().white,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        Expanded(
                                          flex: 1,
                                          child: Text("1.87",style: TextStyle(color: ProjectColors().white,fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                             
                                
                              
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SfsBottomCircleButtons(index: 3))
                      
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
        bottomNavigationBar:const _CustomBottomBarPauseCancelFinish(),  

        )
      ],
    );
  }
}
class _ArchOfMovement extends StatelessWidget {
  const _ArchOfMovement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.arch_of_movenent,
          style: _SfsRapidTextStyles.akhand17,
        ),
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.white,
              size: 12,
            ))
      ],
    );
  }
}
class _CustomAppBarRapidFire extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBarRapidFire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 10.h,
      title: Image.asset('assets/images/rapid_fire_app_bar_image.png'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.h, top: 5.h),
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Image.asset(
                'assets/images/close_icon.png',
              )),
        )
      ],
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(10.h);
}

class _SfsRapidTextStyles {
  static const TextStyle akhand57 = TextStyle(fontSize: 57, fontWeight: FontWeight.w500, color: Colors.white);
  static const TextStyle akhand17 = TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white);
  static const TextStyle akhand14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle akhand10 = TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white);
  static const TextStyle built17 =
      TextStyle(fontFamily: 'Built', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
}

class _CustomBottomBarPauseCancelFinish extends StatelessWidget {
  const _CustomBottomBarPauseCancelFinish({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('CANCEL', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(onTap: () {}, child: Image.asset('assets/images/close-circle.png'))
            ],
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: ProjectColors().blue,
                shape: const CircleBorder(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.pause_sharp,
                  color: Colors.black,
                ),
              )),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('FINISH', style: _SfsRapidTextStyles.built17),
              ),
              InkWell(onTap: () {}, child: Image.asset('assets/images/stop-circle.png'))
            ],
          )
        ],
      ),
    );
  }
}
