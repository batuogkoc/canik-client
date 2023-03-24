import 'package:flutter/material.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../models/slide.dart';

class SlideItem extends StatefulWidget {
  int index = 0;

  SlideItem({Key? key, required this.index}) : super(key: key);
  ProjectColors projectColors = ProjectColors();

  @override
  State<SlideItem> createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  @override
  Widget build(BuildContext context) {
    final slideList = [
      Slide(
          imageUrl: 'assets/images/why_location.jpeg',
          title: AppLocalizations.of(context)!.why_location_t,
          description: AppLocalizations.of(context)!.why_location),
      Slide(
          imageUrl: 'assets/images/OnBoardingPush.jpg',
          title: AppLocalizations.of(context)!.push_notification_t,
          description: AppLocalizations.of(context)!.push_notification),
      Slide(
          imageUrl: 'assets/images/OnBoardingWeapons.jpg',
          title: AppLocalizations.of(context)!.our_products_t,
          description: AppLocalizations.of(context)!.our_products),
      Slide(
          imageUrl: 'assets/images/shotTimer.png',
          title: AppLocalizations.of(context)!.shot_timer_t,
          description: AppLocalizations.of(context)!.shot_timer),
      Slide(
          imageUrl: 'assets/images/OnBoardingPrivacy.jpg',
          title: AppLocalizations.of(context)!.personal_data_t,
          description: AppLocalizations.of(context)!.personal_data),
    ];

    return Stack(
      children: <Widget>[
        Image.asset(
          slideList[widget.index].imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          color: projectColors.black.withOpacity(0.70),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SizedBox(
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            slideList[widget.index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25, fontFamily: 'Built', fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            slideList[widget.index].description,
                            textAlign: widget.index != 4 ? TextAlign.center : TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'Akhand',
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
