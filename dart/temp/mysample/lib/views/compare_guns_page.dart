import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/constants/constan_text_styles.dart';
import 'package:mysample/product/utility/is_tablet.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../cubit/compare_weapon_cubit.dart';
import '../entities/response/compare_weapon_response.dart';
import '../widgets/app_bar_icon_widget.dart';
import '../widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class CompareGunsPage extends StatefulWidget {
  const CompareGunsPage({Key? key}) : super(key: key);

  @override
  State<CompareGunsPage> createState() => _CompareGunsPageState();
}

class _CompareGunsPageState extends State<CompareGunsPage> {

  final  ProjectTextStyles projectTextStyles = ProjectTextStyles();
  double perPropHeigh = 10.h;
  getCompareWeapons() async{
   await context.read<CompareWeaponCubit>().getAllCompareWeapons();
   
  }

  @override
  void initState() {
    
    getCompareWeapons();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const CustomAppBarWithImage(
            index: 2,
            imagePath: 'assets/images/canik_super.png'),
         body: Padding(
           padding: const EdgeInsets.only(bottom: 50),
           child: ListView(
            padding: EdgeInsets.zero,
            physics:const BouncingScrollPhysics(),
            shrinkWrap: true,
             children:[
              Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                   decoration:BoxDecoration(color: projectColors.black,
                   
                   borderRadius: BorderRadius.circular(20)
                   ),
                   width: MediaQuery.of(context).size.width/3,
                   height: IsTablet().isTablet() ? 105.h : 105.h,
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Container(
                        height: 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Transform.rotate(
                            angle: 45 * math.pi / 180,
                            child: Icon(Icons.compare_arrows_sharp,size: 5.h,color: Colors.white,)),
                        )),
                       Container(
                        height: IsTablet().isTablet() ? 5.h : 100.h < 700 ? 6.h : 5.h,
                         decoration: BoxDecoration(borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color:projectColors.blue,),
                         width: MediaQuery.of(context).size.width,
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Center(child: Text(AppLocalizations.of(context)!.features,
                           style: IsTablet().isTablet() ? projectTextStyles.gunNameTabletTextStyle : projectTextStyles.gunNameTextStyle,textAlign: TextAlign.center,)),
                         )),
                       

                       Container(
                       color: projectColors.black,
                       height:perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.gun_series,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       color: projectColors.black2,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_weight,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       height: perPropHeigh,
                       color: projectColors.black,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_bullet_capacity,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       color: projectColors.black2,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_gun_material,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       color: projectColors.black,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_full_automatic,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       color: projectColors.black2,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_cyclic_rate,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                       Container(
                       color: projectColors.black,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.comparison_guns_bullet_type,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                         
                       Container(
                       color: projectColors.black2,
                       height: perPropHeigh,
                       child: Align(
                         alignment: Alignment.center,
                         child: 
                         Text(AppLocalizations.of(context)!.other,
                         style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTitleTabletTextStyle : projectTextStyles.gunProperyNameTitleTextStyle,textAlign: TextAlign.center))),
                     ],
                    ),
                  ),
                  // Tekli Horizontal Hareket Olmayan Column
                  // Container(
                  //  decoration:BoxDecoration(color: projectColors.white,
                  //  borderRadius: BorderRadius.circular(20)),
                  //  width: MediaQuery.of(context).size.width/3,
                  //  height:100.h < 600 ? 150.h
                  //             : 100.h > 700 ? 115.h 
                  //             : 130.h,
                  //   child: Column(
                  //    mainAxisAlignment: MainAxisAlignment.center,
                  //    crossAxisAlignment: CrossAxisAlignment.center,
                  //    children: [
                  //      Container(
                  //       height: 100,
                  //       child: 
                  //       Padding(
                  //         padding: const EdgeInsets.all(10),
                  //         child: Image.asset('assets/images/homepage_gun_1.png',fit: BoxFit.cover),
                  //       )),
                  //      Container(
                  //        decoration: BoxDecoration(borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color:projectColors.blue,),
                  //        width: MediaQuery.of(context).size.width,
                  //        child: Padding(
                  //          padding: const EdgeInsets.all(10.0),
                  //          child: Center(child: Text("TP 9 SF ELİTE",style: TextStyle(color: projectColors.white,fontSize: 20),textAlign: TextAlign.center,)),
                  //        )),
                       
                  //      Container(
                  //       color: projectColors.darkwhite,
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text("5 kg - 8kg",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //      Container(
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text("16/16",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //      Container(
                  //       color: projectColors.darkwhite,
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text("Çelik",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //       Container(
                  //       height: 100,
                  //        child: const Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Padding(
                  //            padding: EdgeInsets.zero,
                  //            child: Icon(Icons.assignment_turned_in_sharp,color: Colors.green,),
                  //          )),
                  //      ),
                  //      Container(
                  //       color: projectColors.darkwhite,
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text("200 km/s",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //      Container(
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text("5.56",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //      Container(
                  //       color: projectColors.darkwhite,
                  //       height: 100,
                  //        child: Align(
                  //          alignment: Alignment.center,
                  //          child: 
                  //          Text(" - ",style: TextStyle(color: projectColors.black,fontSize: 20),textAlign: TextAlign.center,)),
                  //      ),
                  //    ],
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3,
                    // 1920 : 683
                    // 1280 : 590
                    // 2200 : 780
                    height: IsTablet().isTablet() ? 105.h :  105.h,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: BlocBuilder<CompareWeaponCubit,CompareAllWeapons>(
                        builder: (context, state) {
                          if (state.result.isNotEmpty) {
                            return  ListView.builder(
                          itemCount: state.result.length,
                          padding: EdgeInsets.zero,
                          physics:const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                           decoration:BoxDecoration(color: projectColors.white,
                           border: Border(
                            right: BorderSide(color: projectColors.blue,width: 1),
                            left:BorderSide(color: projectColors.blue,width: 1), 
                            top:BorderSide(color: projectColors.blue,width: 1),
                            bottom:BorderSide(color: projectColors.blue,width: 1),
                            ),
                            borderRadius: BorderRadius.circular(20)
                            ),
                           width: MediaQuery.of(context).size.width/3,
                           height: height,
                            child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Container(
                                height: 12.h,
                                child:
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset('assets/images/homepage_gun_2.png',fit: BoxFit.cover),
                                )),
                               Container(
                                height: IsTablet().isTablet() ? 5.h : 100.h < 700 ? 6.h : 5.h,
                                 decoration: BoxDecoration(borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color:projectColors.blue,),
                                 width: MediaQuery.of(context).size.width,
                                 child: Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Center(child: Text(state.result[index].categoryName,style:IsTablet().isTablet() ? projectTextStyles.gunNameTabletTextStyle : projectTextStyles.gunNameTextStyle,textAlign: TextAlign.center,)),
                                 )),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text(state.result[index].parentProductCategoryName,style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),  
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("6 kg",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("12/12",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("Çelik / Dökme Demir",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child:const Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Padding(
                                     padding: EdgeInsets.zero,
                                     child: Icon(Icons.error_outline,color: Colors.red,),
                                   )),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("150 km/s",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("5.56",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text(" - ",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                             ],
                            ),
                          );
                          },
                          );
                          }
                          else{
                            return const Center();
                          }
                        },
                       ),
                    ),
                  ),
                
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3,
                    // 1920 : 683
                    // 1280 : 590
                    // 2200 : 780
                    height: IsTablet().isTablet() ? 105.h : 105.h,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: BlocBuilder<CompareWeaponCubit,CompareAllWeapons>(
                        builder: (context, state) {
                          if (state.result.isNotEmpty) {
                            return  ListView.builder(
                          itemCount: state.result.length,
                          padding: EdgeInsets.zero,
                          physics:const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                           decoration:BoxDecoration(color: projectColors.white,
                           border: Border(
                            right: BorderSide(color: projectColors.blue,width: 1),
                            left:BorderSide(color: projectColors.blue,width: 1), 
                            top:BorderSide(color: projectColors.blue,width: 1),
                            bottom:BorderSide(color: projectColors.blue,width: 1),
                            ),
                            borderRadius: BorderRadius.circular(20)
                            ),
                           width: MediaQuery.of(context).size.width/3,
                           height: height,
                            child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Container(
                                height: 12.h,
                                child:
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset('assets/images/homepage_gun_2.png',fit: BoxFit.cover),
                                )),
                               Container(
                                height: IsTablet().isTablet() ? 5.h : 100.h < 700 ? 6.h : 5.h,
                                 decoration: BoxDecoration(borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color:projectColors.blue,),
                                 width: MediaQuery.of(context).size.width,
                                 child: Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Center(child: Text(state.result[index].categoryName,style:IsTablet().isTablet() ? projectTextStyles.gunNameTabletTextStyle : projectTextStyles.gunNameTextStyle,textAlign: TextAlign.center,)),
                                 )),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text(state.result[index].parentProductCategoryName,style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),  
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("6 kg",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("12/12",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("Çelik / Dökme Demir",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child:const Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Padding(
                                     padding: EdgeInsets.zero,
                                     child: Icon(Icons.error_outline,color: Colors.red,),
                                   )),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("150 km/s",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text("5.56",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                               Container(
                                color: projectColors.darkwhite,
                                height: perPropHeigh,
                                 child: Align(
                                   alignment: Alignment.center,
                                   child: 
                                   Text(" - ",style: IsTablet().isTablet() ? projectTextStyles.gunProperyNameTabletTextStyle : projectTextStyles.gunProperyNameTextStyle,textAlign: TextAlign.center,)),
                               ),
                             ],
                            ),
                          );
                          },
                          );
                          }
                          else{
                            return const Center();
                          }
                        },
                       ),
                    ),
                  ),
                
                         
                ],
              ),
              ]),
         )
            ,   
        )
      ],
    );
  }
}