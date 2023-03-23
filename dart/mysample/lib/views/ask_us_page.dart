import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/cubit/asked_question_cubit.dart';
import 'package:mysample/entities/frequently_asked_question.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../widgets/background_image_widget.dart';

class AskUsPage extends StatefulWidget {
  const AskUsPage({Key? key}) : super(key: key);

  @override
  State<AskUsPage> createState() => _AskUsPageState();
}

class _AskUsPageState extends State<AskUsPage> {
  // double scaleNumber = 1;
  // double oldNumber = 1;
  Future<void> getAskedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language')!;
    context.read<AskedQuestionCubit>().getAllFrequentlyAskedQuestions(language);
  }
  // CalcscaleNumber(bool expandorNot){
  //   switch (expandorNot) {
  //     case true:
  //       setState(() {
  //         oldNumber = scaleNumber;
  //         scaleNumber = scaleNumber + (oldNumber/4) ;
  //       });
        
  //     break;
  //     case false:
  //       setState(() {
  //         scaleNumber = scaleNumber - (scaleNumber/5) ;
  //       });
        
  //       break;
  //     default:
  //   }
    
  // }
  @override
  void initState() {
    super.initState();
    getAskedQuestions();
  }

  @override
  Widget build(BuildContext context) {
    String askUsText = AppLocalizations.of(context)!.ask_for_uss;
    String helloText = AppLocalizations.of(context)!.hello_text;
    String howCanHelpText = AppLocalizations.of(context)!.how_can_help;
    String frequentlyAskedQuestionText = AppLocalizations.of(context)!.frequently_asked_question;

    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(text: askUsText),
          body: ListView(
            physics:const BouncingScrollPhysics(),
            children: [
              Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        helloText,
                        style:  TextStyle(
                            fontSize: 17.sp,
                            color: Colors.white,
                            letterSpacing: 1.0,
                            fontFamily: 'Built',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 4.h,
                        child: Image.asset('assets/images/hello_hand.png', fit: BoxFit.contain,)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    howCanHelpText,
                    style: TextStyle(
                        fontSize: 13.sp, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.normal),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: projectColors.black,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: projectColors.black2,
                            width: 2,
                          )),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      frequentlyAskedQuestionText,
                                      style:
                                           TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: SizedBox(
                                    height: 3.h,
                                    child: Image.asset('assets/images/question_mark.png',fit: BoxFit.contain)),
                                  )
                                ],
                              ),
                            ),
                           BlocBuilder<AskedQuestionCubit, List<FrequentlyAskedQuestion>>(
                            builder: (context, questions) {
                              if (questions.isNotEmpty) {
                                return  SizedBox(
                                  height: 55.h,
                                  child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: questions.length,
                                        itemBuilder: ((context, index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                                                child: Text(questions[index].title,style: TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.bold)),
                                              ),
                                              Padding(
                                              padding: const EdgeInsets.only(left: 15,right: 15,top: 5),
                                              child: Text(questions[index].explanation,style: TextStyle(color: Colors.white,fontSize: 11.sp)),
                                              ),
                                              
                                            ],
                                          );
                              })),
                                );
                            }
                            else {
                              return const Center();
                            }
                            })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            ],
         ),
        )]
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

// class _AskedQuestionBloc extends StatefulWidget {
//   final Function scaleNumberFunc;
//   final double scaleNumber;
//   const _AskedQuestionBloc({
//     required this.scaleNumberFunc,
//     required this.scaleNumber,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<_AskedQuestionBloc> createState() => _AskedQuestionBlocState();
// }

// class _AskedQuestionBlocState extends State<_AskedQuestionBloc> {
 
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AskedQuestionCubit, List<FrequentlyAskedQuestion>>(
//       builder: (context, questions) {
//         if (questions.isNotEmpty) {
//           return 100.h > 1080 ? SizedBox(
//             height: questions.length*widget.scaleNumber*8.5.h,
//             child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: questions.length,
//                 itemBuilder: ((context, index) {
//                   return
//                 ListTileTheme(
//                 contentPadding: const EdgeInsets.only(right: 10,top: 20),
//                 child: ExpansionTile(
//                   title: Padding(
//                     padding: const EdgeInsets.only(left: 15),
//                     child: Text(questions[index].title,style: TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500),),
//                   ),
//                   collapsedBackgroundColor: projectColors.black,
//                   backgroundColor: projectColors.black,
//                   iconColor: projectColors.white,
//                   // trailing: Icon(Icons.arrow_drop_down,size: 4.h,),
//                   collapsedIconColor: projectColors.white,
//                   controlAffinity: ListTileControlAffinity.trailing,
//                   onExpansionChanged: (value) async {
//                     if (value) {
//                       widget.scaleNumberFunc(true);
//                     } else {
//                       widget.scaleNumberFunc(false);
//                     }
//                   },
//                   initiallyExpanded: false,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Text(questions[index].explanation,style: TextStyle(color: Colors.white,fontSize: 11.sp)),
//                     )
//                    ],
//                 ),
//               );
//               })),
//           ):
//           SizedBox(
//             height: questions.length*widget.scaleNumber*8.h,
//             child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: questions.length,
//                 itemBuilder: ((context, index) {
//                   return
//                 ListTileTheme(
//                 contentPadding: const EdgeInsets.only(right: 10),
//                 child: ExpansionTile(
//                   title: Padding(
//                     padding: const EdgeInsets.only(left: 15),
//                     child: Text(questions[index].title,style: TextStyle(color: Colors.white,fontSize: 13.sp,fontWeight: FontWeight.w500),),
//                   ),
//                   collapsedBackgroundColor: projectColors.black,
//                   backgroundColor: projectColors.black,
//                   iconColor: projectColors.white,
//                   // trailing: Icon(Icons.arrow_drop_down,size: 4.h,),
//                   collapsedIconColor: projectColors.white,
//                   controlAffinity: ListTileControlAffinity.trailing,
//                   onExpansionChanged: (value) async {
//                     if (value) {
//                      widget.scaleNumberFunc(true);
//                     } else {
//                      widget.scaleNumberFunc(false);
//                     }
//                   },
//                   initiallyExpanded: false,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
//                       child: Text(questions[index].explanation,style: TextStyle(color: Colors.white,fontSize: 12.sp)),
//                     )
//                    ],
//                 ),
//               );
//               })),
//           )
          
          
          
//           ;
//         } else {
//           return const Center();
//         }
//       },
//     );
//   }
// }
