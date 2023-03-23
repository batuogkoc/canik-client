import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:mysample/product/utility/image_paths/image_path.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:mysample/widgets/image_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SfsModesSettingsPage extends StatefulWidget {
  final String imageurl;
  const SfsModesSettingsPage({required this.imageurl, Key? key}) : super(key: key);

  @override
  State<SfsModesSettingsPage> createState() => _SfsModesSettingsPageState();
}

class _SfsModesSettingsPageState extends State<SfsModesSettingsPage> {
  bool isSelected = false;
  bool isRight = false;
  bool isClick1 = false;
  bool isClick2 = false;
  bool isClick3 = false;
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
          appBar: const _CustomAppBarRapidFire(),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: projectColors.white1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: widget.imageurl.isNullOrEmpty
                          ? Image.asset(
                              "assets/images/placeholdergun.png",
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              widget.imageurl,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true, context: context, builder: (context) => buildSheet());
                    },
                    child: SizedBox(
                      width: 80.w,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: projectColors.white,
                          radius: const Radius.circular(25),
                          child: Container(
                            width: 80.w,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(25), color: projectColors.black),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                AppLocalizations.of(context)!.choose_your_canik,
                                style: TextStyle(color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 80.w,
                      child: Divider(
                        color: projectColors.white1,
                        thickness: 1,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.dominant_hand,
                    style: TextStyle(color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 80.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: projectColors.black),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !isRight
                              ? Container(
                                  decoration:
                                      BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 45),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.front_hand,
                                          color: Colors.yellow,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.left_hand,
                                          style: TextStyle(
                                              color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRight = false;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.front_hand,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.left_hand,
                                        style: TextStyle(
                                            color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                          isRight
                              ? Container(
                                  decoration:
                                      BoxDecoration(color: projectColors.blue, borderRadius: BorderRadius.circular(25)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 45, right: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.right_hand,
                                          style: TextStyle(
                                              color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.back_hand,
                                          color: Colors.yellow,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRight = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.right_hand,
                                        style: TextStyle(
                                            color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.back_hand,
                                        color: Colors.yellow,
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 80.w,
                      child: Divider(
                        color: projectColors.white1,
                        thickness: 1,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.level,
                    style: TextStyle(color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Theme(
                              child: Checkbox(
                                shape: const CircleBorder(),
                                checkColor: Colors.white,
                                value: isClick1,
                                onChanged: (value) {
                                  setState(() {
                                    isClick1 = value!;
                                    isClick2 = false;
                                    isClick3 = false;
                                  });
                                },
                              ),
                              data: ThemeData(primarySwatch: Colors.blue, unselectedWidgetColor: projectColors.white1),
                            ),
                            Text(
                              AppLocalizations.of(context)!.beginner,
                              style: TextStyle(
                                  color: isClick1 ? projectColors.white : projectColors.white1,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Theme(
                              child: Checkbox(
                                shape: const CircleBorder(),
                                checkColor: Colors.white,
                                value: isClick2,
                                onChanged: (value) {
                                  setState(() {
                                    isClick2 = value!;
                                    isClick1 = false;
                                    isClick3 = false;
                                  });
                                },
                              ),
                              data: ThemeData(primarySwatch: Colors.blue, unselectedWidgetColor: projectColors.white1),
                            ),
                            Text(
                              AppLocalizations.of(context)!.intermediate,
                              style: TextStyle(
                                  color: isClick2 ? projectColors.white : projectColors.white1,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Theme(
                              child: Checkbox(
                                shape: const CircleBorder(),
                                checkColor: Colors.white,
                                value: isClick3,
                                onChanged: (value) {
                                  setState(() {
                                    isClick3 = value!;
                                    isClick2 = false;
                                    isClick1 = false;
                                  });
                                },
                              ),
                              data: ThemeData(primarySwatch: Colors.blue, unselectedWidgetColor: projectColors.white1),
                            ),
                            Text(
                              AppLocalizations.of(context)!.pro,
                              style: TextStyle(
                                  color: isClick3 ? projectColors.white : projectColors.white1,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: projectColors.white1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                fixedSize: Size(30.w, 50),
                                primary: projectColors.black2),
                            child: Text(
                              AppLocalizations.of(context)!.close,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // showModalBottomSheet(isScrollControlled: true,context: context, builder: (context) => buildSheet());
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                fixedSize: Size(45.w, 50),
                                primary: projectColors.blue),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.continue_button,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const AssetImageWidget(imagePath: ImagePath.icArrowRight)
                              ],
                            )),
                      ],
                    ),
                  )
                ]),
          ),
        )
      ],
    );
  }

  StatefulBuilder buildSheet() => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            color: projectColors.black,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 75,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    AppLocalizations.of(context)!.choose_your_training_gun,
                    style: TextStyle(color: projectColors.white, fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GridView.builder(
                          itemCount: 24,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SfsModesSettingsPage(
                                                imageurl: "assets/images/gun_details_1.png")));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: projectColors.white1,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/images/gun_details_1.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ))),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "TP9 SUB METE",
                                  style:
                                      TextStyle(color: projectColors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
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
      title: Image.asset('assets/images/settings_app_bar.png'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 25),
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
