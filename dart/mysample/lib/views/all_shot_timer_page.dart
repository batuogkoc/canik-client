
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/views/shot_timer_home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mysample/widgets/app_bar_widget.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import '../constants/color_constants.dart';
import '../cubit/shot_timer_cubit.dart';
import '../entities/shot_timer.dart';

class AllShotTimerPage extends StatefulWidget {
  List<ShotTimerListResponseModel> shotTimerList;
  AllShotTimerPage({Key? key, required this.shotTimerList})
      : super(key: key);

  ProjectColors projectColors = ProjectColors();

  @override
  State<AllShotTimerPage> createState() => _AllShotTimerPage();
}

class _AllShotTimerPage extends State<AllShotTimerPage> {

  void refresh() {
    setState(() {});
  }
  getSearch(String name) async {
    
    await context.read<ShotTimerCubit>().listShotTimersByDeviceId().then((value) {
      widget.shotTimerList = value.where((element) => element.shotName.toLowerCase().contains(name.toLowerCase())).toList();
    },);
                    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double?  screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarWithText(text: AppLocalizations.of(context)!.all_shots),
          body: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: projectColors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    physics:const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                        child: SizedBox(
                          height: 47,
                          child: TextField(
                            onChanged: (value) async => await getSearch(value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10),
                              alignLabelWithHint: false,
                              fillColor: projectColors.black,
                              filled: false,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55),
                                borderSide: BorderSide(color: projectColors.blue, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(55),
                                borderSide: BorderSide(color: projectColors.black3, width: 1),
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                              ),
                              prefixIconColor: Colors.white,
                              hintText: AppLocalizations.of(context)!.shot_timer_hint,
                              hintStyle:
                                  TextStyle(fontSize: 17, color: projectColors.black3, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: widget.shotTimerList.length,
                        itemBuilder: (context, index) {
                          var shotTimerList = widget.shotTimerList[index];
                          // Başlangıc
                          return Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: projectColors.black),
                            child: Column(
                              children: [
                                ShotCardWidget(
                                    screenWidth: screenWidth,
                                    shotTimerListResponseModel: shotTimerList,
                                    allshottimerpage: true,
                                  ),
                                index == widget.shotTimerList.length -1 ? 
                                const SizedBox(
                                  height: 100,
                                ) : const SizedBox(
                                  height: 0,
                                )
                                ],
                                
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
  }

class ShotList {
  DateTime? dateTime;
  int? shotCounter;
  String? shotDetailName;
  String? shotDetailDesc;
  ShotList({
    this.dateTime,
    this.shotCounter,
    this.shotDetailName,
    this.shotDetailDesc,
  });
}


