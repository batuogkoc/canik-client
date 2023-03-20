import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../views/add_gun_home.dart';
import 'app_bar_sfs.dart';
import 'background_image_sfs_widget.dart';

class SfsErrorPage extends StatefulWidget {
  const SfsErrorPage({Key? key}) : super(key: key);

  @override
  State<SfsErrorPage> createState() => _SfsErrorPageState();
}

class _SfsErrorPageState extends State<SfsErrorPage> {
  bool isClick = false;
  String titleText = "How fix incorrect trigger pull";
  String SubText1 = "This occurs when the shooter exerts excessive forward pressure with the heel of the hand as the gun is fired. This pressure forces the front sight up just as the trigger trips the sear. It will usually result in a shot group high near the 12:00 position on the target.";
  String SubText2 = "Diagnosing and fixing trigger control heeling errors (as well as any of these errors) is not an exact science because several other factors may be involved, like problems with proper grip, sight alignment, sight picture, stable stance, etc. A complete and deliberate focus on the front sight, both mentally and visually, will usually help cure this error.";
  String errorText = "do not anticipate recoil, do not push the heel of the hand forward when the shot breaks, and do not break your wrist upward.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: DraggableBottomSheet(
        backgroundWidget: Stack(
          children:[
            BackgroundImageForSfs(),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const CustomAppBarForSfs(),
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {
                      setState(() {
                        isClick = true;
                      });
                    }, child:const Text("Show")),
                    ElevatedButton(onPressed: () {
                      setState(() {
                        isClick = false;
                      });
                    }, child:const Text("Hide")),
                  ],
                ),
              ),
            )
          ]
          
        ),
        previewChild:isClick ? Container(
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
            color: projectColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: projectColors.white1)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Error Page : Title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ):const SizedBox(height: 0,),
        expandedChild: Container(
        decoration: BoxDecoration(
          color: projectColors.black,
         borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
        ),  
        child: 
        Padding(
          padding: const EdgeInsets.only(right: 20,left: 20),
          child: ListView(
            physics:const NeverScrollableScrollPhysics(),
            children: [
               Padding(
                 padding: const EdgeInsets.only(top: 15,bottom: 40,right: 150,left: 150),
                 child: Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                           ),
               ),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 100.h > 1200 ? 15.h : 10.h,
                  decoration: BoxDecoration(color: projectColors.black2,borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20,top: 10,left: 20,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text("Do",style: TextStyle(color: projectColors.blue,fontSize: 40,fontWeight: FontWeight.w900),),
                        SizedBox(
                          child:Stack(
                            children: [
                              Image.asset("assets/images/Vector.png",fit: BoxFit.cover,),
                              Positioned(
                                right: 22,
                                top: 42,
                                child: Image.asset("assets/images/Rectangle 95.png",fit: BoxFit.cover,)),
                              Positioned(
                                right: 2,
                                top: 30,
                                child: Image.asset("assets/images/Rectangle 96.png",fit: BoxFit.cover,)),
                            ],
                          ) ,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.h > 1200 ? 15.h : 10.h,
                decoration: BoxDecoration(color: projectColors.black2,borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20,top: 10,left: 20,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text("Don't",style: TextStyle(color: projectColors.black3,fontSize: 40,fontWeight: FontWeight.w900),),
                      SizedBox(
                        child:Stack(
                          children: [
                            Image.asset("assets/images/Vector.png",fit: BoxFit.cover,),
                            Positioned(
                              right: 2,
                              top: 32,
                              child: Image.asset("assets/images/Rectangle 93.png",fit: BoxFit.cover,)),
                            Positioned(
                              right: 2,
                              top: 32,
                              child: Image.asset("assets/images/Rectangle 94.png",fit: BoxFit.cover,)),
                          ],
                        ) ,
                      )
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(titleText,style: TextStyle(color: projectColors.white,fontSize:100.h>1200 ? 35 : 24,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15,top: 10),
                child: Text(SubText1,style: TextStyle(color: projectColors.white1,fontSize:100.h>1200 ? 30 : 17,fontWeight: FontWeight.w500,height: 1.5),textAlign: TextAlign.left,),
              ),
              Container(
                height: 100.h>1200 ? 8.h : 11.h,
                decoration: BoxDecoration(
                  color: projectColors.blue,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const Expanded(
                        flex: 1,
                        child:  Icon(Icons.error_outline_outlined)),
                      Expanded(
                        flex: 6,
                        child: Text(errorText,style: TextStyle(color: Colors.black,fontSize:100.h > 1200 ? 28 : 15,fontWeight: FontWeight.w500),textAlign: TextAlign.left,))
                    ],
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(bottom: 15,top: 10),
                child: Text(SubText2,style: TextStyle(color: projectColors.white1,fontSize:100.h>1200 ? 30 : 17,fontWeight: FontWeight.w500,height: 1.5),textAlign: TextAlign.left,),
              ),
              Padding(
                padding:100.h>1200 ?EdgeInsets.only(top: 25) :  EdgeInsets.zero,
                child: ElevatedButton(onPressed: () {
                  
                }, 
                style: ElevatedButton.styleFrom(
                fixedSize:100.h>1200 ? Size(400, 70) :  Size(400, 44),
                primary:  projectColors.black2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:  BorderSide(color: projectColors.white, width: 1.5),
                )),  
                child:Text("CANCEL",style: TextStyle(color: projectColors.white,fontSize: 18,fontWeight: FontWeight.w900),)),
              )
            ],
          ),
        ),),
        expansionExtent: 10,
        minExtent: 160,
        maxExtent: MediaQuery.of(context).size.height,
        ),
    );
  }
}