import 'package:flutter/material.dart';
import 'package:mysample/entities/new.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color_constants.dart';
import '../widgets/app_bar_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpecialDetailNews extends StatelessWidget {
  New singleNew;
  SpecialDetailNews({Key? key, required this.singleNew}) : super(key: key);

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  ProjectColors projectColors = ProjectColors();

  @override
  Widget build(BuildContext context) {
    String newsDetail = AppLocalizations.of(context)!.news_detail;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: CustomAppBarWithText(text: newsDetail),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: projectColors.black),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                singleNew.imageUrl != null
                    ? Image.network(
                        singleNew.imageUrl!,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        height: 200,
                      )
                    : Image.asset(
                        "assets/images/special_img.png",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          singleNew.title,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white,height: 1.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          singleNew.date.toString(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: projectColors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          singleNew.explanation,
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300,height: 1.5),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(width: 56, height: 56),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    primary: projectColors.blue),
                                onPressed: () {
                                  Share.share(singleNew.explanation);
                                },
                                child: const Icon(Icons.share_outlined, size: 16),
                              ),
                            ),
                            singleNew.youtubeUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Uri url = Uri.parse(singleNew.youtubeUrl!);
                                          _launchUrl(url);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: projectColors.blue,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset('assets/images/youtube_img.png'),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)!.watch_video.toUpperCase(),
                                                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                              const Icon(Icons.keyboard_arrow_right_outlined)
                                            ],
                                          ),
                                        )),
                                  )
                                : const Center(),
                            singleNew.url != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Uri url = Uri.parse(singleNew.url!);
                                          _launchUrl(url);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: projectColors.blue,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset('assets/images/link_img.png'),
                                                  const SizedBox(
                                                    width: 17,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)!.review_link.toUpperCase(),
                                                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                              const Icon(Icons.keyboard_arrow_right_outlined)
                                            ],
                                          ),
                                        )),
                                  )
                                : const Center(),
                            singleNew.pdfUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Uri url = Uri.parse(singleNew.pdfUrl!);
                                          _launchUrl(url);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: projectColors.black,
                                          fixedSize: const Size(315, 52),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/images/pdf_img.png'),
                                                const SizedBox(
                                                  width: 17,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!.review_pdf.toUpperCase(),
                                                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                            const Icon(Icons.keyboard_arrow_right_outlined)
                                          ],
                                        )),
                                  )
                                : const Center(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
