// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mysample/constants/constan_text_styles.dart';
import 'package:mysample/cubit/campaign_cubit.dart';
import 'package:mysample/cubit/special_page_cubit.dart';
import 'package:mysample/entities/new.dart';
import 'package:mysample/views/special_detail_for_news.dart';
import 'package:mysample/views/special_details_page.dart';
import 'package:mysample/widgets/background_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../constants/color_constants.dart';
import '../entities/campaign.dart';

class Special extends StatefulWidget {
  const Special({Key? key}) : super(key: key);

  @override
  State<Special> createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
  String language = "";
  String country = '';
  String postCountryParameter = '';
  List<String> countries = ['Türkiye', 'Amerika', 'İngiltere', 'Avustralya'];

  Future<void> getNews() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('idToken');
    Map<String, dynamic> payload = token != null ? Jwt.parseJwt(token) : Jwt.parseJwt('');

    setState(() {
      language = prefs.getString('language')!.toUpperCase();
      country = payload['country'];
    });
    for (var i = 0; i < countries.length; i++) {
      if (country == countries[i]) {
        postCountryParameter = (i + 1).toString();
      } else {
        postCountryParameter = '1';
      }
    }
    print(language);

    await context.read<SpecialPageCubit>().getNews(language);
    await context.read<CampaignCubit>().getCampaigns(language);
  }

  ProjectColors projectColors = ProjectColors();

  @override
  void initState() {
    super.initState();
    getNews();
  }

  final ProjectTextStyles _projectTextStyles = ProjectTextStyles();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double _specialSizedBoxHeight = 220;
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: _SpecialPagePadding._specialPageAllPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: _SpecialPagePadding._specialCampaignPadding,
                            child: Text(AppLocalizations.of(context)!.special_offers_for_you,
                                textAlign: TextAlign.start,
                                style: 100.h < 1200
                                    ? ProjectTextStyles.popUpTitleTextStyle
                                    : TextStyle(
                                        fontSize: 26,
                                        fontFamily: 'Built',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                          ),
                          100.h < 1200
                              ? _speciaForYou(_specialSizedBoxHeight, false, language)
                              : _speciaForYou(_specialSizedBoxHeight * 1.6, true, language),
                          Padding(
                            padding: _SpecialPagePadding._specialCampaignPadding,
                            child: Text(AppLocalizations.of(context)!.news_and_events,
                                style: 100.h < 1200
                                    ? ProjectTextStyles.popUpTitleTextStyle
                                    : TextStyle(
                                        fontSize: 26,
                                        fontFamily: 'Built',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                          ),
                          100.h < 1200
                              ? _specialForNewsAndActivities(_specialSizedBoxHeight * 2.15, false, language)
                              : _specialForNewsAndActivities(_specialSizedBoxHeight * 3.5, true, language),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  SizedBox _speciaForYou(double height, bool isTablet, String language) {
    return !isTablet
        ? SizedBox(
            height: height,
            child: BlocBuilder<CampaignCubit, List<Campaign>>(
              builder: (context, campaigns) {
                if (campaigns.isNotEmpty) {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: campaigns.length,
                    itemBuilder: (_, index) =>
                        newCard(campaign: campaigns[index], index: index, isTablet: false, language: language),
                    separatorBuilder: (_, index) => SizedBox(width: 10),
                  );
                } else {
                  return Center();
                }
              },
            ),
          )
        : SizedBox(
            height: height,
            child: BlocBuilder<CampaignCubit, List<Campaign>>(
              builder: (context, campaigns) {
                if (campaigns.isNotEmpty) {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: campaigns.length,
                    itemBuilder: (_, index) =>
                        newCard(campaign: campaigns[index], index: index, isTablet: true, language: language),
                    separatorBuilder: (_, index) => SizedBox(width: 10),
                  );
                } else {
                  return Center();
                }
              },
            ),
          );
  }

  SizedBox _specialForNewsAndActivities(double height, bool isTablet, String language) {
    return !isTablet
        ? SizedBox(
            height: height,
            child: BlocBuilder<SpecialPageCubit, List<New>>(
              builder: (context, news) {
                if (news.isNotEmpty) {
                  return GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 220,
                      ),
                      itemCount: news.length,
                      itemBuilder: (_, index) {
                        var singleNew = news[index];

                        return newImageCard(singleNew: singleNew, index: index, isTablet: false, language: language);
                      });
                } else {
                  return Center();
                }
              },
            ),
          )
        : SizedBox(
            height: height,
            child: BlocBuilder<SpecialPageCubit, List<New>>(
              builder: (context, news) {
                if (news.isNotEmpty) {
                  return GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 360,
                      ),
                      itemCount: news.length,
                      itemBuilder: (_, index) {
                        var singleNew = news[index];

                        return newImageCard(singleNew: singleNew, index: index, isTablet: true, language: language);
                      });
                } else {
                  return Center();
                }
              },
            ),
          );
  }

  Widget buildIMageCard({required New singleNew, required index}) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpecialDetailNews(singleNew: singleNew),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: singleNew.imageUrl != null ? _newDecorationImage(singleNew) : _imageUrlNull(),
              color: projectColors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: index == 0
                      ? projectColors.blue
                      : index == 1
                          ? projectColors.blue
                          : Colors.transparent,
                  style: BorderStyle.solid,
                  width: 3.0),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(singleNew.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      );

  DecorationImage _imageUrlNull() => DecorationImage(image: AssetImage('assets/images/special_img.png'));

  DecorationImage _newDecorationImage(New singleNew) => DecorationImage(image: NetworkImage(singleNew.imageUrl!));

  Widget buildCard({required Campaign campaign, required index}) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpecialDetails(
                        campaign: campaign,
                        language: language,
                      )),
            );
          },
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: projectColors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: index == 0 ? projectColors.blue : Colors.transparent, style: BorderStyle.solid, width: 3.0),
            ),
            child: Container(
              decoration: campaign.imageUrl != null
                  ? _campaigncardBoxDecoration(campaign)
                  : BoxDecoration(image: _imageUrlNull()),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(campaign.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget newCard({required Campaign campaign, required index, required bool isTablet, required String language}) {
    return !isTablet
        ? Card(
            color: projectColors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: BorderSide(color: projectColors.blue, width: 3)),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SpecialDetails(
                                    campaign: campaign,
                                    language: language,
                                  )),
                        );
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: campaign.imageUrl != null
                            ?
                            CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl: campaign.imageUrl!,height: 150,
                                width: 300,
                                fit: BoxFit.cover,)
                            : Image.asset(
                                "assets/images/special_img.png",
                                height: 150,
                                width: 300,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    campaign.startDate != null ?
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                language == "EN"
                                    ? DateFormat("yyyy-MM-dd").format(DateTime.parse(campaign.startDate!))
                                    : DateFormat("dd-MM-yyyy").format(DateTime.parse(campaign.startDate!)),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):SizedBox(),
                    Positioned(
                      bottom: 5,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                AppLocalizations.of(context)!.for_you,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    campaign.title.length > 40 ? campaign.title.substring(0, 40) + '...' : campaign.title,
                    style: TextStyle(fontSize: 16, color: projectColors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        : Card(
            color: projectColors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: BorderSide(color: projectColors.blue, width: 3)),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SpecialDetails(
                                    campaign: campaign,
                                    language: language,
                                  )),
                        );
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: campaign.imageUrl != null
                        
                            ? CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl:campaign.imageUrl!,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/special_img.png",
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    campaign.startDate != null ?
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                campaign.startDate!.substring(0, 10),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):SizedBox(),
                    Positioned(
                      bottom: 6,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                AppLocalizations.of(context)!.for_you,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 12, left: 12),
                  child: Text(
                    campaign.title.length > 40 ? campaign.title.substring(0, 40) + '...' : campaign.title,
                    style: TextStyle(fontSize: 20, color: projectColors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
  }

  Widget newImageCard({required New singleNew, required index, required bool isTablet, required String language}) {
    String trDate = singleNew.date.substring(6).replaceAll(' ', '-').replaceAll('.', '-');
    String engDate = trDate.substring(6) + '-' + trDate.substring(3, 5) + '-' + trDate.substring(0, 2);
    return !isTablet
        ? Card(
            color: projectColors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: BorderSide(color: projectColors.blue, width: 3)),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecialDetailNews(singleNew: singleNew),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: singleNew.imageUrl != null
                            ?
                             CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl:singleNew.imageUrl!,
                                height: 150,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ) 
                            : Image.asset(
                                "assets/images/special_img.png",
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                language == "TR" ? trDate : engDate,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    singleNew.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: projectColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : Card(
            color: projectColors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), side: BorderSide(color: projectColors.blue, width: 3)),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecialDetailNews(singleNew: singleNew),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: singleNew.imageUrl != null
                            ?
                            CachedNetworkImage(
                              key: UniqueKey(),
                              imageUrl: singleNew.imageUrl!,
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/special_img.png",
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        decoration: BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                language == "TR" ? trDate : engDate,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, right: 12, left: 12),
                  child: Text(
                    singleNew.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24, color: projectColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
  }

  BoxDecoration _campaigncardBoxDecoration(Campaign campaign) =>
      BoxDecoration(image: DecorationImage(image: NetworkImage(campaign.imageUrl!), fit: BoxFit.fitWidth));
}

class _SpecialPagePadding {
  static const EdgeInsets _specialPageAllPadding = EdgeInsets.all(20.0);
  static const EdgeInsets _specialCampaignPadding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 15);
  static const EdgeInsets _specialNewsPadding = EdgeInsets.only(top: 20.0, bottom: 10, left: 20);
  static const EdgeInsets _specialNewsGeneralPadding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0);
}
